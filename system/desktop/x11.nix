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
  # So this is permanent, and it has a cost under GNOME 50: kitty is an XWayland
  # surface inside a mutter-drawn decoration, and the pointer changes size
  # crossing that seam. Native wayland clients like firefox do not show it.
  # The trade is a native titlebar against that seam — revisit if the seam ever
  # annoys more than the CSD look would.
  #
  # No services.xserver.enable: XWayland is spawned by mutter rather than by
  # xorg-server, so enabling it only added an X server that never ran plus a
  # dozen X utilities. The cost is that GDM no longer offers a GNOME-on-Xorg
  # session, so a broken wayland stack means booting an older generation.
  environment.systemPackages = with pkgs; [ xclip ];
}
