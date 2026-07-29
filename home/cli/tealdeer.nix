{ ... }:

{
  # enableAutoUpdates is on by default and pulls in a weekly systemd user timer
  # running tldr --update, so the page cache never has to be fetched by hand.
  programs.tealdeer.enable = true;
}
