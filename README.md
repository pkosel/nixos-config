# My NixOS configuration

A single flake that builds both the system and my user environment.
Home Manager runs as a NixOS module, so there is no separate `home-manager switch`.

Hosts:

| Host     | Machine       |
| -------- | ------------- |
| `frieda` | Desktop, GNOME |

## Structure

```
flake.nix             inputs and the nixosConfigurations
hosts/<host>/         per-machine: default.nix + hardware-configuration.nix
modules/nixos/        system modules, imported by a host
modules/home-manager/ Home Manager modules, imported by a user
home/<user>/          per-user Home Manager profile
pkgs/                 packages missing from or outdated in nixpkgs
overlays/             wires those packages into nixpkgs
scripts/              installation helpers
```

## Code quality

See [AGENTS.md](AGENTS.md) for code, comment, and documentation rules,
configuration ownership, and validation steps.

## Installation

Clone the configuration:

```sh
git clone https://github.com/pkosel/nixos-config.git ~/.nixos-config
cd ~/.nixos-config
```

On a new machine, use a NixOS live installer with working `nix-shell`, and run
the following steps from a root shell in this checkout.

`scripts/setup-partitions` erases the selected disk and creates a GPT layout
with an EFI system partition in the first 512 MiB, an ext4 root filesystem, and
4 GiB of swap at the end. It mounts the new filesystems at `/mnt` and
`/mnt/boot`, enables the swap, and generates
`/mnt/etc/nixos/hardware-configuration.nix`. Its `nix-shell` header provides
Bash and Parted from the installer's `<nixpkgs>`, not from this flake's lock
file.

The helper accepts only a canonical whole-disk path, such as `/dev/sda`,
`/dev/vda`, `/dev/xvda`, `/dev/nvme0n1`, or `/dev/mmcblk0`. It rejects
partitions, `/dev/disk/by-*` aliases, and mapper, RAID, loop, and other devices.
Before asking for confirmation, it exits if it is not running as root, a
required command is missing, the disk or one of its partitions is read-only,
mounted, or used as swap, the disk has stacked consumers such as LVM or
encryption, or `/mnt` is not an existing, non-symlink directory with nothing
mounted at or below it.

These checks are a snapshot in the current mount namespace, not a lock or a
guarantee of safe disk selection. Before running the helper, back up needed
data, verify that this is the intended disk and has room for a usable root
filesystem, and make sure nothing uses it, including in other mount namespaces.
Do not use the disk or mount anything at or below `/mnt` while the helper runs.

Partition the disk:

```sh
scripts/setup-partitions
```

Copy the generated hardware configuration into the host directory:

```sh
mkdir -p hosts/<host>
cp /mnt/etc/nixos/hardware-configuration.nix hosts/<host>/hardware-configuration.nix
```

Inspect the copied file before installing: `/` and `/boot` must refer to the
intended target devices, and it must not include the live installer root or
unrelated mounts. If anything is wrong, stop and investigate before continuing.

Write `hosts/<host>/default.nix` next to it, importing the modules the
machine needs, and add a `nixosConfigurations.<host>` section in `flake.nix`.

The flake sees only files that Git tracks. Before evaluating or installing,
review and stage the new host files:

```sh
git add -- hosts/<host>/default.nix hosts/<host>/hardware-configuration.nix
```

Staging is sufficient; no commit is required. Explicitly stage any other new
files the configuration references, but do not stage unrelated files or secrets.

Install, where `<host>` matches `nixosConfigurations.<host>`:

```sh
nixos-install --flake '.#<host>'
```

`nixos-install` prompts only for the root password. Before rebooting, set the
normal user's password in the installed system, replacing `<user>` with the
configured username (`philipp` for `frieda`):

```sh
nixos-enter --root /mnt -c 'passwd <user>'
```

Enter the password at the prompt; do not store passwords in the repository.

## Rebuilding

Build and activate the configuration for this machine:

```sh
sudo nixos-rebuild switch --flake .#frieda
```

Build it without touching the running system:

```sh
nixos-rebuild build --flake .#frieda
```

## Updating

Update all flake inputs:

```sh
nix flake update
```

Update a single input:

```sh
nix flake update <input>
```

## Formatting

Format every Nix file in the repo:

```sh
nix fmt
```
