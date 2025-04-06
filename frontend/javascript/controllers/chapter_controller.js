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

  mark() {
    const bookmark = document.createElement("span");
    bookmark.innerHTML = this.#bookmarkSvg();
    bookmark.classList.add(...this.bookmarkClasses);
    this.ellipsisTarget.classList.add(this.ellipsisClass);
    this.ellipsisTarget.after(bookmark);
  }

  #bookmarkSvg() {
    return `
       <svg xmlns="http://www.w3.org/2000/svg" 
            width="24" 
            height="24" 
            viewBox="0 0 24 24" 
            stroke="currentColor" 
            stroke-width="2" 
            stroke-linecap="round" 
            stroke-linejoin="round" 
            class="lucide lucide-bookmark-icon lucide-bookmark">
          <path d="m19 21-7-4-7 4V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16z"/>
        </svg>
`
  }
}