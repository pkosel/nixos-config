-- Directory editing as a flat buffer (edit/create/move/rename files like text).
require("oil").setup({
  default_file_explorer = false,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<cr>"] = "actions.select",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["<c-p>"] = "actions.preview",
    ["<c-s>"] = false, -- conflicts with save, disable
  },
})

local wk = require("which-key")
wk.add({ { "-", "<cmd>Oil<cr>", desc = "Open oil (directory)" } })
