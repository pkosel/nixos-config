{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wl-clipboard ];

  # Electron defaults to XWayland. This makes vscode, obsidian, bitwarden and
  # signal use Wayland directly. At the current 1920x1080 scale-1 setup the
  # difference is not visible. The change drops a translation layer and keeps
  # input and scaling correct if a scaled display is attached.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
