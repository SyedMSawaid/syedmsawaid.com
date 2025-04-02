import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static values = {
    id: String,
    book: String,
  }

  connect() {
    this.#setCurrentChapter();
  }

  #setCurrentChapter() {
    localStorage.setItem(this.bookValue, this.idValue);
  }
}
