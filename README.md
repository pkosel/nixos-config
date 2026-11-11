# pkosel's NixOS configuration

[![Nix Flakes](https://img.shields.io/badge/Nix-Flakes-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Personal NixOS flake for [frieda](hosts/frieda/), my x86_64-linux laptop,
with GNOME, Fish, and Neovim.
[Home Manager](https://github.com/nix-community/home-manager) manages user
`philipp` as a NixOS module; system and user configurations build and activate
together.

## Installation

The installation target is fixed in [the disk declaration](hosts/frieda/disk-config.nix).
Before replacing the SSD or installing on another machine, update its by-id
path and review the [host settings](hosts/frieda/default.nix) and
[user profile](users/philipp/default.nix), including hardware, personal
identity, mounts, and network devices.

Boot a NixOS live installer in UEFI mode with network access and Git.
Run these steps from an interactive root shell. Stop if any command fails.

### 1. Clone

Clone the published configuration into an unused `/tmp/nixos-config`
directory. Local uncommitted changes are not included.

```sh
git clone https://github.com/pkosel/nixos-config.git /tmp/nixos-config
cd /tmp/nixos-config
export NIX_CONFIG="${NIX_CONFIG:-}
extra-experimental-features = nix-command flakes"
git rev-parse --short HEAD
```

### 2. Partition

**Disk preparation erases all data on the configured disk. Back up its data first.**
Identify the target by model, serial number, and capacity:

```sh
lsblk --nodeps --output PATH,SIZE,MODEL,SERIAL,LOG-SEC
ls -l /dev/disk/by-id/
```

Verify that the configured by-id path identifies the intended whole disk,
not a partition or the live installer disk. Inspect the configured disk and
its partitions:

```sh
target=$(nix eval --raw .#nixosConfigurations.frieda.config.disko.devices.disk.main.device)
lsblk --output PATH,TYPE,SIZE,MODEL,SERIAL,LOG-SEC,MOUNTPOINTS "$target"
```

Ensure the target is unused and nothing is mounted at or below `/mnt`.
Run the flake-pinned disko and review its destructive-operation confirmation:

```sh
nix run .#disko -- --mode destroy,format,mount --flake .#frieda
```

Disko creates GPT partitions for a 512 MiB FAT32 EFI filesystem, ext4 root
using the remaining space, and 4 GiB swap. It mounts the filesystems under
`/mnt`. Activate swap separately:

```sh
swapon /dev/disk/by-partlabel/swap
```

For other layouts, follow the
[NixOS installation manual](https://nixos.org/manual/nixos/stable/#ch-installation).

### 3. Review and install

Verify that `/mnt`, `/mnt/boot`, and swap use the configured disk:

```sh
findmnt --mountpoint /mnt
findmnt --mountpoint /mnt/boot
swapon --show
```

Generate hardware configuration without filesystem or swap definitions;
disko supplies them. Copy the generated file into the host:

```sh
nixos-generate-config --no-filesystems --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hosts/frieda/hardware-configuration.nix
```

Git-backed flakes ignore untracked files. Stage the hardware configuration
and any new files referenced by the flake, then install. Never stage
credentials or unrelated changes.

```sh
git add -- hosts/frieda/hardware-configuration.nix
nixos-install --flake .#frieda --no-root-password
```

### 4. Finish and reboot

Set passwords for root and `philipp` using the installed system's tools:

```sh
installed_bin_directory=/nix/var/nix/profiles/system/sw/bin
nixos-enter --root /mnt -- "$installed_bin_directory/passwd" root
nixos-enter --root /mnt -- "$installed_bin_directory/passwd" philipp
```

Preserve the reviewed checkout:

```sh
mkdir -p /mnt/home/philipp
cp -a -- /tmp/nixos-config/. /mnt/home/philipp/.nixos-config
nixos-enter --root /mnt -- "$installed_bin_directory/chown" -R philipp:users /home/philipp/.nixos-config
```

For WebDAV, provision `/etc/davfs2/secrets` on the installed system
(`/mnt/etc/davfs2/secrets` from the installer), owned by `root:root` with mode
`0600`. See `man mount.davfs` for the credential format. Keep credentials
outside Git and the Nix store.

Reboot into the installed system. The checkout is at `~/.nixos-config`.

## Maintenance

Run these commands from the checkout on the installed system:

```sh
cd ~/.nixos-config
```

### Build and apply

Build without activation, then inspect package and closure changes:

```sh
nixos-rebuild build --flake .#frieda &&
  nvd diff /run/current-system result
```

Apply after reviewing the result:

```sh
sudo nixos-rebuild switch --flake .#frieda
```

### Update inputs

Update all flake inputs:

```sh
nix flake update
```

Or update one input, replacing `<input>` with its name from `flake.nix`:

```sh
nix flake update <input>
```

Review the lock-file diff, then build and inspect the result before applying.
Changing release branches also requires keeping nixpkgs and Home Manager
aligned; see [Versions and pins](AGENTS.md#versions-and-pins).

See [AGENTS.md](AGENTS.md) for repository layout, editing conventions, and
the [validation workflow](AGENTS.md#validation).

## AI disclaimer

I use AI coding assistants to learn and iterate, while remaining responsible
for architectural decisions, review, and verification.

## Acknowledgements

Thanks to the NixOS community, package and module maintainers, and everyone
sharing their configurations. The [NixOS Wiki](https://wiki.nixos.org/) and
[ArchWiki](https://wiki.archlinux.org/) are useful references.
