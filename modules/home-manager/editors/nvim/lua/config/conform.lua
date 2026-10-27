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
  default_format_opts = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  -- Formatting must finish before the write so the file contains the edits.
  format_on_save = {},
})

local wk = require("which-key")
wk.add({
  {
    "<leader>cf",
    function()
      conform.format()
    end,
    desc = "Format buffer",
  },
})
