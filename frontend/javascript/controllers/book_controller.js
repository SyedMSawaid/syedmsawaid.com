import {Controller} from "@hotwired/stimulus";

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
    const bookmark = document.createElement("div");
    bookmark.innerHTML = "----------------------------------";
    bookmark.style.padding = "0px";
    bookmark.style.margin = "0px";
    bookmark.style.verticalAlign = "top";
    bookmark.style.position = "absolute";
    bookmark.style.top = `${this.percentage}%`;
    this.coverTarget.appendChild(bookmark);
  }

  get percentage() {
    const currentChapter = this.chaptersValue.findIndex(x => x === this.currentChapter) + 1;
    return  currentChapter / this.chaptersValue.length * 100;
  }

  get currentChapter() {
    return localStorage.getItem(this.idValue);
  }
}