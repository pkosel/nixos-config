# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
nixos-rebuild build --flake .#frieda        # verify a change; no sudo, doesn't touch the system
sudo nixos-rebuild switch --flake .#frieda  # activate (interactive sudo — leave this to the user)
nix fmt                                     # nixfmt via treefmt
nix flake update [<input>]                  # all inputs, or one
```

There is no test suite. `nixos-rebuild build` is the only real check, and it is worth
running after any change that could fail to evaluate. It leaves a `./result` symlink
behind — remove it.

`nix fmt` only formats `.nix` files. `.stylua.toml` exists for the nvim Lua files but
nothing runs stylua yet (planned: replace `pkgs.nixfmt-tree` with the `treefmt-nix`
input, see `todo.md`).

## Architecture

One flake, one host (`frieda`, x86_64-linux). Home Manager runs as a NixOS module, so
`nixos-rebuild` builds the system *and* the user environment — there is no standalone
`home-manager switch`.

Two import chains, both starting in `flake.nix`:

```
hosts/frieda/configuration.nix  -> system/**   (NixOS modules)
users/philipp.nix               -> home/**     (Home Manager modules)
```

`flake.nix` also holds every overlay inline in the `nixosSystem` modules list: the
`claude-code` input's overlay, `mdcat` from `pkgs/`, and an `anki` wrapper. Packages in
`pkgs/` are `callPackage`-style expressions that only exist because they aren't in
nixpkgs — prefer upstream, and delete a local expression once upstream catches up.

`specialArgs` and `extraSpecialArgs` both pass the whole `inputs` set down, to NixOS and
Home Manager modules respectively. That is how `hosts/frieda/configuration.nix` pins the
flake registry to `inputs.nixpkgs`, and how `home/firefox/firefox.nix` reaches the
`firefox-addons` packages and the Betterfox `user.js`.

Modules are plain attrsets, not parameterised NixOS modules — no `mkEnableOption`/`cfg`
pattern, no auto-import. A file under `system/` or `home/` does nothing until a host or
user file imports it, and each one configures a single concern: one program per file,
with `default.nix` in a directory importing its siblings as a unit. `users/philipp.nix`
is only imports, `home.packages` and `stateVersion` — a program with configuration of
its own belongs in a module, not there. Module headers list only the arguments the file
actually uses, rather than a uniform `{ config, pkgs, lib, ... }`. System modules touch
`users.users.philipp` directly (printing, docker and davfs2 all append `extraGroups`);
that coupling is deliberate for a single-user machine — don't abstract it away.

`system.stateVersion` and `home.stateVersion` are both `25.11`. Leave them.

## Conventions

- Simple over clever. New flake inputs, overlays and local packages each need to earn
  their place; reach for an existing nixpkgs or NixOS module option first.
- Comments explain *why*, not what. See `system/printing.nix` (why `browsed` is off) and
  the `anki` overlay in `flake.nix` (why the wrapper exists) for the intended tone.
- Commented-out config is deliberate, not dead code: the podman import in
  `configuration.nix`, GNOME's `excludePackages`, `celluloid`. Don't tidy it away.
- Commits use conventional prefixes (`feat`, `fix`, `chore`, `refactor`, `style`, `docs`)
  with an optional scope, one concern each, and a body explaining the reasoning.
- `todo.md` is gitignored scratch, prioritised top to bottom. Keep it current as items land.
- No secrets management yet (it's on the todo list). Credentials stay out of the repo —
  davfs2 reads `/etc/davfs2/secrets` on the machine.
