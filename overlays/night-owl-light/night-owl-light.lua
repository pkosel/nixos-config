-- Night Owl Light lualine theme.
-- Complement to the dark theme in lua/lualine/themes/night-owl.lua.
local colors = {
  light = "#FBFBFB",
  dark = "#403f53",
  magenta = "#994cc3",
  green = "#2AA298",
  yellow = "#daaa01",
  orange = "#daaa01",
  cyan = "#2AA298",
  dark_blue = "#d3e8f8",
  light_blue = "#989fb1",
}

local night_owl_light = {
  normal = {
    a = { bg = colors.magenta, fg = colors.light, gui = "bold" },
    b = { bg = colors.light, fg = colors.dark },
    c = { bg = colors.light, fg = colors.dark },
  },
  insert = {
    a = { bg = colors.green, fg = colors.light, gui = "bold" },
    b = { bg = colors.light, fg = colors.dark },
    c = { bg = colors.light, fg = colors.dark },
  },
  visual = {
    a = { bg = colors.yellow, fg = colors.light, gui = "bold" },
    b = { bg = colors.light, fg = colors.dark },
    c = { bg = colors.light, fg = colors.dark },
  },
  replace = {
    a = { bg = colors.orange, fg = colors.light, gui = "bold" },
    b = { bg = colors.light, fg = colors.dark },
    c = { bg = colors.light, fg = colors.dark },
  },
  command = {
    a = { bg = colors.cyan, fg = colors.light, gui = "bold" },
    b = { bg = colors.light, fg = colors.dark },
    c = { bg = colors.light, fg = colors.dark },
  },
  inactive = {
    a = { bg = colors.light, fg = colors.light_blue },
    b = { bg = colors.light, fg = colors.light_blue },
    c = { bg = colors.light, fg = colors.light_blue },
  },
}

return night_owl_light