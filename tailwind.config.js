/** @type {import('tailwindcss').Config} */
const plugin = require("tailwindcss/plugin");

module.exports = {
  content: [
    "./src/**/*.{html,md,liquid,erb,serb,rb}",
    "./frontend/javascript/**/*.js",
    "./plugins/**/*.{html,md,liquid,erb,serb,rb}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['"Source Serif 4"', "serif"], // Replacing the default font
      },
      width: {
        content: "840px",
        title: "960px",
      },
      colors: {
        primary: "",
      },
    },
  },
  plugins: [
    plugin(function ({ addVariant }) {
      addVariant("not-last", "&:not(:last-child)");
    }),
  ],
};
