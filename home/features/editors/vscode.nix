{ config, pkgs, nix-vscode-extensions, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with nix-vscode-extensions.extensions."x86_64-linux"; [
      vscode-marketplace.vscodevim.vim

      vscode-marketplace.mkhl.direnv

      vscode-marketplace.ms-python.python
      vscode-marketplace.ms-python.black-formatter
      vscode-marketplace.ms-python.flake8
      vscode-marketplace.ms-python.isort
      vscode-marketplace.ms-python.vscode-pylance

      # ms-vscode.cpptools
      # ms-vscode.cpptools-extension-pack

      vscode-marketplace.evzen-wybitul.magic-racket

      # vscode-marketplace.reditorsupport.r
      # vscode-marketplace.rdebugger.r-debugger

      vscode-marketplace.github.github-vscode-theme
    ];
  };
}

