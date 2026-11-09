require("mini.align").setup()

local which_key = require("which-key")
which_key.add({
  { "ga", group = "align" },
  { "ga=", desc = "Align on =" },
  { "ga ", desc = "Align on space" },
  { "ga|", desc = "Align on |" },
})
