require("trouble").setup({})

local which_key = require("which-key")
which_key.add({
  {
    "<leader>xx",
    "<cmd>Trouble diagnostics toggle<cr>",
    desc = "Toggle diagnostics",
  },
  {
    "<leader>xd",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    desc = "Buffer diagnostics",
  },
  { "<leader>xq", "<cmd>Trouble quickfix<cr>", desc = "Quickfix list" },
  { "<leader>xl", "<cmd>Trouble loclist<cr>", desc = "Location list" },
})
