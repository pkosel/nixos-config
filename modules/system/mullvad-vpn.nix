{ pkgs, ... }:

{
  services.mullvad-vpn = {
    enable = true;
    # This package supplies a matching GUI and daemon; the default has no GUI.
    package = pkgs.mullvad-vpn;
  };
}
