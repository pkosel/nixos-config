require("trouble").setup({})

local wk = require("which-key")
wk.add({
  {
    "<leader>xx",
    "<cmd>Trouble diagnostics toggle<cr>",
    desc = "Toggle diagnostics",
  },
  {
    "<leader>xw",
    "<cmd>Trouble diagnostics toggle<cr>",
    desc = "All-buffer diagnostics",
  },
  {
    "<leader>xd",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    desc = "Buffer diagnostics",
  },
  { "<leader>xq", "<cmd>Trouble quickfix<cr>", desc = "Quickfix list" },
  { "<leader>xl", "<cmd>Trouble loclist<cr>", desc = "Location list" },
})
