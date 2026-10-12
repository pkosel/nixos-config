{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # The module is off by default, so a failed command leaves no trace in the
      # prompt.
      status.disabled = false;
      status.symbol = "❌ ";

      # The module is on by default and reads ~/.aws/config, so it would show in
      # every prompt.
      aws.disabled = true;

      # The symbol is a space because nvim mis-measures multi-width emoji.
      nix_shell.symbol = " ";
    };
  };
}
