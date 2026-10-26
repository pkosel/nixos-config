-- Modern UI for messages, cmdline, and search via noice.nvim.
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    progress = { enabled = false },
  },
})
