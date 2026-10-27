-- Harpoon lists are scoped to the current working directory.
local harpoon = require("harpoon")
harpoon:setup({})

local wk = require("which-key")
wk.add({
  {
    "<leader>ha",
    function()
      harpoon:list():add()
    end,
    desc = "Add file",
  },
  {
    "<leader>hm",
    function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Menu",
  },
  {
    "<leader>h1",
    function()
      harpoon:list():select(1)
    end,
    desc = "File 1",
  },
  {
    "<leader>h2",
    function()
      harpoon:list():select(2)
    end,
    desc = "File 2",
  },
  {
    "<leader>h3",
    function()
      harpoon:list():select(3)
    end,
    desc = "File 3",
  },
  {
    "<leader>h4",
    function()
      harpoon:list():select(4)
    end,
    desc = "File 4",
  },
})
