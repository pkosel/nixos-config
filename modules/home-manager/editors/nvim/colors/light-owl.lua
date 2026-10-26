-- Light Owl colorscheme.
-- Overrides night-owl's palette with light colors, then runs its highlight engine.
vim.opt.background = "light"
vim.g.colors_name = "light-owl"

package.loaded["night-owl.palette"] = require("light-owl.palette")
require("night-owl")._load()