{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      status.disabled = false;
      status.symbol = "❌ ";

      aws.disabled = true;
    };
  };
}
