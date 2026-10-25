{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wl-clipboard ];

  # Electron defaults to XWayland. This forces Wayland directly,
  # dropping a translation layer and keeping scaling correct.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
