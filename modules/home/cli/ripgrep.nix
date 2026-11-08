{ ... }:

{
  programs.ripgrep = {
    enable = true;

    # Include dotfiles when searching configuration repositories.
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/"
    ];
  };
}
