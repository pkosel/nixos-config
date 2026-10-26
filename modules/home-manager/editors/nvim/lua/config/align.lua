-- Text alignment via mini.align.
require("mini.align").setup()

local wk = require("which-key")
wk.add({
  { "ga", group = "align" },
  { "ga=", desc = "Align on =" },
  { "ga ", desc = "Align on space" },
  { "ga|", desc = "Align on |" },
})
