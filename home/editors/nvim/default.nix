{ pkgs, lib, ... }:

{
  programs.neovim = {
    # defaultEditor is in hosts/frieda/configuration.nix.
    enable = true;

    # 26.05 defaults both to false. Nothing in the lua config uses either.
    withRuby = false;
    withPython3 = false;

    initLua = lib.concatMapStringsSep "\n" builtins.readFile [
      ./init.lua
      ./completion.lua
      ./lsp.lua
      ./lualine.lua
      ./telescope.lua
      ./treesitter.lua
    ];
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
}
