{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./nvim
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    fzf
    ripgrep
  ];

  home.sessionVariables.EDITOR = "nvim";

  home.file.".editorconfig".text = ''
    [*]
    charset = utf-8
    indent_style = space
    indent_size = 2
    end_of_line = lf
    insert_final_newline = true
    trim_trailing_whitespace = true

    [*.md]
    insert_final_newline = false
    trim_trailing_whitespace = false
  '';
}
