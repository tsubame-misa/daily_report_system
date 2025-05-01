import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    this.element.querySelectorAll('.toast').forEach(toastNode => {
      let toast = new Toast(toastNode, { autohide: true });
      toast.show();
    });
  }

  showError(message) {
    const toastContainer = this.element;
    const toastId = `toast-${Date.now()}`;

    const toastHtml = `
      <div id="${toastId}" class="mb-2 toast toast-danger" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header toast-header-danger">
          <i class="bi bi-exclamation-circle me-2"></i>
          <strong class="me-auto toast-title-danger">Error</strong>
          <button class="btn-close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body toast-body-danger">${message}</div>
      </div>
    `;

    toastContainer.insertAdjacentHTML('beforeend', toastHtml);
    const toastElement = document.getElementById(toastId);
    const toast = new Toast(toastElement, { autohide: true });
    toast.show();
  }
}
