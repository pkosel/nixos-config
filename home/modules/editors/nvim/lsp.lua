local config = require("lspconfig")

config.nil_ls.setup({})
config.lua_ls.setup({
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
config.marksman.setup({})

local wk = require("which-key")

wk.register(
  { f = { vim.lsp.buf.format, "Format file" } },
  { mode = "n", prefix = "<leader>" }
)
