import { Controller } from "@hotwired/stimulus"

// Plays a one-shot entrance animation when its element appears — used to make
// a freshly added task "pop" in (fade + slide + scale + a brief tint flash).
// Only the newly created item carries data-controller="pop", so the rest of
// the re-rendered list stays still.
export default class extends Controller {
  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return
    if (typeof this.element.animate !== "function") return

    this.element.animate(
      [
        { opacity: 0, transform: "translateY(-10px) scale(0.97)", backgroundColor: "rgba(60, 80, 224, 0.12)" },
        { opacity: 1, transform: "translateY(0) scale(1)", backgroundColor: "rgba(60, 80, 224, 0.12)", offset: 0.45 },
        { opacity: 1, transform: "translateY(0) scale(1)", backgroundColor: "rgba(60, 80, 224, 0)" }
      ],
      { duration: 650, easing: "cubic-bezier(0.22, 1, 0.36, 1)" }
    )
  }
}
