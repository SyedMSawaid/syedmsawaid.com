import {Controller} from "@hotwired/stimulus";
import {SVG} from "$javascript/common/svgs";

export default class extends Controller {
  static values = {
    id: String,
    chapters: Array
  }

  static targets = ["cover"];

  connect() {
    if (this.percentage > 0) this.addBookmark();
  }

  addBookmark() {
    const line = document.createElement("div");
    this.#applyCommonStyles(line);
    line.style.height = "0px";
    line.style.borderTop = "1px dashed oklch(70.5% 0.213 47.604)";
    line.style.width = "100%";
    line.style.top = `${this.percentage}%`;
    this.coverTarget.appendChild(line);

    const bookmark = document.createElement("span");
    this.#applyCommonStyles(bookmark);
    bookmark.style.top = `calc(${this.percentage}% - 12px)`;
    bookmark.style.right = `calc(100% - 12px)`;
    bookmark.innerHTML = SVG.BOOKMARK;
    this.coverTarget.appendChild(bookmark);
  }

  #applyCommonStyles(element) {
    const styles = {
      position: "absolute",
      padding: "0px",
      margin: "0px",
    };

    Object.assign(element.style, styles);
  }


  get percentage() {
    const currentChapter = this.chaptersValue.findIndex(x => x === this.currentChapter) + 1;
    return  currentChapter / this.chaptersValue.length * 100;
  }

  get currentChapter() {
    return localStorage.getItem(this.idValue);
  }
}