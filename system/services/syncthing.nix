{
  config,
  pkgs,
  lib,
  ...
}:

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
          id = "PPHN52M-7A7D7KK-BUBUJWZ-MQ7AZ7E-NHYCPZ7-WVSDGOE-DLCEOWH-FW352AS";
        };
        "phone" = {
          id = "OZGHQSB-YTYBBA5-3MHGSTP-6NDTKLQ-ZDTOFPO-WKS2NZY-26FENGZ-5EZQRQV";
        };
      };
      folders = {
        "ToDo" = {
          path = "~/Documents/ToDo";
          id = "6jizi-pzro6";
          devices = [ "phone" ];
        };
      };
    };
  };
}
