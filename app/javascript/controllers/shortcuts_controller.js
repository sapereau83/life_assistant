import { Controller } from "@hotwired/stimulus"

// Global keyboard shortcuts. Attached to <body>, so it reconnects on every
// Turbo navigation — that's also how the "focus after navigation" step runs:
// a pending focus request is stashed in sessionStorage before Turbo.visit and
// applied on the next connect().
//
// Each shortcut jumps to a section and (optionally) focuses its create form.
const SHORTCUTS = {
  t: { path: "/today",          focus: "#task_title" },
  p: { path: "/weight_entries", focus: "#weight_entry_weight_kg" },
  r: { path: "/meals",          focus: "#meal_breakfast" },
  s: { path: "/workouts",       focus: "#workout_description" },
  d: { path: "/",               focus: null },
  l: { path: "/todos",          focus: null }
}
const FOCUS_KEY = "shortcut:focus"

export default class extends Controller {
  static targets = ["cheatsheet"]

  connect() {
    this.onKeydown = this.onKeydown.bind(this)
    document.addEventListener("keydown", this.onKeydown)

    // Apply a focus request left by the shortcut that navigated us here.
    const pending = sessionStorage.getItem(FOCUS_KEY)
    if (pending) {
      sessionStorage.removeItem(FOCUS_KEY)
      this.focus(pending)
    }
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
  }

  onKeydown(event) {
    if (event.repeat || event.metaKey || event.ctrlKey || event.altKey) return
    if (this.isTyping(event.target)) return

    // "?" toggles the cheatsheet; Escape closes it.
    if (event.key === "?") {
      event.preventDefault()
      this.toggleCheatsheet()
      return
    }
    if (event.key === "Escape") {
      this.hideCheatsheet()
      return
    }

    const shortcut = SHORTCUTS[event.key.toLowerCase()]
    if (!shortcut) return

    event.preventDefault()
    this.hideCheatsheet()

    if (window.location.pathname === shortcut.path) {
      this.focus(shortcut.focus)
    } else {
      if (shortcut.focus) sessionStorage.setItem(FOCUS_KEY, shortcut.focus)
      this.visit(shortcut.path)
    }
  }

  isTyping(el) {
    if (!el) return false
    const tag = el.tagName
    return tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT" || el.isContentEditable
  }

  focus(selector) {
    if (!selector) return
    // Wait a frame so the target exists after a Turbo render.
    requestAnimationFrame(() => {
      const el = document.querySelector(selector)
      if (!el) return
      el.focus()
      el.scrollIntoView({ block: "center", behavior: "smooth" })
    })
  }

  visit(path) {
    if (window.Turbo) window.Turbo.visit(path)
    else window.location.assign(path)
  }

  toggleCheatsheet() {
    if (this.hasCheatsheetTarget) this.cheatsheetTarget.classList.toggle("hidden")
  }

  hideCheatsheet() {
    if (this.hasCheatsheetTarget) this.cheatsheetTarget.classList.add("hidden")
  }

  // Swallow clicks inside the panel so the overlay's click-to-close doesn't fire.
  stop(event) {
    event.stopPropagation()
  }
}
