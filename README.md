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

Before installing on another machine, adapt the
[host settings](hosts/frieda/default.nix) and
[user profile](users/philipp/default.nix), including hardware, personal
identity, mounts, and network devices.

Boot a NixOS live installer in UEFI mode with network access, Git, and working
`nix-shell`. Run these steps from a root shell. Stop if any command fails.

### 1. Clone

```sh
git clone https://github.com/pkosel/nixos-config.git /tmp/nixos-config
cd /tmp/nixos-config
```

### 2. Partition

**The partition helper erases the selected disk. Back up its data first.**
Use an unused, canonical whole-disk path such as `/dev/nvme0n1`, not a
partition or `/dev/disk/by-*` alias. Verify its identity and capacity, and
ensure nothing is mounted at or below `/mnt`. Do not use the disk or change
mounts from another process while the helper runs.

```sh
scripts/setup-partitions
```

The helper creates a GPT layout with an EFI partition, ext4 root, and 4 GiB
swap, mounts the filesystems under `/mnt`, and generates hardware configuration.
For other layouts, follow the
[NixOS installation manual](https://nixos.org/manual/nixos/stable/#ch-installation).

### 3. Review and install

Copy the generated hardware configuration into the host:

```sh
cp /mnt/etc/nixos/hardware-configuration.nix hosts/frieda/hardware-configuration.nix
```

Verify that `/` and `/boot` identify the intended devices and that no
live-installer root or unrelated mounts are included.

Git-backed flakes ignore untracked files. Stage the hardware configuration
and any new files referenced by the flake, then install. Never stage
credentials or unrelated changes.

```sh
git add -- hosts/frieda/hardware-configuration.nix
nixos-install --flake .#frieda
```

### 4. Finish and reboot

The installer prompts for the root password. Set `philipp`'s password separately:

```sh
nixos-enter --root /mnt -c 'passwd philipp'
```

For WebDAV, provision `/etc/davfs2/secrets` on the installed system
(`/mnt/etc/davfs2/secrets` from the installer), owned by `root:root` with mode
`0600`. See `man mount.davfs` for the credential format. Keep credentials
outside Git and the Nix store.

Preserve the reviewed checkout:

```sh
mkdir -p /mnt/home/philipp
cp -a /tmp/nixos-config /mnt/home/philipp/.nixos-config
nixos-enter --root /mnt -c 'chown -R philipp:users /home/philipp/.nixos-config'
```

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
