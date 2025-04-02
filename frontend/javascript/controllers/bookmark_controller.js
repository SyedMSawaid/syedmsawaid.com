import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static values = {
    book: String,
  }
  static outlets = [ "chapter" ];

  connect() {
    this.#bookmarkCurrentChapter()
  }

  #bookmarkCurrentChapter() {
    this.bookmarkedChapter?.markActive();
  }

  get currentChapter() {
    return localStorage.getItem(this.bookValue);
  }

  get bookmarkedChapter() {
    return this.chapterOutlets.find(chapter => chapter.id === this.currentChapter);
  }
}
