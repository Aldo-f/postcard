import { Controller } from "@hotwired/stimulus";
import debounce from "lodash.debounce";

export default class extends Controller {
  debouncedSave = debounce((e) => {
    this.element.requestSubmit();
  }, 1500);
}
