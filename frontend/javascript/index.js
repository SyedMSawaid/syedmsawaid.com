import "$styles/index.css"
import "$styles/syntax-highlighting.css"
import { Application } from "@hotwired/stimulus"

// Import all JavaScript & CSS files from src/_components
import components from "$components/**/*.{js,jsx,js.rb,css}"

console.info("Bridgetown is loaded!")

window.Stimulus = Application.start()

import controllers from "./controllers/**/*.{js,js.rb}"
Object.entries(controllers).forEach(([filename, controller]) => {
  if (filename.includes("_controller.") || filename.includes("-controller.")) {
    // Optimized: use single chained replace with regex for better performance
    const identifier = filename
      .replace("./controllers/", "")
      .replace(/[_-]controller\..*$/, "")
      .replace(/[_\/]/g, (match) => (match === "_" ? "-" : "--"))

    Stimulus.register(identifier, controller.default)
  }
})
