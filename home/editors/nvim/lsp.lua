-- nvim-lspconfig ships the server defaults (cmd, filetypes, root markers) in its
-- lsp/ directory, which nvim picks up off the runtimepath; vim.lsp.config only
-- layers our overrides on top of those.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})

vim.lsp.enable({
  "lua_ls",
  "marksman",
  "nil_ls",
})

require("which-key").add({
  { "<leader>f", vim.lsp.buf.format, desc = "Format file" },
})
