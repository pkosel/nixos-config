{ pkgs, ... }:

{
  # kitty is pinned to linux_display_server = "x11", so it runs under XWayland and
  # needs xclip for the clipboard. The pin is permanent, not a workaround: GNOME
  # does not do server-side decorations on wayland, so kitty draws its own and
  # they never match the desktop. Upstream advises the same in kitty#3284, still
  # true on 0.47.0.
  #
  # No services.xserver.enable: mutter spawns XWayland itself, so enabling it only
  # added an X server that never ran. The cost is no GNOME-on-Xorg session at GDM.
  environment.systemPackages = with pkgs; [ xclip ];
}
