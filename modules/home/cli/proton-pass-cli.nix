{ pkgs, ... }:

{
  home.packages = [ pkgs.proton-pass-cli ];

  # The kernel backend returns AccessDenied in the GNOME desktop session.
  # Use its Secret Service instead: https://github.com/NixOS/nixpkgs/issues/519229
  home.sessionVariables.PROTON_PASS_LINUX_KEYRING = "dbus";
}
