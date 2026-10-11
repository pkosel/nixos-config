{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # Off by default, which leaves a failed command without a trace in the
      # prompt.
      status.disabled = false;
      status.symbol = "❌ ";

      # On by default and reads ~/.aws/config, so it would show in every prompt.
      aws.disabled = true;

      # nvim mis-measures multi-width emoji.
      nix_shell.symbol = " ";
    };
  };
}
