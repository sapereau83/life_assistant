import { Controller } from "@hotwired/stimulus"

// Adds a floating tooltip when hovering the data points of a server-rendered
// SVG chart. Each hoverable point carries data-label; the controller element
// must be position:relative and hold a [data-chart-tooltip-target="tooltip"].
//
// Markup: data-controller="chart-tooltip"
//   <svg>… <circle data-action="mouseenter->chart-tooltip#show mouseleave->chart-tooltip#hide"
//                   data-label="12 mars · 88,1 kg" /> …</svg>
//   <div data-chart-tooltip-target="tooltip" hidden></div>
export default class extends Controller {
  static targets = ["tooltip"]

  show(event) {
    const el = event.currentTarget
    if (!this.hasTooltipTarget) return

    this.tooltipTarget.textContent = el.dataset.label || ""
    this.tooltipTarget.hidden = false

    const point = el.getBoundingClientRect()
    const box = this.element.getBoundingClientRect()
    const x = point.left - box.left + point.width / 2
    const y = point.top - box.top
    this.tooltipTarget.style.left = `${x}px`
    this.tooltipTarget.style.top = `${y}px`

    el.classList.add("chart-point--active")
    this.active = el
  }

  hide() {
    if (this.hasTooltipTarget) this.tooltipTarget.hidden = true
    if (this.active) {
      this.active.classList.remove("chart-point--active")
      this.active = null
    }
  }
}
