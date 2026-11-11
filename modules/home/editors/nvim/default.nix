{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  nixdSettings = import ../nixd.nix { inherit inputs pkgs; };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    initLua = ''
      vim.lsp.config("nixd", ${lib.generators.toLua { } { settings.nixd = nixdSettings; }})
      ${builtins.readFile ./init.lua}
    '';

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
      fish-lsp
      just-lsp
      lua-language-server
      marksman
      nixd
      pyright
      rust-analyzer
      sqls
      taplo
      terraform-ls
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server

      # Formatters and linters
      biome
      hadolint
      markdownlint-cli
      nixfmt
      prettier
      ruff
      rustfmt
      shellcheck
      shfmt
      statix
      stylua
      terraform
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
      (nvim-treesitter.withPlugins (
        parsers: with parsers; [
          bash
          comment
          css
          csv
          diff
          dockerfile
          editorconfig
          fish
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          hcl
          html
          ini
          javascript
          jsdoc
          json
          just
          lua
          luadoc
          luap
          make
          markdown
          markdown_inline
          nix
          python
          query
          regex
          rust
          sql
          terraform
          toml
          tsx
          typescript
          vimdoc
          yaml
        ]
      ))
      nvim-treesitter-context
    ];
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile = {
    "nvim/lua".source = ./lua;
    "nvim/spell/de.utf-8.spl".source = pkgs.fetchurl {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.spl";
      hash = "sha256-c8cQfqM5hWzb6SHeuSpFk5xN5uucByYdobndGfaDo9E=";
    };
    "nvim/spell/de.utf-8.sug".source = pkgs.fetchurl {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.sug";
      hash = "sha256-E9Ds+Shj2J72DNSopesqWhOg6Pm6jRxqvkerqFcUqUg=";
    };
  };
}
