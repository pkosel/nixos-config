{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Philipp Kosel";
        email = "p.kosel@tuta.io";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
