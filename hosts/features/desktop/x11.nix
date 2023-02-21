{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xclip ];

  services.xserver.enable = true;
  services.xserver.layout = "eu";
}
