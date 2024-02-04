{ lib, pkgs, ... }:

let
  pomo-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "pomo.nvim";
    buildInputs = with pkgs; [ stylua luajitPackages.luacheck ];
    src = pkgs.fetchFromGitHub {
      owner = "epwalsh";
      repo = "pomo.nvim";
      rev = "05486f9f11516cacd43ccf0b65c80ed5978114ab";
      hash = "sha256-nhWje8xBXE4TgaNGRjwXtBKFuBecGroYEOn0Q7Rhx14=";
    };
  };
in {
  programs.neovim = {
    # defaultEditor = true;
    enable = true;
    extraLuaConfig = with builtins;
      lib.foldl (r: f: r + "\n" + readFile f) "" [
        ./init.lua
        ./completion.lua
        ./lsp.lua
        ./lualine.lua
        ./telescope.lua
        ./treesitter.lua
      ];
    extraPackages = with pkgs; [
      # language servers
      lua-language-server
      marksman
      nil

      # linters & formatters
      nixfmt
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      gruvbox-material
      lualine-nvim
      luasnip
      nvim-comment
      nvim-tree-lua
      nvim-web-devicons
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-nvim
      which-key-nvim
      # pomo-nvim

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
      #nvim-treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-treesitter-context

      # lsp
      nvim-lspconfig
      null-ls-nvim
    ];
    viAlias = true;
    vimAlias = true;
  };
}
