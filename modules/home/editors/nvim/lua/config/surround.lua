require("mini.surround").setup()

local wk = require("which-key")
wk.add({
  { "sa", mode = { "n", "x" }, desc = "Add surround" },
  { "sd", desc = "Delete surround" },
  { "sr", desc = "Replace surround" },
  { "sh", desc = "Highlight surround" },
  { "sf", desc = "Find surround (forward)" },
  { "sF", desc = "Find surround (backward)" },
})
