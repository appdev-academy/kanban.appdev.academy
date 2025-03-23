import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.showModal();
  }

  hide() {
    this.element.parentElement.removeAttribute("src"); // it might be nice to also remove the modal SRC
    this.element.remove();
  }

  clickOutside(event) {
    if (event.target === this.element) {
      this.hide();
    }
  }
}
