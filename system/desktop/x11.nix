{ pkgs, ... }:

{
  # No services.xserver.enable here. The session is wayland, and the XWayland
  # that X11 clients actually talk to is spawned by mutter, not by xorg-server —
  # enabling it only added an X server that never ran, plus xterm and a dozen
  # X utilities. The cost is that GDM no longer offers a GNOME-on-Xorg session,
  # so a broken wayland stack means booting an older generation.
  environment.systemPackages = with pkgs; [ xclip ];

  # Not X-only despite living under services.xserver: console.useXkbConfig
  # derives the tty keymap from this, and GNOME takes its layout from it.
  services.xserver.xkb.layout = "eu";
}
