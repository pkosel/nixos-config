{ config, ... }:

{
  # GNOME Wayland does not expose the virtual-keyboard protocol used by wtype.
  programs.ydotool.enable = true;
  users.groups.${config.programs.ydotool.group}.members = [ "philipp" ];
}
