import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = ["modal", "form"]

  connect() {
    this.bootstrapModal = new Modal(this.modalTarget)
  }

  show(event) {
    const url = event.currentTarget.dataset.url
    if (url && this.hasFormTarget) {
      this.formTarget.action = url
    }
    this.bootstrapModal.show()
  }

  hide() {
    this.bootstrapModal.hide()
  }
}
