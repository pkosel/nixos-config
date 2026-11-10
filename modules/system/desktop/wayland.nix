{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wl-clipboard ];

  # Prefer native Wayland for applications whose wrappers honor this variable.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
