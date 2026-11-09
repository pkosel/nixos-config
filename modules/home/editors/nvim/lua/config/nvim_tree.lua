require("nvim-tree").setup({})

local which_key = require("which-key")
which_key.add({
  { "<C-p>", require("nvim-tree.api").tree.toggle, desc = "Toggle file tree" },
})
