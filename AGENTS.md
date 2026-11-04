# AGENTS.md

NixOS flake for one host, `frieda` (x86_64-linux). Home Manager is a NixOS module, so system and user environment build and activate together. Human-facing setup and workflows are in `README.md`.

## Code quality

Before auditing or changing repository files, read
[docs/code-quality.md](docs/code-quality.md) in full and follow it. It is the
authoritative standard for code, comments, and documentation; keep its rules
there rather than repeating them here. Before finishing a change, review the
complete diff against it and remove anything that breaks it.

## Commands

Run in order, stopping at the first failure:

1. `nix fmt`: format Nix files (nixfmt-tree). If you changed Lua files, also run `nix run --inputs-from . nixpkgs#stylua -- modules/home-manager/editors/nvim/`; only Neovim's wrapper provides `stylua`, so it is not on the shell `PATH`.
2. `nix flake check`: check flake outputs and run deadnix and statix.
3. `nix eval .#nixosConfigurations.frieda.config.<option>`: confirm the option you changed evaluates as intended. Skip if you didn't change an option value.
4. `nixos-rebuild build --flake .#frieda`: build without activating; leaves `result` in the current directory.
5. `nvd diff /run/current-system result`: review package version and closure changes. A change that only alters configuration files appears as added and removed paths, not as a version change.

There is no CI or test suite; a successful build does not verify runtime behavior. Report the checks you ran, the ones you skipped and why, and what remains unverified.

## Structure

- `flake.nix`: inputs, formatter, checks, `nixosConfigurations.frieda`.
- `hosts/frieda/`: the host. Machine-specific settings go here, not in modules.
- `home/philipp/`: the Home Manager user profile and simple user packages. It sets `_module.args.theme` from `modules/home-manager/theme.nix`.
- `modules/nixos/`, `modules/home-manager/`: modules. A module has no effect until imported, so check the import lists (`hosts/frieda/default.nix`, `home/philipp/default.nix`, and the `default.nix` files).
- Per-user settings that need no root go in Home Manager; system-wide settings (boot, kernel, system services, hardware, firewall, display manager) go in NixOS. When in doubt, prefer Home Manager.
- Modules get `inputs` as an argument. Home Manager modules also get `theme`.

## Versions and pins

- `stateVersion` values are fixed at the original install. Do not bump them with releases.
- nixpkgs and home-manager track the same release branch and are bumped together.

## Rules

- Do not activate or install: no `nixos-rebuild switch` or `boot`, no `nixos-install`.
- Do not use `sudo`, run `scripts/setup-partitions`, update `flake.lock`, or commit unless asked.
- Do not use `--impure`; it lets the build read untracked files and the host environment, breaking reproducibility.
- Flakes see only git-tracked files. Run `git add` on new files before building.
- Change only what the task needs; no unrelated cleanup.
- Keep refactors behavior-preserving and separate from functional changes.
