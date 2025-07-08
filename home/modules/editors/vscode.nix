{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    profiles.default.enableUpdateCheck = false;
    profiles.default.enableExtensionUpdateCheck = false;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim

      mkhl.direnv

      jnoortheen.nix-ide

      # python
      ms-python.python
      ms-python.black-formatter
      ms-python.flake8
      ms-python.isort
      ms-python.vscode-pylance

      # rust
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      tamasfe.even-better-toml

      github.github-vscode-theme
    ];
  };
}
