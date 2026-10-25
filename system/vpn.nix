{ pkgs, ... }:

{
  # The mullvad daemon manages its own wireguard tunnels.
  services.mullvad-vpn = {
    enable = true;
    # The default, pkgs.mullvad, has the daemon and CLI but no GUI.
    # pkgs.mullvad-vpn ships daemon, CLI and GUI from one release.
    package = pkgs.mullvad-vpn;
  };
}
