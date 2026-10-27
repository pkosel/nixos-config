require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config.treesitter", { clear = true }),
  callback = function(args)
    local parser = vim.treesitter.get_parser(args.buf)
    if not parser then
      return
    end

    vim.treesitter.start(args.buf)

    -- Experimental indentation requires an indent query; otherwise keep the filetype default.
    if vim.treesitter.query.get(parser:lang(), "indents") then
      vim.bo[args.buf].indentexpr =
        "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("treesitter-context").setup({})
