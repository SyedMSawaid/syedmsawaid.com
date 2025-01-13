/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,md,liquid,erb,serb,rb}",
    "./frontend/javascript/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['"Source Serif 4"', "serif"], // Replacing the default font
      },
      width: {
        "blog-content": "840px",
        "blog-title": "960px",
      },
    },
  },
  plugins: [],
};
