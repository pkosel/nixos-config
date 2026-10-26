-- Lualine statusline, follows the colorscheme's background.
local light_theme = {
  normal = {
    a = { bg = "#994cc3", fg = "#FBFBFB", gui = "bold" },
    b = { bg = "#FBFBFB", fg = "#403f53" },
    c = { bg = "#FBFBFB", fg = "#403f53" },
  },
  insert = {
    a = { bg = "#2AA298", fg = "#FBFBFB", gui = "bold" },
    b = { bg = "#FBFBFB", fg = "#403f53" },
    c = { bg = "#FBFBFB", fg = "#403f53" },
  },
  visual = {
    a = { bg = "#daaa01", fg = "#FBFBFB", gui = "bold" },
    b = { bg = "#FBFBFB", fg = "#403f53" },
    c = { bg = "#FBFBFB", fg = "#403f53" },
  },
  replace = {
    a = { bg = "#E64D49", fg = "#FBFBFB", gui = "bold" },
    b = { bg = "#FBFBFB", fg = "#403f53" },
    c = { bg = "#FBFBFB", fg = "#403f53" },
  },
  command = {
    a = { bg = "#0c969b", fg = "#FBFBFB", gui = "bold" },
    b = { bg = "#FBFBFB", fg = "#403f53" },
    c = { bg = "#FBFBFB", fg = "#403f53" },
  },
  inactive = {
    a = { bg = "#FBFBFB", fg = "#90A7B2" },
    b = { bg = "#FBFBFB", fg = "#90A7B2" },
    c = { bg = "#FBFBFB", fg = "#90A7B2" },
  },
}

require("lualine").setup({
  options = {
    theme = vim.o.background == "light" and light_theme or "night-owl",
    disabled_filetypes = { "NvimTree" },
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
})
