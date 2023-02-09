const plugin = require("tailwindcss/plugin")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        dusk:   "#036",
        ember:  "#F60",
        canary: "#FC0",
      },
      fontFamily: {
        display:  ["Fraunces", "serif"],
        body:     ["Inter", "sans-serif"],
        fixed:    ["Fira Code", "monospace"],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Reacts to `phx*` classes injected to self or parents.
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"]))
  ]
}