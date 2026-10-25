-- Plugin setups that don't yet have their own module.
-- These will move to dedicated modules in later tasks.

require("nvim-tree").setup({})

local neogit = require("neogit")
neogit.setup({})

require("gitsigns").setup()
