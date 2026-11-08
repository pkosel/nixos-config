{ ... }:

{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      gc = "git commit";
      gca = "git commit --amend --no-edit";
      gco = "git checkout";
      gd = "git diff";
      gl = "git pull";
      gp = "git push";
      gst = "git status";
      gsw = "git switch";
    };

    interactiveShellInit = ''
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'";
      set -gx LESS "-R -i -M";
    '';
  };
}
