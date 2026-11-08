{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      status.disabled = false;
      status.symbol = "❌ ";

      aws.disabled = true;

      # The symbol is a space because nvim mis-measures multi-width emoji.
      nix_shell.symbol = " ";
    };
  };
}
