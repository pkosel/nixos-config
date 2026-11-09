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
    # FHS supports prebuilt extension binaries; the Terraform extension also needs its CLI.
    package = pkgs.vscode.fhsWithPackages (pkgs: [ pkgs.terraform ]);
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

        biomejs.biome
        esbenp.prettier-vscode
        docker.docker
        hashicorp.terraform

        sdras.night-owl
      ];

      userSettings = {
        "extensions.autoUpdate" = false;
        "workbench.colorTheme" = "Night Owl";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings".nixd = nixdSettings;
        "python.analysis.typeCheckingMode" = "basic";
        "markdown.validate.enabled" = true;
        "markdown.updateLinksOnFileMove.enabled" = "prompt";
        "terraform.languageServer.path" = "${pkgs.terraform-ls}/bin/terraform-ls";
        "docker.lsp.telemetry" = "off";
        "docker.lsp.experimental.vulnerabilityScanning" = false;

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
      })
      // lib.genAttrs [ "[markdown]" "[yaml]" ] (_: {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
      })
      // lib.genAttrs [ "[javascript]" "[javascriptreact]" "[typescript]" "[typescriptreact]" ] (_: {
        "editor.defaultFormatter" = "biomejs.biome";
        "editor.formatOnSave" = true;
      })
      // lib.genAttrs [ "[terraform]" "[terraform-vars]" ] (_: {
        "editor.defaultFormatter" = "hashicorp.terraform";
        "editor.formatOnSave" = true;
      });
    };
  };
}
