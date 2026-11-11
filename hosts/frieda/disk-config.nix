{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-eui.5cd2e42391a132d5";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          priority = 1;
          label = "boot";
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = [
              "-F"
              "32"
              "-n"
              "boot"
            ];
            mountpoint = "/boot";
          };
        };
        nixos = {
          priority = 2;
          label = "nixos";
          end = "-4G";
          content = {
            type = "filesystem";
            format = "ext4";
            extraArgs = [
              "-L"
              "nixos"
            ];
            mountpoint = "/";
          };
        };
        swap = {
          priority = 3;
          label = "swap";
          size = "100%";
          content = {
            type = "swap";
            extraArgs = [
              "-L"
              "swap"
            ];
          };
        };
      };
    };
  };
}
