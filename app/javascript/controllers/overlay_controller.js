import { Controller } from "@hotwired/stimulus";
import debounce from "lodash.debounce";

export default class extends Controller {
  static targets = ["overlay", "covered"];

  connect() {
    this.overlayTarget.style.height = `${this.coveredTarget.scrollHeight}px`;
  }
}
