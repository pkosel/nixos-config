-- My nvim config: keymaps and which-key setup

local wk = require("which-key")

-- which-key: central configuration. All group namespaces declared here once.
-- Later tasks add only leaf keymaps.
wk.setup({
  preset = "helix",
  spec = {
    -- Leader groups
    { mode = { "n", "x" }, { "<leader>b", group = "buffer" } },
    { mode = { "n", "x" }, { "<leader>c", group = "code" } },
    { mode = { "n", "x" }, { "<leader>f", group = "file/find" } },
    { mode = { "n", "x" }, { "<leader>g", group = "git" } },
    { mode = { "n", "x" }, { "<leader>s", group = "search" } },
    { mode = { "n", "x" }, { "<leader>u", group = "ui/toggle" } },
    { mode = { "n", "x" }, { "<leader>x", group = "diagnostics/quickfix" } },
    { mode = { "n", "x" }, { "<leader>h", group = "harpoon" } },
    -- Proxy: <leader>w shows all <c-w> window commands automatically
    {
      mode = { "n", "x" },
      {
        "<leader>w",
        group = "windows",
        proxy = "<c-w>",
        expand = function()
          return require("which-key.extras").expand.win()
        end,
      },
    },
    -- [ and ] are prev/next for many things
    { mode = { "n", "x" }, { "[", group = "prev" } },
    { mode = { "n", "x" }, { "]", group = "next" } },
    -- Native group labels
    { mode = { "n", "x" }, { "g", group = "goto" } },
    { mode = { "n", "x" }, { "gs", group = "surround" } },
    { mode = { "n", "x" }, { "z", group = "fold" } },
    { mode = { "n" }, { "<leader><tab>", group = "tabs" } },
    { mode = { "n", "x" }, { "gx", desc = "Open with system app" } },
  },
})

-- Helper: show buffer-local keymaps
wk.add({
  {
    "<leader>?",
    function()
      require("which-key").show({ global = false })
    end,
    desc = "Buffer keymaps",
  },
})

-- Window navigation
wk.add({
  { "<C-h>", "<C-w>h", { desc = "Go to left window" } },
  { "<C-j>", "<C-w>j", { desc = "Go to lower window" } },
  { "<C-k>", "<C-w>k", { desc = "Go to upper window" } },
  { "<C-l>", "<C-w>l", { desc = "Go to right window" } },
})

-- Window splits (under <leader>w, auto-shown via proxy)
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split below" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split right" })

-- Buffer navigation
wk.add({
  { "<S-h>", "<cmd>bprevious<cr>", desc = "Prev buffer" },
  { "<S-l>", "<cmd>bnext<cr>", desc = "Next buffer" },
})

-- Diagnostic navigation (built-in, no plugin needed)
wk.add({
  {
    "[d",
    function()
      vim.diagnostic.jump({ count = -1, float = true })
    end,
    desc = "Prev diagnostic",
  },
  {
    "]d",
    function()
      vim.diagnostic.jump({ count = 1, float = true })
    end,
    desc = "Next diagnostic",
  },
  {
    "[e",
    function()
      vim.diagnostic.jump({
        count = -1,
        severity = vim.diagnostic.severity.ERROR,
        float = true,
      })
    end,
    desc = "Prev error",
  },
  {
    "]e",
    function()
      vim.diagnostic.jump({
        count = 1,
        severity = vim.diagnostic.severity.ERROR,
        float = true,
      })
    end,
    desc = "Next error",
  },
  {
    "[w",
    function()
      vim.diagnostic.jump({
        count = -1,
        severity = vim.diagnostic.severity.WARN,
        float = true,
      })
    end,
    desc = "Prev warning",
  },
  {
    "]w",
    function()
      vim.diagnostic.jump({
        count = 1,
        severity = vim.diagnostic.severity.WARN,
        float = true,
      })
    end,
    desc = "Next warning",
  },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line diagnostics" },
})

-- Editing quality-of-life
wk.add({
  { { "n", "v" }, "<A-j>", ":move .+1<cr>==", desc = "Move line down" },
  { { "n", "v" }, "<A-k>", ":move .-2<cr>==", desc = "Move line up" },
  {
    "n",
    "n",
    "'Nn'[v:searchforward].'zv'",
    { expr = true, desc = "Next search result" },
  },
  {
    "n",
    "N",
    "'nN'[v:searchforward].'zv'",
    { expr = true, desc = "Prev search result" },
  },
  { "x", "<", "<gv", desc = "Indent left" },
  { "x", ">", ">gv", desc = "Indent right" },
})

-- Undo break-points (undo stops at each punctuation)
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Save file (works from insert mode too)
wk.add({ { { "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", desc = "Save" } })

-- Escape clears hlsearch
wk.add({
  {
    { "i", "n" },
    "<esc>",
    "<cmd>noh<cr><esc>",
    desc = "Escape and clear hlsearch",
  },
})

-- Misc
wk.add({
  {
    "<leader>ur",
    "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>",
    desc = "Redraw / Clear hlsearch",
  },
  { "<leader>fn", "<cmd>enew<cr>", desc = "New file" },
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit all" },
})

-- nvim-tree toggle
wk.add({
  { "<C-p>", require("nvim-tree.api").tree.toggle, desc = "Toggle file tree" },
})

-- Tab navigation
wk.add({
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New tab" },
  { "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next tab" },
  { "<leader><tab>[", "<cmd>tabprevious<cr>", desc = "Prev tab" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close tab" },
})
