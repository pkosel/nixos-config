{ pkgs, ... }:

{
  # The mullvad daemon manages its own wireguard tunnels; the NixOS wireguard
  # module only does anything once networking.wireguard.interfaces is set.
  services.mullvad-vpn = {
    enable = true;
    # The default, pkgs.mullvad, is daemon + cli only, so the gui had to be
    # installed separately. They are unrelated derivations — one built from
    # source, one unpacked from the upstream .deb — that pin their versions
    # independently, so a nixpkgs bump could leave the gui talking to a daemon
    # of a different version. This package carries both.
    package = pkgs.mullvad-vpn;
  };
}
