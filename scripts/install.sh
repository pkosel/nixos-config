#!/usr/bin/env bash

set -euo pipefail

log_step() {
  printf '\n%s\n' "$*"
}

report_error() {
  local exit_status="$1"
  local line_number="$2"

  printf '\nInstallation failed at line %s (exit %s).\n' "$line_number" "$exit_status" >&2
  exit "$exit_status"
}

trap 'report_error "$?" "$LINENO"' ERR

if (( EUID != 0 )); then
  printf '%s\n' "Run this installer as root from a NixOS live installer." >&2
  exit 1
fi

if [[ ! -d /sys/firmware/efi ]]; then
  printf '%s\n' "Boot the NixOS live installer in UEFI mode." >&2
  exit 1
fi

if [[ ! -t 0 ]]; then
  printf '%s\n' "Run this installer from an interactive terminal for confirmation and password entry." >&2
  exit 1
fi

readonly repository_url=https://github.com/pkosel/nixos-config.git
readonly checkout_directory=/tmp/nixos-config

log_step "Cloning $repository_url into $checkout_directory."

git clone "$repository_url" "$checkout_directory"
cd -- "$checkout_directory"

export NIX_CONFIG="${NIX_CONFIG:-}
extra-experimental-features = nix-command flakes"

configuration_revision=$(git rev-parse --short HEAD)
log_step "Using frieda configuration revision $configuration_revision."

target_disk=$(nix eval --raw .#nixosConfigurations.frieda.config.disko.devices.disk.main.device)
log_step "Inspecting the configured installation disk: $target_disk."

lsblk --output PATH,TYPE,SIZE,MODEL,SERIAL,LOG-SEC,MOUNTPOINTS "$target_disk"

log_step "Preparing the disk. Disko will ask for confirmation before erasing $target_disk."

nix run .#disko -- --mode destroy,format,mount --flake .#frieda

log_step "Activating swap and checking the mounted filesystems."

swapon /dev/disk/by-partlabel/swap

findmnt --mountpoint /mnt
findmnt --mountpoint /mnt/boot
swapon --show

log_step "Generating and staging frieda's hardware configuration."

nixos-generate-config --no-filesystems --root /mnt

cp /mnt/etc/nixos/hardware-configuration.nix hosts/frieda/hardware-configuration.nix
git add -- hosts/frieda/hardware-configuration.nix

log_step "Installing NixOS."

nixos-install --flake .#frieda --no-root-password

readonly installed_bin_directory=/nix/var/nix/profiles/system/sw/bin

log_step "Setting the root password."

nixos-enter --root /mnt -- "$installed_bin_directory/passwd" root

log_step "Setting philipp's password."

nixos-enter --root /mnt -- "$installed_bin_directory/passwd" philipp

log_step "Preserving the checkout in /home/philipp/.nixos-config."

mkdir -p /mnt/home/philipp
cp -a -- "$checkout_directory/." /mnt/home/philipp/.nixos-config

nixos-enter --root /mnt -- "$installed_bin_directory/chown" -R philipp:users /home/philipp/.nixos-config

log_step "Installation complete."

printf '%s\n' \
  "The installed checkout is /home/philipp/.nixos-config." \
  "The filesystems remain mounted under /mnt. Reboot manually when ready."
