local which_key = require("which-key")

which_key.add({
  { "<C-h>", "<C-w>h", desc = "Go to left window" },
  { "<C-j>", "<C-w>j", desc = "Go to lower window" },
  { "<C-k>", "<C-w>k", desc = "Go to upper window" },
  { "<C-l>", "<C-w>l", desc = "Go to right window" },
  { "<S-h>", "<cmd>bprevious<cr>", desc = "Prev buffer" },
  { "<S-l>", "<cmd>bnext<cr>", desc = "Next buffer" },
})

vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split below" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split right" })

which_key.add({
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

local function create_line_move_mapping(direction, is_visual)
  return function()
    local first_line = vim.fn.line(".")
    local last_line = first_line
    if is_visual then
      local selection_start = vim.fn.line("v")
      first_line = math.min(first_line, selection_start)
      last_line = math.max(last_line, selection_start)
    end

    if
      (direction < 0 and first_line == 1)
      or (direction > 0 and last_line == vim.fn.line("$"))
    then
      return ""
    end

    local destination = direction < 0 and first_line - 2 or last_line + 1
    local command = ("<Cmd>%d,%dmove %d<CR>"):format(
      first_line,
      last_line,
      destination
    )
    if is_visual then
      return "<Esc>" .. command .. "gv=gv"
    end
    return command .. "=="
  end
end

which_key.add({
  {
    "<A-j>",
    create_line_move_mapping(1, false),
    mode = "n",
    expr = true,
    desc = "Move line down",
  },
  {
    "<A-k>",
    create_line_move_mapping(-1, false),
    mode = "n",
    expr = true,
    desc = "Move line up",
  },
  {
    "<A-j>",
    create_line_move_mapping(1, true),
    mode = "x",
    expr = true,
    desc = "Move selection down",
  },
  {
    "<A-k>",
    create_line_move_mapping(-1, true),
    mode = "x",
    expr = true,
    desc = "Move selection up",
  },
  {
    "n",
    "'Nn'[v:searchforward].'zv'",
    mode = "n",
    expr = true,
    desc = "Next search result",
  },
  {
    "N",
    "'nN'[v:searchforward].'zv'",
    mode = "n",
    expr = true,
    desc = "Prev search result",
  },
  { "<", "<gv", mode = "x", desc = "Indent left" },
  { ">", ">gv", mode = "x", desc = "Indent right" },
  { "<C-s>", "<cmd>w<cr><esc>", mode = { "i", "x", "n", "s" }, desc = "Save" },
  {
    "<esc>",
    "<cmd>noh<cr><esc>",
    mode = { "i", "n" },
    desc = "Escape and clear hlsearch",
  },
  {
    "<leader>ur",
    "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>",
    desc = "Redraw / Clear hlsearch",
  },
  { "<leader>fn", "<cmd>enew<cr>", desc = "New file" },
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit all" },
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New tab" },
  { "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next tab" },
  { "<leader><tab>[", "<cmd>tabprevious<cr>", desc = "Prev tab" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close tab" },
})

vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")
