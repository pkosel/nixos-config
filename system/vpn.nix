{ ... }:

{
  # The mullvad daemon manages its own wireguard tunnels; the NixOS wireguard
  # module only does anything once networking.wireguard.interfaces is set.
  services.mullvad-vpn.enable = true;
}
