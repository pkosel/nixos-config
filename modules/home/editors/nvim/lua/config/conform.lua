local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    javascript = { "biome" },
    javascriptreact = { "biome" },
    json = { "prettier" },
    jsonc = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier" },
    nix = { "nixfmt" },
    python = { "ruff_format" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
    toml = { "taplo" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    yaml = { "prettier" },
  },
  formatters = {
    biome = {
      -- Match nix fmt instead of inferring indentation from the current buffer.
      args = { "format", "--stdin-file-path", "$FILENAME" },
    },
  },
  default_format_opts = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  -- Formatting must finish before the write so the file contains the edits.
  format_on_save = {},
})

local which_key = require("which-key")
which_key.add({
  {
    "<leader>cf",
    function()
      conform.format()
    end,
    desc = "Format buffer",
  },
})
