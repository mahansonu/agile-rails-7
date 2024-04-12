import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="locale"
export default class extends Controller {
  static targets = ["submit"];
  initialize() {
    console.log("here i am");
    this.submitTarget.style.display = "none";
  }
}
