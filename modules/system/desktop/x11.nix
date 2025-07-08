{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [ xclip ];

  services.xserver.enable = true;
  services.xserver.xkb.layout = "eu";
}
