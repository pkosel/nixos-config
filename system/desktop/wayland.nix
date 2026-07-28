{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wl-clipboard ];

  # Electron defaults to XWayland, which loses native fractional scaling and
  # renders blurry on HiDPI. vscode, obsidian, bitwarden and signal all honour
  # this flag.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
