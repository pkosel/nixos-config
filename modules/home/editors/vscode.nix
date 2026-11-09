{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  nixdSettings = import ./nixd.nix { inherit inputs pkgs; };
in
{
  programs.vscode = {
    enable = true;
    # FHS variant, for extensions that fetch prebuilt binaries NixOS can't run.
    package = pkgs.vscode.fhs;
    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        editorconfig.editorconfig
        vscodevim.vim
        mkhl.direnv

        jnoortheen.nix-ide

        charliermarsh.ruff
        ms-python.python
        ms-python.vscode-pylance

        rust-lang.rust-analyzer
        tamasfe.even-better-toml

        sdras.night-owl
      ];

      userSettings = {
        "extensions.autoUpdate" = false;
        "workbench.colorTheme" = "Night Owl";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings".nixd = nixdSettings;
        "python.analysis.typeCheckingMode" = "basic";

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };

        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
          "editor.formatOnSave" = true;
          "editor.codeActionsOnSave" = {
            "source.fixAll.ruff" = "explicit";
            "source.organizeImports.ruff" = "explicit";
          };
        };

        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
          "editor.formatOnSave" = true;
        };

        "[toml]" = {
          "editor.defaultFormatter" = "tamasfe.even-better-toml";
          "editor.formatOnSave" = true;
        };

      }
      // lib.genAttrs [ "[json]" "[jsonc]" ] (_: {
        "editor.defaultFormatter" = "vscode.json-language-features";
        "editor.formatOnSave" = true;
      });
    };
  };
}
