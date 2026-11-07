{ ... }:

{
  imports = [
    ./nvim
    ./vscode.nix
  ];

  home.sessionVariables.EDITOR = "nvim";

  home.file.".editorconfig".text = ''
    [*]
    charset = utf-8
    indent_style = space
    indent_size = 4
    end_of_line = lf
    insert_final_newline = true
    trim_trailing_whitespace = true

    [*.{nix,lua,yaml,yml,json,jsonc,toml,md,markdown}]
    indent_size = 2

    # Make recipes require literal tabs; Go's formatter also uses tabs.
    [{[Mm]akefile,[Mm]akefile.*,GNUmakefile,GNUmakefile.*,*.mk,*.mak,*.make,*.go}]
    indent_style = tab
    indent_size = tab
    tab_width = 8

    [*.md]
    trim_trailing_whitespace = false
  '';
}
