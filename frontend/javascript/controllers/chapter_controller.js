import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String
  }

  connect() {
  }

  get id() {
    return this.idValue;
  }

  markActive() {
    console.log("markActive", this.id);
  }
}