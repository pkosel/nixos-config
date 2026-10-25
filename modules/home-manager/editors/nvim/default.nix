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
      lua-language-server
      marksman
      nil

      # nixfmt, not nixfmt-classic: both name their binary nixfmt,
      # so none-ls needs no change, but classic is the pre-RFC style.
      nixfmt
      statix
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      luasnip
      night-owl-nvim
      mini-nvim
      nvim-tree-lua
      nvim-web-devicons
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-nvim
      which-key-nvim

      # git
      diffview-nvim
      gitsigns-nvim
      neogit

      # cmp
      nvim-cmp
      cmp-path
      cmp-buffer
      cmp-nvim-lsp

      # treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context

      # editing
      indent-blankline-nvim

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

      "${cfgDir}/lua/options.lua".text = builtins.readFile ./lua/options.lua;
      "${cfgDir}/lua/keymaps.lua".text = builtins.readFile ./lua/keymaps.lua;
      "${cfgDir}/lua/plugin_setups.lua".text = builtins.readFile ./lua/plugin_setups.lua;
      "${cfgDir}/lua/completion.lua".text = builtins.readFile ./lua/completion.lua;
      "${cfgDir}/lua/lsp.lua".text = builtins.readFile ./lua/lsp.lua;
      "${cfgDir}/lua/lualine.lua".text = builtins.readFile ./lua/lualine.lua;
      "${cfgDir}/lua/telescope.lua".text = builtins.readFile ./lua/telescope.lua;
      "${cfgDir}/lua/conform.lua".text = builtins.readFile ./lua/conform.lua;
      "${cfgDir}/lua/lint.lua".text = builtins.readFile ./lua/lint.lua;
      "${cfgDir}/lua/treesitter.lua".text = builtins.readFile ./lua/treesitter.lua;
      "${cfgDir}/lua/comment.lua".text = builtins.readFile ./lua/comment.lua;
      "${cfgDir}/lua/pairs.lua".text = builtins.readFile ./lua/pairs.lua;
      "${cfgDir}/lua/surround.lua".text = builtins.readFile ./lua/surround.lua;
      "${cfgDir}/lua/indent.lua".text = builtins.readFile ./lua/indent.lua;
    };
}
