# AGENTS.md

NixOS flake for one host, `frieda` (x86_64-linux). Home Manager is a NixOS module, so system and user environment build and activate together. Human-facing setup and workflows are in `README.md`.

## Commands

Run in order, stopping at the first failure:

1. `nix fmt`: format Nix files (nixfmt-tree).
2. `nix flake check`: evaluate all outputs; runs deadnix and statix.
3. `nix eval .#nixosConfigurations.frieda.config.<option>`: confirm the option you changed evaluates as intended. Skip if you didn't change an option value.
4. `nixos-rebuild build --flake .#frieda`: build without activating; leaves `result` in the current directory.
5. `nvd diff /run/current-system result`: review what the build would actually change.

There is no test suite. A change is correct when `frieda` builds.

## Structure

- `flake.nix`: inputs, formatter, checks, `nixosConfigurations.frieda`.
- `hosts/frieda/`: the host. Machine-specific settings go here, not in modules.
- `home/philipp/`: the Home Manager user profile. It sets `_module.args.theme` from `modules/home-manager/theme.nix`.
- `modules/nixos/`, `modules/home-manager/`: modules. A module has no effect until imported, so check the import lists (`hosts/frieda/default.nix`, `home/philipp/default.nix`, and the `default.nix` files).
- Per-user settings that need no root go in `modules/home-manager/` (Home Manager); system-level settings (boot, kernel, services, hardware, firewall, display manager) go in `modules/nixos/`. When in doubt, prefer `modules/home-manager/`.
- Modules get `inputs` as an argument. Home Manager modules also get `theme`.

## Versions and pins

- `stateVersion` values are fixed at the original install. Do not bump them with releases.
- nixpkgs and home-manager track the same release branch and are bumped together.
- Pins and workarounds carry a comment saying why and when they can go.

## Formatting Lua files

Run `stylua` on Lua files in the nvim config before committing:

```
stylua modules/home-manager/editors/nvim/
```

## Rules

- Do not activate or install: no `nixos-rebuild switch` or `boot`, no `nixos-install`.
- Do not use `sudo`, run `scripts/setup-partitions`, update `flake.lock`, or commit unless asked.
- Do not use `--impure`; it lets the build read untracked files and the host environment, breaking reproducibility.
- Flakes see only git-tracked files. Run `git add` on new files before building.
