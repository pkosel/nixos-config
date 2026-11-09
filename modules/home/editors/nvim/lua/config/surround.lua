require("mini.surround").setup()

local which_key = require("which-key")
which_key.add({
  { "sa", mode = { "n", "x" }, desc = "Add surround" },
  { "sd", desc = "Delete surround" },
  { "sr", desc = "Replace surround" },
  { "sh", desc = "Highlight surround" },
  { "sf", desc = "Find surround (forward)" },
  { "sF", desc = "Find surround (backward)" },
})
