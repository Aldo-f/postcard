import { Modal } from "tailwindcss-stimulus-components";

export default class extends Modal {

  // https://github.com/excid3/tailwindcss-stimulus-components/blob/f1b9ff7f7941edec1942bab1e139fe1f0ccc8ba7/src/modal.js

  connect() {
    super.connect()
    this.open()
  }

  open(e = null) {
    if (e) {
      if (this.preventDefaultActionOpening) {
        e.preventDefault();
      }

      if (e.target.blur) {
        e.target.blur();
      }
    }

    // Lock the scroll and save current scroll position
    this.lockScroll();

    // Unhide the modal
    this.containerTarget.classList.remove(this.toggleClass);

    // Insert the background
    if (!this.data.get("disable-backdrop")) {
      document.body.insertAdjacentHTML('beforeend', this.backgroundHtml);
      this.background = document.querySelector(`#${this.backgroundId}`);
    }
  }
}