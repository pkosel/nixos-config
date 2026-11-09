{ inputs, pkgs, ... }:

let
  nixdSettings = import ./nixd.nix { inherit inputs pkgs; };
in
{
  programs.vscode = {
    enable = true;
    # FHS variant, for extensions that fetch prebuilt binaries NixOS can't run.
    package = pkgs.vscode.fhs;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        editorconfig.editorconfig
        vscodevim.vim

        mkhl.direnv

        jnoortheen.nix-ide

        ms-python.python
        ms-python.black-formatter
        ms-python.flake8
        ms-python.isort
        ms-python.vscode-pylance

        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        tamasfe.even-better-toml

        github.github-vscode-theme
      ];

      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings".nixd = nixdSettings;

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
      };
    };
  };
}
