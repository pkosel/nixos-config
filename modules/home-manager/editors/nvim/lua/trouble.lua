-- Diagnostics list via trouble.nvim (folke).
require("trouble").setup({})

local wk = require("which-key")
wk.add({
  { "<leader>xx", "<cmd>Trouble toggle<cr>", desc = "Toggle trouble" },
  {
    "<leader>xw",
    "<cmd>Trouble workspace_diagnostics<cr>",
    desc = "Workspace diagnostics",
  },
  {
    "<leader>xd",
    "<cmd>Trouble document_diagnostics<cr>",
    desc = "Document diagnostics",
  },
  { "<leader>xq", "<cmd>Trouble quickfix<cr>", desc = "Quickfix list" },
  { "<leader>xl", "<cmd>Trouble loclist<cr>", desc = "Location list" },
})
