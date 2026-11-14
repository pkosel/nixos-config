# pkosel's NixOS configuration

[![Nix Flakes](https://img.shields.io/badge/Nix-Flakes-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

NixOS configurations for [frieda](hosts/frieda/) (laptop) and
[bridget](hosts/bridget/) (server). `frieda` includes Home Manager for `philipp`.

## Installation

### frieda (local)

Boot a NixOS installer in UEFI mode with network access and Git, then open a
root Bash shell. These steps reinstall `frieda`; review the host's
hardware-specific settings before using them on a different machine.

#### 1. Clone the configuration

Enable Nix's flake commands and clone the published configuration:

```sh
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
checkout_directory=/tmp/nixos-config
git clone https://git.pkosel.dev/pkosel/nixos-config.git "$checkout_directory"
cd -- "$checkout_directory"
```

#### 2. Check the target disk

Inspect the available drives and compare them with the host's
[disk declaration](hosts/frieda/disk-config.nix). Update its `device` if needed:

```sh
lsblk --output PATH,TYPE,SIZE,MODEL,SERIAL,LOG-SEC,MOUNTPOINTS
target_disk=$(nix eval --raw .#nixosConfigurations.frieda.config.disko.devices.disk.main.device)
lsblk --output PATH,TYPE,SIZE,MODEL,SERIAL,LOG-SEC,MOUNTPOINTS "$target_disk"
```

#### 3. Partition, format, and mount

The pinned Disko erases the selected disk and mounts its filesystems under
`/mnt`. It also activates the configured swap:

```sh
nix run .#disko -- --mode destroy,format,mount --flake .#frieda
findmnt -R /mnt
```

#### 4. Generate hardware settings and install

Write hardware settings directly into the checkout. Omit filesystem definitions
because Disko supplies them; this file is already tracked, so no `git add` is
needed:

```sh
nixos-generate-config --root /mnt --no-filesystems \
  --show-hardware-config > hosts/frieda/hardware-configuration.nix
```

Install the system, including Home Manager. The installer prompts for the root
password; no separate Home Manager activation is needed:

```sh
nixos-install --flake .#frieda
```

#### 5. Set the user password and preserve the checkout

Set Philipp's password, then copy the checkout to `~/.nixos-config` on the
installed system so it survives reboot:

```sh
installed_bin_directory=/nix/var/nix/profiles/system/sw/bin
nixos-enter --root /mnt -- "$installed_bin_directory/passwd" philipp
mkdir -p /mnt/home/philipp
cp -a -- "$checkout_directory/." /mnt/home/philipp/.nixos-config
nixos-enter --root /mnt -- "$installed_bin_directory/chown" -R philipp:users /home/philipp/.nixos-config
```

#### 6. Reboot

```sh
reboot
```

Remove the installation USB stick and log in as `philipp`. For subsequent
changes, use the [rebuild commands](#rebuilding) from the installed checkout.

#### Alternative: disko-install

After steps 1–2, the pinned `disko-install` can replace steps 3–4. Generate
hardware settings first, then let it prepare the disk and install NixOS:

```sh
nixos-generate-config --no-filesystems \
  --show-hardware-config > hosts/frieda/hardware-configuration.nix
nix run .#disko-install -- --flake .#frieda --disk main "$target_disk" \
  --write-efi-boot-entries
```

This tool unmounts the target on exit and skips the root-password prompt.
Remount and set the root password, then continue with steps 5–6:

```sh
nix run .#disko -- --mode mount --flake .#frieda
nixos-enter --root /mnt -- /nix/var/nix/profiles/system/sw/bin/passwd root
```

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
