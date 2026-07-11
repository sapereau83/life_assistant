import { Controller } from "@hotwired/stimulus"

// Live ticking clock. Usage: data-controller="clock"
export default class extends Controller {
  connect() {
    this.fmt = new Intl.DateTimeFormat("fr-FR", {
      hour: "2-digit", minute: "2-digit", second: "2-digit"
    })
    this.tick()
    this.timer = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    this.element.textContent = this.fmt.format(new Date())
  }
}
