{ pkgs, ... }:

{
  # X11 client support for the applications still running under XWayland. kitty
  # is pinned to linux_display_server = "x11" because its wayland titlebar
  # decorations still render wrong under GNOME (kitty#3284, retested on 0.44.0),
  # and xclip is the clipboard tool for that side.
  #
  # No services.xserver.enable: XWayland is spawned by mutter rather than by
  # xorg-server, so enabling it only added an X server that never ran plus a
  # dozen X utilities. The cost is that GDM no longer offers a GNOME-on-Xorg
  # session, so a broken wayland stack means booting an older generation.
  environment.systemPackages = with pkgs; [ xclip ];
}
