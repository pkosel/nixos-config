# AGENTS.md

NixOS flake for one host, `frieda` (x86_64-linux). Home Manager is a NixOS module, so system and user environment build and activate together. Human-facing setup and workflows are in `README.md`.

## Commands

- `nix fmt`: format Nix files (nixfmt-tree).
- `nix flake check`: evaluate all outputs; runs deadnix and statix.
- `nixos-rebuild build --flake .#frieda`: build without activating.
- `nix eval .#nixosConfigurations.frieda.config.<option>`: inspect an option.

There is no test suite. A change is correct when `frieda` builds.

## Structure

- `flake.nix`: inputs, formatter, checks, `nixosConfigurations.frieda`.
- `hosts/frieda/`: the host. Machine-specific settings go here, not in modules.
- `system/`, `home/`: modules. A module has no effect until imported, so check the import lists (`hosts/frieda/configuration.nix`, `users/philipp.nix`, and the `default.nix` files).
- `users/philipp.nix`: the Home Manager user profile. It sets `_module.args.theme` from `home/theme.nix`.
- Modules get `inputs` as an argument. Home Manager modules also get `theme`.
- Neovim open cleanup items: `home/editors/nvim/TODO.md`.

## Versions and pins

- `stateVersion` values are fixed at the original install. Do not bump them with releases.
- nixpkgs and home-manager track the same release branch and are bumped together.
- Pins and workarounds carry a comment saying why and when they can go.

## Rules

- Do not activate or install: no `nixos-rebuild switch` or `boot`, no `nixos-install`.
- Do not use `sudo`, run `scripts/setup-partitions`, update `flake.lock`, or commit unless asked.
- Flakes see only git-tracked files. Run `git add` on new files before building.
