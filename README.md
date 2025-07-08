# My NixOS configuration

## Installation

Clone the configuration repository:

```sh
git clone https://github.com/pkosel/nixos-config.git ~/.nixos-config
cd ~/.nixos-config
```

On a new machine, first set up partitions and generate hardware configuration:

```sh
# Generate hardware configuration
nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware.nix
```

Create a new directory under `hosts/<hostname>/` with both `hardware.nix` and `configuration.nix`.

Reference this host configuration in the `nixosConfigurations.<hostname>` section in `flake.nix`.

To install, run:

```sh
sudo nixos-rebuild switch --flake '.#<hostname>'
```

After installation, set a password for your user:
```sh
passwd <username>
```

## Updating

Update all flake inputs:

```sh
nix flake update
```

Update a specific flake input:

```sh
nix flake lock --update-input <input>
```

## Rebuilding

Rebuild the system:

```sh
sudo nixos-rebuild switch --flake .
```

Rebuild home configuration:

```sh
home-manager switch --flake .
```