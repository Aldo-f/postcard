import { Controller } from "@hotwired/stimulus";
import debounce from "lodash.debounce";

export default class extends Controller {
  static values = {
    autofocus: Boolean,
  };

  static targets = ["content", "input"];

  connect() {
    this.contentTarget.innerHTML = this.inputTarget.value;
    if (this.hasAutofocusValue) {
      this.autofocus(this.contentTarget);
    }
    this.contentTarget.addEventListener("keypress", (e) => {
      if (e.which === 13) {
        e.preventDefault();
      }
    });
  }

  disconnect() {
    this.contentTarget.removeEventListener("keypress", (e) => {
      if (e.which === 13) {
        e.preventDefault();
      }
    });
  }

  debouncedSave = debounce((e) => {
    this.inputTarget.form.requestSubmit();
  }, 1500);

  changed(e) {
    // Remove newline
    const newline = /(\r\n|\n|\r)/gm;
    if (this.contentTarget.textContent.match(newline)) {
      this.contentTarget.textContent = this.contentTarget.textContent.replace(
        newline,
        ""
      );
    }
    this.inputTarget.value = this.contentTarget.textContent;
  }

  autofocus(el) {
    el.focus();
    if (
      typeof window.getSelection != "undefined" &&
      typeof document.createRange != "undefined"
    ) {
      var range = document.createRange();
      range.selectNodeContents(el);
      range.collapse(false);
      var sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
    } else if (typeof document.body.createTextRange != "undefined") {
      var textRange = document.body.createTextRange();
      textRange.moveToElementText(el);
      textRange.collapse(false);
      textRange.select();
    }
  }
}
