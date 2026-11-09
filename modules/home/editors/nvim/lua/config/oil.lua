require("oil").setup({
  default_file_explorer = false,
  keymaps = {
    -- Match Oil's case-sensitive key so its split action cannot override saving.
    ["<C-s>"] = false,
  },
})

local which_key = require("which-key")
which_key.add({ { "-", "<cmd>Oil<cr>", desc = "Open oil (directory)" } })
