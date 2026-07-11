import { Controller } from "@hotwired/stimulus"

// Animates a number from 0 up to `end` on connect (count-up effect).
// Usage: data-controller="counter" data-counter-end-value="10174"
//        data-counter-decimals-value="1" data-counter-suffix-value=" kg"
export default class extends Controller {
  static values = {
    end: Number,
    decimals: { type: Number, default: 0 },
    duration: { type: Number, default: 900 },
    prefix: { type: String, default: "" },
    suffix: { type: String, default: "" }
  }

  connect() {
    this.fmt = new Intl.NumberFormat("fr-FR", {
      minimumFractionDigits: this.decimalsValue,
      maximumFractionDigits: this.decimalsValue
    })

    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.render(this.endValue)
      return
    }
    this.start = null
    requestAnimationFrame(this.step)
  }

  step = (now) => {
    if (this.start === null) this.start = now
    const t = Math.min(1, (now - this.start) / this.durationValue)
    const eased = 1 - Math.pow(1 - t, 3) // easeOutCubic
    this.render(this.endValue * eased)
    if (t < 1) requestAnimationFrame(this.step)
  }

  render(value) {
    this.element.textContent = `${this.prefixValue}${this.fmt.format(value)}${this.suffixValue}`
  }
}
