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
  if
    not vim.api.nvim_buf_is_valid(bufnr)
    or not vim.api.nvim_buf_is_loaded(bufnr)
  then
    return
  end

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
    lint.try_lint(nil, {
      filter = function(linter)
        if not stdin_only then
          return true
        end
        -- Keep existing-file ShellCheck on read/save/manual events for SCRIPTDIR.
        return linter.stdin == true
          and not (
            linter.name == "shellcheck" and vim.fn.filereadable(name) == 1
          )
      end,
    })
  end)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("config_lint", { clear = true }),
  callback = function(args)
    if args.event == "BufReadPost" then
      -- Filetype detection may run in a later BufReadPost callback.
      vim.schedule(function()
        lint_buffer(args.buf, false)
      end)
    else
      lint_buffer(args.buf, args.event == "InsertLeave")
    end
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
