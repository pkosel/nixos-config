-- Formatting via conform.nvim.
local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    python = { "ruff_format" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    toml = { "taplo" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Manual format keybinding.
local wk = require("which-key")
wk.add({
  {
    "<leader>cf",
    function()
      conform.format({ force = true })
    end,
    desc = "Format buffer",
  },
})
