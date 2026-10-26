require("lualine").setup({
  options = {
    theme = vim.o.background == "light" and "night-owl-light" or "night-owl",
    disabled_filetypes = { "NvimTree" },
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
})
