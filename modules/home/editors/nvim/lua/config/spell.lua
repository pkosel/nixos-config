vim.opt.spelllang = { "en_us", "de_de" }

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("config.spell", { clear = true }),
  callback = function(args)
    local is_enabled = vim.b[args.buf].spell_enabled
    if is_enabled == nil then
      is_enabled = vim.bo[args.buf].buftype == ""
        and vim.bo[args.buf].filetype ~= ""
    end
    vim.wo.spell = is_enabled
  end,
})

require("which-key").add({
  {
    "<leader>us",
    function()
      local buffer = vim.api.nvim_get_current_buf()
      local is_enabled = not vim.wo.spell
      vim.b[buffer].spell_enabled = is_enabled
      for _, window in ipairs(vim.fn.win_findbuf(buffer)) do
        vim.wo[window].spell = is_enabled
      end
    end,
    desc = "Toggle spelling",
  },
  { "zG", desc = "Accept word temporarily" },
})
