return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "c", "cpp", "rust", "python", "nix", "lua" },
        highlight = { enable = true },
        indent = { enable = true }
      }
    end
  }
}
