{ ... }:

{
  # The shell itself is set on the user in hosts/frieda/default.nix;
  # this is only the interactive configuration.
  programs.fish = {
    enable = true;

    # Abbreviations expand in place when you press Space or Enter, so you
    # always see the full command before running it.
    shellAbbrs = {
      # Git ergonomics.
      gc = "git commit";
      gca = "git commit --amend --no-edit";
      gco = "git checkout";
      gd = "git diff";
      gl = "git pull";
      gp = "git push";
      gst = "git status";
      gsw = "git switch";
    };

    functions = {
      # Create a directory and enter it in one step.
      mkcd = "mkdir -p $argv[1] && cd $argv[1]";
    };

    interactiveShellInit = ''
      # bat as man pager: renders man pages with syntax highlighting.
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'";
      # less: -R passes raw control chars for colour, -i is smart-case search,
      #   -M shows a verbose prompt with file name and position.
      set -gx LESS "-R -i -M";
    '';
  };
}
