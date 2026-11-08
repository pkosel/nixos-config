{ ... }:

{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;

    # ANSI colors keep these overrides tied to the terminal palette.
    theme = {
      filekinds = {
        normal.foreground = "Default";
        socket.foreground = "Purple";
        special.foreground = "Purple";
        mount_point.foreground = "Cyan";
      };

      perms = {
        special_other.foreground = "DarkGray";
        attribute.foreground = "DarkGray";
      };

      size = {
        major.foreground = "Default";
        minor.foreground = "Cyan";
        number_byte.foreground = "Default";
        number_kilo.foreground = "Default";
        number_mega.foreground = "Blue";
        number_giga.foreground = "Purple";
        unit_byte.foreground = "Default";
        unit_kilo.foreground = "Blue";
        unit_mega.foreground = "Blue";
        unit_giga.foreground = "Purple";
      };

      users = {
        user_root.foreground = "Red";
        user_other.foreground = "DarkGray";
        group_yours.foreground = "Default";
        group_root.foreground = "Red";
        group_other.foreground = "DarkGray";
      };

      links = {
        normal.foreground = "Cyan";
        multi_link_file.foreground = "Yellow";
      };

      git = {
        modified.foreground = "Yellow";
        renamed.foreground = "Blue";
        ignored.foreground = "DarkGray";
      };

      inode.foreground = "Default";
      blocks.foreground = "Default";
      header.foreground = "Default";
      broken_path_overlay.foreground = "Red";
    };
  };
}
