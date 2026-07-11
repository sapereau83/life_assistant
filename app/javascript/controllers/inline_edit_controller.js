import { Controller } from "@hotwired/stimulus"

// Toggles a table row (or card) between a read-only "display" view and an
// inline "form" view, with zero server round-trip to enter edit mode.
// The form still submits normally (Turbo) to the resource's #update action,
// which re-renders the board and naturally resets the row to display mode.
//
// Markup:
//   data-controller="inline-edit" data-action="keydown->inline-edit#keydown"
//     <div data-inline-edit-target="display">…values… <button data-action="inline-edit#edit">✎</button></div>
//     <div data-inline-edit-target="form" hidden><form>…</form></div>
export default class extends Controller {
  static targets = ["display", "form"]

  edit() {
    this.displayTarget.hidden = true
    this.formTarget.hidden = false
    const field = this.formTarget.querySelector("input, textarea, select")
    if (field) {
      field.focus()
      if (field.select) field.select()
    }
  }

  cancel() {
    this.formTarget.hidden = true
    this.displayTarget.hidden = false
  }

  keydown(event) {
    if (event.key === "Escape") this.cancel()
  }
}
