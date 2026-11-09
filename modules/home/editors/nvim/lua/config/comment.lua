local comment = require("mini.comment")
comment.setup()

local function insert_comment(is_above)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local commentstring = comment.get_commentstring({ cursor[1], cursor[2] + 1 })
  local left, right = commentstring:match("^(.-)%%s(.-)$")
  if not left then
    vim.notify("No valid commentstring for this buffer", vim.log.levels.WARN)
    return
  end

  left, right = vim.trim(left), vim.trim(right)
  left = left == "" and "" or left .. " "
  right = right == "" and "" or " " .. right
  local indent = vim.api.nvim_get_current_line():match("^%s*")
  local row = is_above and cursor[1] - 1 or cursor[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. left .. right })
  vim.api.nvim_win_set_cursor(0, { row + 1, #indent + #left })
  vim.cmd(right == "" and "startinsert!" or "startinsert")
end

local which_key = require("which-key")
which_key.add({
  {
    "gco",
    function()
      insert_comment(false)
    end,
    desc = "Add comment below",
  },
  {
    "gcO",
    function()
      insert_comment(true)
    end,
    desc = "Add comment above",
  },
})
