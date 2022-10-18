import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "mobile", "bars", "times" ]
  hide() {
    this.mobileTarget.classList.add("hidden")
    this.barsTarget.classList.remove("hidden")
    this.timesTarget.classList.add("hidden")
  }
  show() {
    this.mobileTarget.classList.remove("hidden")
    this.barsTarget.classList.add("hidden")
    this.timesTarget.classList.remove("hidden")
  }
}
