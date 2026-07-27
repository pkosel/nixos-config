{
  config,
  pkgs,
  lib,
  ...
}:

{
  networking.wireguard.enable = true;
  services.mullvad-vpn.enable = true;
}
