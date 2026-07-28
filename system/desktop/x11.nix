{ pkgs, ... }:

{
  # X11 client support for the applications still running under XWayland, and
  # xclip as the clipboard tool for that side.
  #
  # kitty is pinned to linux_display_server = "x11" to get native GNOME titlebars.
  # This is upstream's own advice, not a workaround for a bug: GNOME does not
  # implement server-side decorations on wayland, so kitty draws its own
  # client-side ones, which will never match the desktop. kitty#3284 is closed as
  # completed — what was completed is the CSD support, not native decorations.
  # Verified still the case on 0.47.0.
  #
  # So this is permanent rather than pending, and the cost is just that kitty
  # renders through XWayland. That is cheap here: the pointer-size seam seen at
  # kitty's border right after the 26.05 upgrade was stale XWayland state from
  # changing the display scale mid-session, and a re-login cleared it.
  #
  # No services.xserver.enable: XWayland is spawned by mutter rather than by
  # xorg-server, so enabling it only added an X server that never ran plus a
  # dozen X utilities. The cost is that GDM no longer offers a GNOME-on-Xorg
  # session, so a broken wayland stack means booting an older generation.
  environment.systemPackages = with pkgs; [ xclip ];
}
