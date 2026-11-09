# pkosel's NixOS configuration

[![Nix Flakes](https://img.shields.io/badge/Nix-Flakes-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Personal NixOS configuration for my laptop, with GNOME, Fish, and Neovim.

## Hosts

| Host                    | Machine | Architecture | Desktop |
| ----------------------- | ------- | ------------ | ------- |
| [frieda](hosts/frieda/) | Laptop  | x86_64-linux | GNOME   |

## Nix stack

[NixOS](https://nixos.org/) manages the system;
[Home Manager](https://github.com/nix-community/home-manager) manages the user
environment. Both are composed in [flake.nix](flake.nix) and built and
activated together. There is no separate Home Manager activation step.

Flake inputs are public and pinned in [flake.lock](flake.lock). They provide
nixpkgs, Home Manager, coding-agent packages, and Firefox extensions; local
package definitions live in [pkgs/](pkgs/).

See [Structure](AGENTS.md#structure) for layout and configuration ownership,
and [Code quality](AGENTS.md#code-quality) for editing conventions.

## Installation

These steps install the `frieda` configuration and user `philipp`. Before
reusing it elsewhere, adapt the host and user settings, including personal
identity, mounts, and network devices. Use the
[NixOS installation manual](https://nixos.org/manual/nixos/stable/#ch-installation)
for layouts beyond the helper's UEFI/GPT setup.

Boot a NixOS live installer with network access, Git, and working `nix-shell`.
Run this section from a root shell. Stop if any command fails.

### 1. Clone

```sh
git clone https://github.com/pkosel/nixos-config.git /tmp/nixos-config
cd /tmp/nixos-config
```

### 2. Partition

**The partition helper erases the selected disk. Back up its data first.**
Use an unused, canonical whole-disk path, such as `/dev/nvme0n1`, not a
partition or `/dev/disk/by-*` alias. Verify its identity and available capacity
before confirming. Nothing may be mounted at or below `/mnt`. The checks are
not a lock: do not use the disk or change mounts from another process while
the helper runs.

```sh
scripts/setup-partitions
```

The helper creates a GPT layout with an EFI partition, ext4 root, and 4 GiB
swap, mounts the filesystems under `/mnt`, and generates hardware configuration.
Its Bash and Parted come from the installer's `<nixpkgs>`, not this flake's pin.

### 3. Review and install

Copy the generated hardware configuration into the host:

```sh
cp /mnt/etc/nixos/hardware-configuration.nix hosts/frieda/hardware-configuration.nix
```

Check that `/` and `/boot` identify the intended devices and that the file
contains no live-installer root or unrelated mounts. Review
[host settings](hosts/frieda/default.nix) and the
[user profile](users/philipp/default.nix) before installing.

Git-backed flakes ignore untracked files. Stage any new files the
configuration references; staging does not require a commit. Do not stage
unrelated files or credentials.

```sh
git add -- hosts/frieda/hardware-configuration.nix
```

Install the reviewed configuration:

```sh
nixos-install --flake .#frieda
```

The installer prompts for the root password, not the normal user's password.
Set the latter before rebooting:

```sh
nixos-enter --root /mnt -c 'passwd philipp'
```

### 4. Keep the checkout

Preserve the reviewed configuration on the installed system before rebooting:

```sh
mkdir -p /mnt/home/philipp
cp -a /tmp/nixos-config /mnt/home/philipp/.nixos-config
nixos-enter --root /mnt -c 'chown -R philipp:users /home/philipp/.nixos-config'
```

After booting the installed system, the checkout is at `~/.nixos-config`.

## Commands

Run these from the checkout on the installed system:

```sh
cd ~/.nixos-config
```

### Build and apply

Build without activating the configuration:

```sh
nixos-rebuild build --flake .#frieda
```

After a successful build, review package and closure changes:

```sh
nvd diff /run/current-system result
```

Apply the configuration when ready:

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

### Format and check

Format Nix, Lua, and TypeScript with treefmt, then run the checks:

```sh
nix fmt && nix flake check
```

Generated hardware configuration and `flake.lock` are excluded from formatting.
See [Validation](AGENTS.md#validation) for the complete validation workflow.
A successful build does not establish that runtime behavior is correct.

## AI disclaimer

I use AI coding assistants to learn and iterate, while remaining responsible
for architectural decisions, review, and verification.

## Acknowledgements

Thanks to the NixOS community, package and module maintainers, and everyone
sharing their configurations. The [NixOS Wiki](https://wiki.nixos.org/) and
[ArchWiki](https://wiki.archlinux.org/) are useful references.
