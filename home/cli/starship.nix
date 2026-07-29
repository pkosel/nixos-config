{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # Off by default, so a failed command left no trace in the prompt.
      status.disabled = false;
      status.symbol = "❌ ";

      # On by default and reads ~/.aws/config, so it rendered everywhere.
      aws.disabled = true;

      # kitty and nvim mis-measure multi-width emoji.
      nix_shell.symbol = " ";
    };
  };
}
