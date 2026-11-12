# pkosel's NixOS configuration

[![Nix Flakes](https://img.shields.io/badge/Nix-Flakes-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

NixOS configurations for [frieda](hosts/frieda/) (laptop) and
[bridget](hosts/bridget/) (server). `frieda` includes Home Manager for `philipp`.

## Installation

### frieda (local)

Run these commands in a root Bash shell on a UEFI NixOS installer with Git.

Clone the published configuration and enable Nix's flake commands:

```sh
checkout_directory=/tmp/nixos-config
git clone https://github.com/pkosel/nixos-config.git "$checkout_directory"
cd -- "$checkout_directory"
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
```

Disko erases and mounts the disk selected in the host's
[disk declaration](hosts/frieda/disk-config.nix) and activates swap:

```sh
target_disk=$(nix eval --raw .#nixosConfigurations.frieda.config.disko.devices.disk.main.device)
lsblk --output PATH,TYPE,SIZE,MODEL,SERIAL,LOG-SEC,MOUNTPOINTS "$target_disk"
nix run .#disko -- --mode destroy,format,mount --flake .#frieda
findmnt --mountpoint /mnt
findmnt --mountpoint /mnt/boot
swapon --show
```

Generate hardware settings without filesystem definitions, which Disko
supplies, then install the system. The installer prompts for the root password:

```sh
nixos-generate-config --no-filesystems --root /mnt \
  --show-hardware-config > hosts/frieda/hardware-configuration.nix
nixos-install --flake .#frieda
```

Set Philipp's password and preserve the checkout at `~/.nixos-config` for
subsequent rebuilds:

```sh
installed_bin_directory=/nix/var/nix/profiles/system/sw/bin
nixos-enter --root /mnt -- "$installed_bin_directory/passwd" philipp
mkdir -p /mnt/home/philipp
cp -a -- "$checkout_directory/." /mnt/home/philipp/.nixos-config
nixos-enter --root /mnt -- "$installed_bin_directory/chown" -R philipp:users /home/philipp/.nixos-config
reboot
```

After boot, provision `/etc/davfs2/secrets` (`root:root`, `0600`) for WebDAV.

### bridget (remote)

Run from a repository checkout with tracked `secrets/bridget.yaml`.
For first setup, create an age identity for SOPS and a separate SSH host key
outside the checkout. Reuse existing keys on reinstalls:

```sh
nix shell --inputs-from . nixpkgs#age nixpkgs#sops
umask 077
age-keygen -o "<age-key-file>"
ssh-keygen -t ed25519 -N "" -f "<ssh-host-key-file>"
```

Update the server recipient in [.sops.yaml](.sops.yaml), retaining the
administrator recipient, then re-encrypt:

```sh
SOPS_AGE_KEY_FILE="<administrator-age-key-file>" sops updatekeys secrets/bridget.yaml
```

Prepare the bootstrap directory outside the checkout and install:

```sh
install -D -m 0600 "<age-key-file>" "<bootstrap-directory>/var/lib/sops-nix/key.txt"
install -D -m 0600 "<ssh-host-key-file>" "<bootstrap-directory>/etc/ssh/ssh_host_ed25519_key"
nix run .#nixos-anywhere -- --flake .#bridget \
  --target-host "root@<server-ip>" \
  --extra-files "<bootstrap-directory>"
```

## Rebuilding

Run maintenance commands from the repository checkout.

Build without activating:

```sh
nixos-rebuild build --flake ".#<host>"
```

Apply locally:

```sh
sudo nixos-rebuild switch --flake .#frieda
```

Apply remotely:

```sh
nixos-rebuild switch --flake .#bridget --target-host "root@<server-ip>"
```

## Updating

Update all flake inputs:

```sh
nix flake update
```

Or update one input:

```sh
nix flake update "<input>"
```

Repository conventions and validation: [AGENTS.md](AGENTS.md).

## AI disclaimer

I use AI coding assistants to learn and iterate, while remaining responsible
for architectural decisions, review, and verification.

## Acknowledgements

Thanks to the NixOS community, package and module maintainers, and everyone
sharing their configurations. The [NixOS Wiki](https://wiki.nixos.org/) and
[ArchWiki](https://wiki.archlinux.org/) are useful references.
