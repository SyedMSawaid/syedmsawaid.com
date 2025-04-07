import {Controller} from "@hotwired/stimulus";
import {SVG} from "$javascript/common/svgs";

export default class extends Controller {
  static values = {
    id: String
  }

  static targets = ["ellipsis"];
  static classes = ["ellipsis"]

  connect() {
  }

  get id() {
    return this.idValue;
  }

  mark() {
    const bookmark = document.createElement("span");
    bookmark.innerHTML = SVG.BOOKMARK;
    this.ellipsisTarget.classList.add(this.ellipsisClass);
    this.ellipsisTarget.after(bookmark);
  }
}