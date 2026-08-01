{ pkgs, theme, ... }:

let
  toml = pkgs.formats.toml { };
in
{
  home.packages = [ pkgs.mdcat ];

  # mdcat has no home-manager module. config.toml is its own mechanism and
  # beats MDCAT_THEME on reach: session variables only exist in a login shell.
  # base means "start from this built-in theme", so mdcat's own gruvbox-dark
  # is used rather than restating the palette under [theme.palette].
  xdg.configFile."mdcat/config.toml".source = toml.generate "mdcat-config.toml" {
    theme.base = theme.mdcat;
  };
}
