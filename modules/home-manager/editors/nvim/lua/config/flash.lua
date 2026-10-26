-- Fast navigation via flash.nvim (folke).
require("flash").setup({
  search = { mode = "search" },
  jump = { autojump = true },
})

local wk = require("which-key")
wk.add({
  {
    "<leader>ss",
    function()
      require("flash").jump()
    end,
    desc = "Flash search",
  },
  {
    "<leader>sr",
    function()
      require("flash").treesitter()
    end,
    desc = "Flash treesitter",
  },
})
