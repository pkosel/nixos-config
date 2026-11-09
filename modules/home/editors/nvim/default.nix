{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    initLua = builtins.readFile ./init.lua;

    # Home Manager defaults both to false for home.stateVersion >= 26.05,
    # but to true at our fixed 25.11. Nothing in the Lua config uses either.
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      # Search tools
      fd
      ripgrep

      # Language servers
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

      # Formatters and linters
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
      # Interface
      lualine-nvim
      night-owl-nvim
      noice-nvim
      nvim-web-devicons
      which-key-nvim

      # Editing and diagnostics
      conform-nvim
      indent-blankline-nvim
      mini-nvim
      nvim-lint
      todo-comments-nvim
      trouble-nvim

      # Navigation
      flash-nvim
      harpoon2
      nvim-tree-lua
      oil-nvim
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-nvim

      # Git
      diffview-nvim
      gitsigns-nvim
      neogit

      # Completion and language support
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      friendly-snippets
      luasnip
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
    ];
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim/lua".source = ./lua;
}
