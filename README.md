# My NixOS configuration

A single flake that builds both the system and my user environment.
Home Manager runs as a NixOS module, so there is no separate `home-manager switch`.

Hosts:

| Host     | Machine       |
| -------- | ------------- |
| `frieda` | Desktop, GNOME |

## Structure

```
flake.nix            inputs and the nixosConfigurations
hosts/<host>/        per-machine: default.nix + hardware-configuration.nix
modules/nixos/       system modules, imported by a host
modules/home-manager/ Home Manager modules, imported by a user
home/<user>/         per-user Home Manager profile
pkgs/                packages that aren't in nixpkgs
overlays/            wires those packages into nixpkgs, and patches some of its own
scripts/             installation helpers
```

Modules stay optional: a module under `modules/nixos/` or `modules/home-manager/` configures one thing
and does nothing until a host or user imports it. Anything machine-specific
belongs in `hosts/`, not in a module.

## Code quality

See [Code quality](docs/code-quality.md) for the maintainability standard and
review checklist used for existing-code audits and future changes.

## Installation

Clone the configuration:

```sh
git clone https://github.com/pkosel/nixos-config.git ~/.nixos-config
cd ~/.nixos-config
```

On a new machine, use a NixOS live installer with working `nix-shell`. Enter a
root shell and return to this checkout before running the partition helper; it
does not elevate privileges automatically.

The helper's `nix-shell` header requests Bash and Parted. The installer's `PATH`
must also provide `mkfs.fat` (dosfstools), `mkfs.ext4` (e2fsprogs), `mkswap`,
`mount` and `swapon` (util-linux), `mkdir` (coreutils), and
`nixos-generate-config` (NixOS installer tools). The helper rejects non-root
execution or a missing command before asking for a disk or erasure confirmation.
The shell header uses the installer's `<nixpkgs>` search path, not this flake's
lock file.

Before proceeding, back up needed data and verify the intended whole disk is
writable, has enough capacity for the boot partition, 4 GiB of swap and a usable
root filesystem, and has no mounted filesystems, active swap or other active
consumers.
Ensure `/mnt` and `/mnt/boot` are unused. Root and command checks do not validate
these disk/mount preconditions or the target's identity.

Partition the disk:

```sh
scripts/setup-partitions
```

Then generate the hardware configuration for the new host:

```sh
mkdir -p hosts/<host>
nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix
```

Write `hosts/<host>/default.nix` next to it, importing the modules the
machine needs, and add a `nixosConfigurations.<host>` section in `flake.nix`.

Install, where `<host>` matches `nixosConfigurations.<host>`:

```sh
sudo nixos-install --flake '.#<host>'
```

Afterwards set a password for the user:

```sh
passwd <user>
```

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
