{ ... }:

let
  # ANSI names, so the colours come from Ghostty's active theme and follow the
  # dark/light switch. eza only knows these spellings: anything else, such as
  # BrightRed, is silently ignored.
  palette = {
    fg = "Default";
    fg2 = "Default";
    gray = "DarkGray";
    red = "Red";
    green = "Green";
    yellow = "Yellow";
    blue = "Blue";
    purple = "Purple";
    aqua = "Cyan";
  };

  fore = c: { foreground = c; };
in
{
  programs.eza = {
    # The module writes the ls, ll, la, lt and lla aliases for fish; the bare
    # package has none.
    enable = true;
    icons = "auto";
    git = true;

    # Written to ~/.config/eza/theme.yml, which eza reads on its own. Without it
    # eza keeps its built-in palette. eza has no named themes, so every element
    # is spelled out.
    theme = with palette; {
      filekinds = {
        normal = fore fg;
        directory = fore blue;
        executable = fore green;
        symlink = fore aqua;
        pipe = fore yellow;
        block_device = fore yellow;
        char_device = fore yellow;
        socket = fore purple;
        special = fore purple;
        mount_point = fore aqua;
      };

      # Write is red so a stray write bit stands out.
      perms = {
        user_read = fore yellow;
        user_write = fore red;
        user_execute_file = fore green;
        user_execute_other = fore green;
        group_read = fore yellow;
        group_write = fore red;
        group_execute = fore green;
        other_read = fore yellow;
        other_write = fore red;
        other_execute = fore green;
        special_user_file = fore purple;
        special_other = fore gray;
        attribute = fore gray;
      };

      size = {
        major = fore fg2;
        minor = fore aqua;
        number_byte = fore fg;
        number_kilo = fore fg;
        number_mega = fore blue;
        number_giga = fore purple;
        number_huge = fore purple;
        unit_byte = fore fg2;
        unit_kilo = fore blue;
        unit_mega = fore blue;
        unit_giga = fore purple;
        unit_huge = fore purple;
      };

      users = {
        user_you = fore yellow;
        user_root = fore red;
        user_other = fore gray;
        group_yours = fore fg2;
        group_root = fore red;
        group_other = fore gray;
      };

      links = {
        normal = fore aqua;
        multi_link_file = fore yellow;
      };

      git = {
        new = fore green;
        modified = fore yellow;
        deleted = fore red;
        renamed = fore blue;
        typechange = fore purple;
        ignored = fore gray;
        conflicted = fore red;
      };

      punctuation = fore gray;
      date = fore blue;
      inode = fore fg2;
      blocks = fore fg2;
      header = fore fg2;
      symlink_path = fore aqua;
      broken_symlink = fore red;
      broken_path_overlay = fore red;
    };
  };
}
