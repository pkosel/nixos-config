{ pkgs, lib, ... }:

let
  pomo-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "pomo.nvim";
    buildInputs = with pkgs; [
      stylua
      luajitPackages.luacheck
    ];
    src = pkgs.fetchFromGitHub {
      owner = "epwalsh";
      repo = "pomo.nvim";
      rev = "05486f9f11516cacd43ccf0b65c80ed5978114ab";
      hash = "sha256-nhWje8xBXE4TgaNGRjwXtBKFuBecGroYEOn0Q7Rhx14=";
    };
  };
in
{
  programs.neovim = {
    # defaultEditor = true;
    enable = true;

    # 26.05 defaults both to false. Nothing in the lua config uses either.
    withRuby = false;
    withPython3 = false;

    initLua =
      with builtins;
      lib.foldl (r: f: r + "\n" + readFile f) "" [
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

      # linters & formatters
      nixfmt-classic
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

      # treesitter — pinned to the legacy generation. 26.05 made
      # nvim-treesitter the upstream "main" rewrite, which drops the module
      # system; treesitter.lua configures refactor and textobjects through
      # require("nvim-treesitter.configs").setup, which only exists here.
      # Mixing the two is a build error, not a runtime surprise.
      # Migrating is an nvim-config job: deprecated in 26.05, error in 26.11.
      #nvim-treesitter-legacy
      nvim-treesitter-legacy.withAllGrammars
      nvim-treesitter-refactor
      nvim-treesitter-textobjects-legacy
      nvim-treesitter-context

      # lsp
      nvim-lspconfig
      none-ls-nvim
    ];
    viAlias = true;
    vimAlias = true;
  };
}
