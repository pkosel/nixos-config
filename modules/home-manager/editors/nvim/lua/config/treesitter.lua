-- nvim-treesitter: parser management and queries.
-- Highlighting and indentation are enabled via autocommands below.
-- Incremental selection was dropped in the upstream rewrite and has no
-- replacement yet. The old keymaps (gnn, gnc, gnm) are removed.
require("nvim-treesitter").setup({})

-- Enable treesitter highlighting for filetypes that have parsers installed.
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Treesitter-based indentation (experimental).
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local ok =
      pcall(vim.treesitter.language.get_parser, vim.api.nvim_get_current_buf())
    if ok then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("treesitter-context").setup({})
