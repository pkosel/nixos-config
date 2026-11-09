require("mini.align").setup()

local which_key = require("which-key")
which_key.add({
  { "ga", mode = { "n", "x" }, desc = "Align operator" },
  { "gA", mode = { "n", "x" }, desc = "Align with preview" },
})
