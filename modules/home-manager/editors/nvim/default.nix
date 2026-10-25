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
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      luasnip
      night-owl-nvim
      nvim-comment
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

      # treesitter — pinned to the legacy generation. 26.05 rewrote
      # nvim-treesitter and dropped the module system that treesitter.lua
      # depends on. Migrating is an nvim-config job: deprecated in 26.05,
      # error in 26.11. nvim 0.12 broke the refactor and textobjects
      # companions; only highlight, indent and incremental_selection work.
      nvim-treesitter-legacy.withAllGrammars
      nvim-treesitter-context

      # lsp
      nvim-lspconfig
      none-ls-nvim
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
      "${cfgDir}/lua/treesitter.lua".text = builtins.readFile ./lua/treesitter.lua;
    };
}
