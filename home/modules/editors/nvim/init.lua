-- My nvim config

-- Options
vim.g.mapleader = " "

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.timeoutlen = 500

vim.opt.clipboard = "unnamedplus"

vim.cmd("colorscheme gruvbox-material")

-- Mappings
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set(
  { "i", "n" },
  "<esc>",
  "<cmd>noh<cr><esc>",
  { desc = "Escape and clear hlsearch" }
)

-- Plugins
local wk = require("which-key")

require("nvim-tree").setup({})
wk.register(
  { ["<C-p>"] = { require("nvim-tree.api").tree.toggle, "Toggle NvimTree" } },
  { mode = "n" }
)

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
