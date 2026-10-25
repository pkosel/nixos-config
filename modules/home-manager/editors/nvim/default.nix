{ pkgs, ... }:

{
  programs.neovim = {
    # defaultEditor is in hosts/frieda/default.nix.
    enable = true;

    # 26.05 defaults both to false. Nothing in the lua config uses either.
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      # telescope shells out to these
      fd
      ripgrep

      # language servers
      bash-language-server
      dockerfile-language-server
      lua-language-server
      marksman
      nil
      pyright
      rust-analyzer
      sqls
      taplo
      terraform-ls
      yaml-language-server

      # formatters / linters
      hadolint
      markdownlint-cli
      nixfmt
      ruff
      rustfmt
      shellcheck
      shfmt
      statix
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      # ui
      lualine-nvim
      night-owl-nvim
      nvim-web-devicons
      which-key-nvim

      # snippets
      luasnip

      # mini
      mini-nvim

      # file tree
      nvim-tree-lua

      # telescope
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-nvim

      # git
      diffview-nvim
      gitsigns-nvim
      neogit

      # cmp
      cmp_luasnip
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      friendly-snippets
      nvim-cmp

      # treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context

      # editing
      indent-blankline-nvim

      # highlights
      todo-comments-nvim

      # diagnostics
      trouble-nvim

      # navigation
      harpoon2
      oil-nvim

      # formatting / linting
      conform-nvim
      nvim-lint

      # lsp
      nvim-lspconfig
    ];
    viAlias = true;
    vimAlias = true;
  };

  # Lua config is installed as individual files and loaded via require.
  # This fixes the 200-local-variable per-chunk limit and keeps scopes clean.
  xdg.configFile =
    let
      cfgDir = "nvim";
    in
    {
      "${cfgDir}/init.lua".text = builtins.readFile ./init.lua;

      "${cfgDir}/lua/config/options.lua".text = builtins.readFile ./lua/config/options.lua;
      "${cfgDir}/lua/config/keymaps.lua".text = builtins.readFile ./lua/config/keymaps.lua;
      "${cfgDir}/lua/config/plugin_setups.lua".text = builtins.readFile ./lua/config/plugin_setups.lua;
      "${cfgDir}/lua/config/comment.lua".text = builtins.readFile ./lua/config/comment.lua;
      "${cfgDir}/lua/config/completion.lua".text = builtins.readFile ./lua/config/completion.lua;
      "${cfgDir}/lua/config/conform.lua".text = builtins.readFile ./lua/config/conform.lua;
      "${cfgDir}/lua/config/harpoon.lua".text = builtins.readFile ./lua/config/harpoon.lua;
      "${cfgDir}/lua/config/indent.lua".text = builtins.readFile ./lua/config/indent.lua;
      "${cfgDir}/lua/config/lint.lua".text = builtins.readFile ./lua/config/lint.lua;
      "${cfgDir}/lua/config/oil.lua".text = builtins.readFile ./lua/config/oil.lua;
      "${cfgDir}/lua/config/pairs.lua".text = builtins.readFile ./lua/config/pairs.lua;
      "${cfgDir}/lua/config/surround.lua".text = builtins.readFile ./lua/config/surround.lua;
      "${cfgDir}/lua/config/tabline.lua".text = builtins.readFile ./lua/config/tabline.lua;
      "${cfgDir}/lua/config/telescope.lua".text = builtins.readFile ./lua/config/telescope.lua;
      "${cfgDir}/lua/config/todo.lua".text = builtins.readFile ./lua/config/todo.lua;
      "${cfgDir}/lua/config/treesitter.lua".text = builtins.readFile ./lua/config/treesitter.lua;
      "${cfgDir}/lua/config/trouble.lua".text = builtins.readFile ./lua/config/trouble.lua;
      "${cfgDir}/lua/config/lsp.lua".text = builtins.readFile ./lua/config/lsp.lua;
      "${cfgDir}/lua/config/lualine.lua".text = builtins.readFile ./lua/config/lualine.lua;
    };
}
