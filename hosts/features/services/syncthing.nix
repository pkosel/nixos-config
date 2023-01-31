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
    devices = {
      "OnePlus 5T" = {id = "OZGHQSB-YTYBBA5-3MHGSTP-6NDTKLQ-ZDTOFPO-WKS2NZY-26FENGZ-5EZQRQV";};
    };
    folders = {
      "KeePassXC" = {
        path = "/home/philipp/Documents/KeePassXC";
        devices = ["OnePlus 5T"];
      };
    };
  };
}
