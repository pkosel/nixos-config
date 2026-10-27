local lint = require("lint")

lint.linters_by_ft = {
  bash = { "shellcheck" },
  dockerfile = { "hadolint" },
  markdown = { "markdownlint" },
  nix = { "statix" },
  python = { "ruff" },
  sh = { "shellcheck" },
}

local function lint_buffer(bufnr, stdin_only)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if
    vim.bo[bufnr].buftype ~= ""
    or name == ""
    or name:match("^%a[%w+.-]*://")
    or vim.fn.isdirectory(name) == 1
  then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    -- Disk-based linters cannot check edits that have not been saved.
    lint.try_lint(nil, { filter = stdin_only and "stdin" or nil })
  end)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("config_lint", { clear = true }),
  callback = function(args)
    lint_buffer(args.buf, args.event == "InsertLeave")
  end,
})

local wk = require("which-key")
wk.add({
  {
    "<leader>cl",
    function()
      lint_buffer(vim.api.nvim_get_current_buf(), false)
    end,
    desc = "Lint file",
  },
})
