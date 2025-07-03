import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['loading', 'button', 'arrow'];

  connect() {
    this.loadingTarget.classList.add('hidden');
    this.buttonTarget.disabled = false;
  }

  displayLoading(event) {
    this.loadingTarget.classList.remove('hidden');
    this.arrowTarget.classList.add('hidden');
    this.buttonTarget.disabled = true;
  }
}
