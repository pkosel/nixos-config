require("flash").setup({
  search = { mode = "search" },
  jump = { autojump = true },
})

local which_key = require("which-key")
which_key.add({
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
