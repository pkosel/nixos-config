-- Plugin setups that don't yet have their own module.
-- These will move to dedicated modules in later tasks.

require("nvim-tree").setup({})

require("nvim_comment").setup()

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.nixfmt,
    null_ls.builtins.formatting.stylua,
  },
})

local neogit = require("neogit")
neogit.setup({})

require("gitsigns").setup()
