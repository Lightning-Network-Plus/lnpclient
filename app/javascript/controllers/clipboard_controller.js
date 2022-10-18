import { Controller } from "@hotwired/stimulus"
import ClipboardJS from "clipboard"
export default class extends Controller {
  connect() {
    this.clipboard = new ClipboardJS(this.element)
  };
}