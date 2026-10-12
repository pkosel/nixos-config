{ pkgs, ... }:

{
  # The mullvad daemon manages its own wireguard tunnels; the NixOS wireguard
  # module only does anything once networking.wireguard.interfaces is set.
  services.mullvad-vpn = {
    enable = true;
    # The default, pkgs.mullvad, has the daemon and CLI but no GUI. The GUI is
    # only packaged in pkgs.mullvad-vpn. The two are unrelated derivations (one
    # built from source, one unpacked from the upstream .deb) with independent
    # versions, so installing both could pair the GUI with a daemon of another
    # version. pkgs.mullvad-vpn alone ships daemon, CLI and GUI from one release.
    package = pkgs.mullvad-vpn;
  };
}
