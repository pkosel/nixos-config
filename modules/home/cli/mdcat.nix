{ pkgs, ... }:

let
  toml = pkgs.formats.toml { };
in
{
  home.packages = [ pkgs.mdcat ];

  # ANSI colors keep Markdown styling tied to the terminal palette.
  xdg.configFile."mdcat/config.toml".source = toml.generate "mdcat-config.toml" {
    theme = {
      rule = "bright-black";
      styles =
        let
          heading = {
            fg = "blue";
            modifiers = [ "bold" ];
          };
          link = {
            fg = "cyan";
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
          code.fg = "cyan";
          inherit link;
          image_link = link;
          quote_border.fg = "bright-black";
          footnote.fg = "bright-black";
        };
    };
  };
}
