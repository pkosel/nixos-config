{ pkgs, theme, ... }:

let
  toml = pkgs.formats.toml { };
in
{
  home.packages = [ pkgs.mdcat ];

  # mdcat has no home-manager module. config.toml is its own mechanism and
  # beats MDCAT_THEME on reach: session variables only exist in a login shell.
  # base means "start from this built-in theme"; mdcat has no Night Owl, so the
  # elements that carry colour are overridden from the shared palette.
  xdg.configFile."mdcat/config.toml".source = toml.generate "mdcat-config.toml" {
    theme = {
      base = theme.mdcat;
      rule = "gray";
      palette = { inherit (theme.palette) blue aqua gray; };
      styles =
        let
          heading = {
            fg = "blue";
            modifiers = [ "bold" ];
          };
          link = {
            fg = "aqua";
            modifiers = [ "underline" ];
          };
        in
        {
          h1_text = heading;
          h2 = heading;
          h3 = heading;
          h4 = heading;
          h5 = heading;
          h6 = heading;
          code.fg = "aqua";
          inherit link;
          image_link = link;
          quote_border.fg = "gray";
          footnote.fg = "gray";
        };
    };
  };
}
