{ ... }:

{
  programs.ripgrep = {
    enable = true;

    # --hidden because a dotfile-heavy repo is exactly what gets searched here;
    # .gitignore is still honoured, so .git itself is the only thing to exclude.
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/"
    ];
  };
}
