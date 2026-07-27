# My NixOS configuration

A single flake that builds both the system and my user environment.
Home Manager runs as a NixOS module, so there is no separate `home-manager switch`.

Hosts:

| Host     | Machine       |
| -------- | ------------- |
| `frieda` | Desktop, GNOME |

## Structure

```
flake.nix         inputs, overlays and the nixosConfigurations
hosts/<host>/     per-machine: configuration.nix + hardware.nix
system/           system modules, imported by a host
home/             Home Manager modules, imported by a user
users/<user>.nix  per-user Home Manager profile
pkgs/             packages that aren't in nixpkgs
scripts/          installation helpers
```

Modules stay optional: a module under `system/` or `home/` configures one thing
and does nothing until a host or user imports it. Anything machine-specific
belongs in `hosts/`, not in a module.

## Installation

Clone the configuration:

```sh
git clone https://github.com/pkosel/nixos-config.git ~/.nixos-config
cd ~/.nixos-config
```

On a new machine, partition the disk:

```sh
scripts/setup-partitions
```

Then generate the hardware configuration for the new host:

```sh
mkdir -p hosts/<host>
nixos-generate-config --show-hardware-config > hosts/<host>/hardware.nix
```

Write `hosts/<host>/configuration.nix` next to it, importing the modules the
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
