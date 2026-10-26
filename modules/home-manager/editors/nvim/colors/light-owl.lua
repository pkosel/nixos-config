-- Light Owl colorscheme.
-- Uses night-owl's highlight engine with a light palette so all
-- treesitter, LSP, and syntax groups are correct.
vim.opt.background = "light"
vim.g.colors_name = "light-owl"

-- Override the palette with light colors, then run night-owl's theme.
package.loaded["night-owl.palette"] = require("light-owl.palette")
require("night-owl.theme").set_highlights({
  bold = true,
  italics = true,
  underline = true,
  undercurl = true,
  transparent_background = false,
})
