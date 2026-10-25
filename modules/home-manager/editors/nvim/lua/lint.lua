-- Linting via nvim-lint.
local lint = require("lint")

lint.linters_by_ft = {
  dockerfile = { "hadolint" },
  markdown = { "markdownlint" },
  nix = { "statix" },
  python = { "ruff" },
  rust = { "clippy" },
  sh = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})

-- Manual lint keybinding.
local wk = require("which-key")
wk.add({
  {
    "<leader>cl",
    function()
      lint.try_lint()
    end,
    desc = "Lint file",
  },
})
