local lint = require("lint")

lint.linters_by_ft = {
  bash = { "shellcheck" },
  dockerfile = { "hadolint" },
  markdown = { "markdownlint" },
  nix = { "statix" },
  python = { "ruff" },
  sh = { "shellcheck" },
}

local function lint_buffer(bufnr, event)
  if
    not vim.api.nvim_buf_is_valid(bufnr)
    or not vim.api.nvim_buf_is_loaded(bufnr)
  then
    return
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  if
    vim.bo[bufnr].buftype ~= ""
    or filename == ""
    or filename:match("^%a[%w+.-]*://")
    or vim.fn.isdirectory(filename) == 1
  then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    lint.try_lint(nil, {
      filter = function(linter)
        if event ~= "InsertLeave" then
          return true
        end
        if linter.stdin ~= true then
          return false
        end

        -- ShellCheck reads existing files from disk for SCRIPTDIR. Keep this
        -- exception until --stdin-filename is supported:
        -- https://github.com/koalaman/shellcheck/issues/2735
        if linter.name == "shellcheck" then
          return vim.fn.filereadable(filename) == 0
        end
        return true
      end,
    })
  end)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("config.lint", { clear = true }),
  callback = function(args)
    if args.event == "BufReadPost" then
      -- Filetype detection may run in a later BufReadPost callback.
      vim.schedule(function()
        lint_buffer(args.buf, args.event)
      end)
      return
    end
    lint_buffer(args.buf, args.event)
  end,
})

local which_key = require("which-key")
which_key.add({
  {
    "<leader>cl",
    function()
      lint_buffer(vim.api.nvim_get_current_buf())
    end,
    desc = "Lint file",
  },
})
