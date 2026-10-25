-- Formatting via conform.nvim.
local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    nix = { "nixfmt" },
    lua = { "stylua" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Manual format keybinding.
local wk = require("which-key")
wk.add({
  { "<leader>cf", function() conform.format({ force = true }) end, desc = "Format buffer" },
})