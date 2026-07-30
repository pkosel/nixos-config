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

-- Underline the other uses of whatever the cursor is resting on, and drop them
-- again as soon as it moves. Gated on the capability so buffers whose server
-- cannot answer do not carry the autocmds.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method("textDocument/documentHighlight") then
      return
    end

    local group =
      vim.api.nvim_create_augroup("lsp_document_highlight_" .. args.buf, { clear = true })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = args.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = args.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end,
})

require("which-key").add({
  { "<leader>f", vim.lsp.buf.format, desc = "Format file" },
})
