{ ... }:

{
  programs.fzf = {
    # The module writes the fish key bindings (ctrl-r, ctrl-t, alt-c); the bare
    # package has none, so history search would stay plain readline.
    enable = true;

    # Exclude the flake build result symlink so Ctrl+T does not scan the Nix store.
    fileWidgetCommand = "fd --type f --exclude result";

    # ANSI names, so the colours come from Ghostty's active theme and follow the
    # dark/light switch. Without them fzf's own palette is unreadable on one of
    # the two.
    colors = {
      bg = "-1";
      "bg+" = "bright-black";
      fg = "-1";
      "fg+" = "-1";
      gutter = "-1";
      "hl+" = "yellow";
      hl = "yellow";
      header = "bright-black";
      info = "blue";
      marker = "green";
      pointer = "red";
      prompt = "cyan";
      spinner = "magenta";
    };
  };
}
