import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String
  }

  static targets = ["ellipsis"];
  static classes = ["ellipsis", "bookmark"]

  connect() {
  }

  get id() {
    return this.idValue;
  }

  markActive() {
    const bookmark = document.createElement("span");
    bookmark.innerHTML = this.#bookmarkSvg();
    bookmark.classList.add(...this.bookmarkClasses);
    this.ellipsisTarget.classList.add(this.ellipsisClass);
    this.ellipsisTarget.after(bookmark);
  }

  #bookmarkSvg() {
    return `
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512">
        <!--!Font Awesome Free 6.7.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.-->
        <path d="M0 48V487.7C0 501.1 10.9 512 24.3 512c5 0 9.9-1.5 14-4.4L192 400 345.7 507.6c4.1 2.9 9 4.4 14 4.4c13.4 0 24.3-10.9 24.3-24.3V48c0-26.5-21.5-48-48-48H48C21.5 0 0 21.5 0 48z"/></svg>
`
  }
}