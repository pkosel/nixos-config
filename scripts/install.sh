#!/usr/bin/env bash

set -euo pipefail

if ((EUID != 0)); then
    printf '%s\n' "Run this script as root from a NixOS live installer." >&2
    exit 1
fi

if [[ ! -d /sys/firmware/efi ]]; then
    printf '%s\n' "Boot the NixOS live installer in UEFI mode." >&2
    exit 1
fi

if [[ ! -t 0 ]]; then
    printf '%s\n' "Run this script from an interactive terminal for confirmation and password entry." >&2
    exit 1
fi

# Enable flakes
export NIX_CONFIG="extra-experimental-features = nix-command flakes"

# Clone
readonly checkout_directory=/tmp/nixos-config
git clone https://github.com/pkosel/nixos-config.git "$checkout_directory"
cd -- "$checkout_directory"

# Inspect the configured target disk
target_disk=$(nix eval --raw .#nixosConfigurations.frieda.config.disko.devices.disk.main.device)
lsblk --output PATH,TYPE,SIZE,MODEL,SERIAL,LOG-SEC,MOUNTPOINTS "$target_disk"

# Partition, format, mount
nix run .#disko -- --mode destroy,format,mount --flake .#frieda
findmnt -R /mnt

# Generate hardware configuration directly in the flake; Disko supplies filesystems
nixos-generate-config --root /mnt --no-filesystems \
    --show-hardware-config >hosts/frieda/hardware-configuration.nix

# Install NixOS and set the root password
nixos-install --flake .#frieda

# Set the user password
readonly installed_bin_directory=/nix/var/nix/profiles/system/sw/bin
nixos-enter --root /mnt -- "$installed_bin_directory/passwd" philipp

# Preserve the checkout on the installed system
mkdir -p /mnt/home/philipp
cp -a -- "$checkout_directory/." /mnt/home/philipp/.nixos-config
nixos-enter --root /mnt -- "$installed_bin_directory/chown" -R philipp:users /home/philipp/.nixos-config

printf '%s\n' "Installation complete. Reboot manually when ready."
