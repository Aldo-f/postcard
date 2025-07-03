import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.element.addEventListener('keydown', (e) => {
      if (e.keyCode === 13 && (e.metaKey || e.ctrlKey)) {
          e.preventDefault();
          this.element.requestSubmit();
      }
    });
  }
}