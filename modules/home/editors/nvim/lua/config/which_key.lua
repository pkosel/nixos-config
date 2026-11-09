local which_key = require("which-key")

which_key.setup({
  preset = "helix",
  spec = {
    {
      mode = { "n", "x" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file/find" },
      { "<leader>h", group = "harpoon" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui/toggle" },
      { "<leader>x", group = "diagnostics/quickfix" },
      {
        "<leader>w",
        group = "windows",
        proxy = "<c-w>",
        expand = function()
          return require("which-key.extras").expand.win()
        end,
      },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "s", group = "surround" },
      { "z", group = "fold" },
      { "gx", desc = "Open with system app" },
    },
    { "<leader><tab>", group = "tabs" },
    {
      "<leader>?",
      function()
        which_key.show({ global = false })
      end,
      desc = "Buffer keymaps",
    },
  },
})
