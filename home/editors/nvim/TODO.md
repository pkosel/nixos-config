# Neovim cleanup

Findings from a review of the Neovim configuration, deferred until the config
gets its own pass. Roughly in order of importance.

## Time-bound

- **Migrate off `nvim-treesitter-legacy`.** It is deprecated in 26.05 and an
  error in 26.11. `treesitter.lua` uses `require("nvim-treesitter.configs")`,
  which only exists in the legacy plugin. The refactor and textobjects
  companions were already dropped because nvim 0.12 broke them
  (see the comment in `default.nix`).

## Formatting

- `.stylua.toml` only sets `column_width`, so stylua indents with tabs, while the
  files use 2 spaces. `<leader>f` formats through none-ls with stylua, so it
  would reformat a Lua file to tabs. Set `indent_type = "Spaces"` and
  `indent_width = 2`, then run stylua once.
- Even with that, `lsp.lua`, `telescope.lua` and `completion.lua` change.
- `completion.lua`, `has_words_before`: the line
  `vim.api .nvim_buf_get_lines(...)[1] :sub(col, col) :match("%s")` has stray
  spaces before the dots. It works, but is unreadable; stylua will normalise it.
- `AGENTS.md` no longer mentions stylua; add the formatting step back once the
  files are clean.

## Structure

- `default.nix` joins all Lua files into one `initLua` string, so they share a
  single chunk: top-level locals leak between files (`local wk` is declared in
  both `init.lua` and `telescope.lua`), Lua caps a chunk at 200 locals, and
  error messages lose their file names. Installing them as `lua/*.lua` through
  `xdg.configFile` and loading them with `require` avoids all three.
- Along the way, `with builtins; lib.foldl …` can become
  `lib.concatMapStringsSep "\n" builtins.readFile`.
- `init.lua` replaces `vim.keymap.set` globally to default to `silent`. That is
  surprising; pass `silent = true` where it matters instead.

## Dead code

- `default.nix`: the `pomo-nvim` let binding is built but never used (the plugin
  line is commented out, as is `defaultEditor = true;` and the
  `#nvim-treesitter-legacy` line).
- `telescope.lua`: commented-out `<leader>tp` mapping.

## Worth checking

- `nvim-comment` is probably redundant: nvim 0.10+ has built-in `gc` commenting.
