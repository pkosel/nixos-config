require("todo-comments").setup({
  signs = true,
  keywords = {
    FIXME = {},
    TODO = {},
    HACK = {},
    NOTE = {},
    PERF = {},
    WARN = {},
  },
  highlight = { pattern = [[.*<(KEYWORDS)\s*:]] },
  search = { pattern = [[\b(KEYWORDS)\b]] },
})

local which_key = require("which-key")
which_key.add({
  { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
  {
    "<leader>sT",
    "<cmd>TodoTelescope keywords=TODO,FIXME<cr>",
    desc = "Search TODOs/FIXMEs",
  },
})
