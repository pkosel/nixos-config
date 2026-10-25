require("telescope").setup()
require("telescope").load_extension("fzy_native")

local builtin = require("telescope.builtin")
local wk = require("which-key")

wk.add({
  { "<leader>t", group = "Telescope" },
  { "<leader>ta", builtin.autocommands, desc = "Autocommands" },
  { "<leader>tb", builtin.current_buffer_fuzzy_find, desc = "Current buffer" },
  { "<leader>tB", builtin.buffers, desc = "Buffers" },
  { "<leader>tc", builtin.live_grep, desc = "Live grep" },
  { "<leader>tC", builtin.commands, desc = "Commands" },
  { "<leader>tf", builtin.find_files, desc = "Files" },

  { "<leader>tg", group = "Git" },
  { "<leader>tgb", builtin.git_branches, desc = "Branches" },
  { "<leader>tgc", builtin.git_bcommits, desc = "Commits in buffer" },
  { "<leader>tgC", builtin.git_commits, desc = "Commits" },
  { "<leader>tgf", builtin.git_files, desc = "Files" },
  { "<leader>tgs", builtin.git_status, desc = "Status" },
  { "<leader>tgS", builtin.git_stash, desc = "Stash" },

  { "<leader>th", builtin.search_history, desc = "Search history" },
  { "<leader>tH", builtin.command_history, desc = "Command history" },
  { "<leader>tj", builtin.jumplist, desc = "Jump List" },

  { "<leader>tl", group = "LSP" },
  { "<leader>tld", builtin.lsp_definitions, desc = "Definitions" },
  { "<leader>tlD", builtin.diagnostics, desc = "Diagnostics" },
  { "<leader>tli", builtin.lsp_implementations, desc = "Implementations" },
  { "<leader>tlr", builtin.lsp_references, desc = "References" },
  { "<leader>tls", builtin.lsp_document_symbols, desc = "Document symbols" },
  { "<leader>tlS", builtin.lsp_workspace_symbols, desc = "Workspace symbols" },
  { "<leader>tly", builtin.lsp_type_definitions, desc = "Type definitions" },

  { "<leader>tL", builtin.loclist, desc = "Location list" },
  { "<leader>tm", builtin.marks, desc = "Marks" },
  { "<leader>tM", builtin.man_pages, desc = "Man pages" },
  { "<leader>to", builtin.oldfiles, desc = "Previously open files" },
  -- { "<leader>tp", require("telescope").extensions.project.project, desc = "Projects" },
  { "<leader>tP", builtin.pickers, desc = "Pickers" },
  { "<leader>tq", builtin.quickfix, desc = "Quickfix" },
  { "<leader>tQ", builtin.quickfixhistory, desc = "Quickfix history" },
  { "<leader>tr", builtin.resume, desc = "Resume" },
  { "<leader>tR", builtin.registers, desc = "Registers" },
  { "<leader>ts", builtin.grep_string, desc = "Grep string under cursor" },
  { "<leader>tt", builtin.tags, desc = "Tags" },
  { "<leader>tT", builtin.current_buffer_tags, desc = "Tags in current buffer" },
  { "<leader>tv", builtin.vim_options, desc = "Vim options" },

  { "<leader>tx", group = "More" },
  { "<leader>txh", builtin.highlights, desc = "Highlights" },
  { "<leader>txH", builtin.help_tags, desc = "Help tags" },
  { "<leader>txt", builtin.treesitter, desc = "Treesitter" },
})
