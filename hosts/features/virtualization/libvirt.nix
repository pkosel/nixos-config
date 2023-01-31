{
  config,
  pkgs,
  ...
}: {
  virtualisation.libvirtd.enable = true;

  # file-sharing via spice: dav://localhost:9843
  environment.systemPackages = with pkgs; [
    gnome.gnome-boxes
  ];
}
