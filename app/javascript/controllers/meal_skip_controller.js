import { Controller } from "@hotwired/stimulus"

// Dims and disables a meal's text area when its "Sauté" (skipped) checkbox is
// ticked — the meal is recorded as skipped, so free-text content is ignored.
export default class extends Controller {
  static targets = ["checkbox", "field"]

  connect() {
    this.apply()
  }

  toggle() {
    this.apply()
  }

  apply() {
    const skipped = this.checkboxTarget.checked
    this.fieldTarget.disabled = skipped
    this.fieldTarget.classList.toggle("opacity-40", skipped)
    this.fieldTarget.classList.toggle("pointer-events-none", skipped)
  }
}
