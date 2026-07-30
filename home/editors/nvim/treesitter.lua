require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    -- Under gn, not gr: nvim 0.11 claimed gr* for the built-in LSP maps, so grn
    -- was shadowing vim.lsp.buf.rename. init_selection is normal mode and the
    -- rest are visual, which is why gnn can serve both.
    keymaps = {
      init_selection = "gnn",
      node_incremental = "gnn",
      scope_incremental = "gnc",
      node_decremental = "gnm",
    },
  },
})
