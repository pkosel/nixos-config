{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wl-clipboard ];

  # Electron defaults to XWayland; this makes vscode, obsidian, bitwarden and
  # signal use wayland directly. At the current 1920x1080 scale-1 setup that is
  # not a visible difference — it drops a translation layer, and keeps input
  # and scaling correct if a scaled display is ever attached.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
