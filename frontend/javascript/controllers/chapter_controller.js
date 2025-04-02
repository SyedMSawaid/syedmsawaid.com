import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String
  }

  static targets = ["bookmark"];

  connect() {
    console.log({target: this.bookmarkTarget})
  }

  get id() {
    return this.idValue;
  }

  markActive() {
    console.log("markActive", this.id);
    this.bookmarkTarget.textContent = "Your MOM is fat";
  }
}