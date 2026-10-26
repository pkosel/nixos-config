-- Light Owl colorscheme.
-- Uses night-owl's highlight engine with a light palette.
-- Bypasses night-owl's config (which hardcodes background = "dark").
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.cmd("highlight clear")
vim.opt.background = "light"
vim.g.colors_name = "light-owl"

package.loaded["night-owl.palette"] = require("light-owl.palette")
require("night-owl.theme").set_highlights({
  bold = true,
  italics = true,
  underline = true,
  undercurl = true,
  transparent_background = false,
})
