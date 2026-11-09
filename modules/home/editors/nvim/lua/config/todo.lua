require("todo-comments").setup()

local which_key = require("which-key")
which_key.add({
  { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
  {
    "<leader>sT",
    "<cmd>TodoTelescope keywords=TODO,FIXME<cr>",
    desc = "Search TODOs/FIXMEs",
  },
})
