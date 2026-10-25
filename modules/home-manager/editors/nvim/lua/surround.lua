-- Surround: add/change/delete surrounding pairs.
require("mini.surround").setup()

local wk = require("which-key")
wk.add({
  { "sa", desc = "Add surround" },
  { "sd", desc = "Delete surround" },
  { "sr", desc = "Replace surround" },
  { "sh", desc = "Highlight surround" },
  { "sf", desc = "Find surround (forward)" },
  { "sn", desc = "Next surrounding pair" },
})
