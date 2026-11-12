{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        bios = {
          priority = 1;
          size = "1M";
          type = "EF02";
        };
        boot = {
          priority = 2;
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        nixos = {
          priority = 3;
          end = "-4G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        swap = {
          priority = 4;
          size = "100%";
          content.type = "swap";
        };
      };
    };
  };
}
