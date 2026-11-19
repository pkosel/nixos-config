return function(workspace)
  -- Obsidian requires an existing workspace; the vault may not be set up yet.
  if vim.fn.isdirectory(workspace.path) == 0 then
    return
  end

  require("obsidian").setup({
    workspaces = { workspace },
    legacy_commands = false,
    picker = { name = "telescope.nvim" },
    -- Preserve existing note metadata and Markdown rendering.
    frontmatter = { enabled = false },
    ui = { enable = false },
  })
end
