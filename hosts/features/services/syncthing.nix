{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    dataDir = "/home/philipp";
    configDir = "/home/philipp/.config/syncthing";
    openDefaultPorts = true;
    user = "philipp";
    group = "users";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "laptop" = {
          id = "YNW3NRD-JGIMC7X-26MXMPI-OWPOK3P-ZPMPXFZ-4ZFK2YS-MXLAURW-SOVGQAI";
        };
        "phone" = {
          id = "OZGHQSB-YTYBBA5-3MHGSTP-6NDTKLQ-ZDTOFPO-WKS2NZY-26FENGZ-5EZQRQV";
        };
      };
      folders = {
        "Syncthing" = {
          path = "/home/philipp/Documents/Syncthing";
          devices = [ "laptop" ];
        };
      };
    };
  };
}
