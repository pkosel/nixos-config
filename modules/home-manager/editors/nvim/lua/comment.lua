-- Commenting via mini.comment.
require("mini.comment").setup()

-- Additional convenience mappings: add comment below/above.
local wk = require("which-key")
wk.add({
  {
    "gco",
    "o<esc>Vcx<esc><cmd>normal gcc<cr>fxla<bs>",
    desc = "Add comment below",
  },
  {
    "gcO",
    "O<esc>Vcx<esc><cmd>normal gcc<cr>fxla<bs>",
    desc = "Add comment above",
  },
})
