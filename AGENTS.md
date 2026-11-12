# AGENTS.md

NixOS flake for two x86_64-linux hosts: laptop `frieda` and VPS `bridget`.
Home Manager manages `philipp` on `frieda` as a NixOS module; system and user
configuration build and activate together. `bridget` has no Home Manager profile.

Read this file before auditing or editing. Follow the intent of the rules and
review the complete task diff before finishing.

## Ownership

- Follow imports from `flake.nix` through `hosts/<host>/default.nix` and
  `users/philipp/default.nix` to find a setting's owner; verify new modules are
  imported.
- Host directories contain composition, disk layout, and actual hardware
  configuration. Host `default.nix` owns machine identity, boot, networking,
  state version, and feature imports.
- Put NixOS services in `modules/services/`, OS integration in `modules/system/`,
  and user settings needing no root in Home Manager under `modules/home/`.
- Keep SOPS setup and declarations in `modules/secrets.nix`, encrypted data in
  `secrets/`, and private identities outside the checkout.
- Both NixOS and Home Manager receive `inputs`. Keep program themes and colors
  in their respective program modules.

## Boundaries

- The user performs activation and installation. Do not run
  `nixos-rebuild switch`, `boot`, or `test`, or `nixos-install`. Do not run
  `nixos-anywhere` against a real server or prepare physical disks.
- Do not use `sudo` or `--impure`.
- Do not update `flake.lock`, commit, push, or rewrite Git history unless asked.
  Preserve unrelated staged and unstaged changes.
- Do not edit generated `hosts/*/hardware-configuration.nix`; override settings
  in the host's `default.nix`.
- Do not read private identity files or decrypt production secrets unless
  explicitly requested. Never expose credentials in source, logs, command
  arguments, commits, or the Nix store.

## Code conventions

- Solve the current need; no speculative wrappers, compatibility layers, or
  parameters for nonexistent hosts or users. Propose architectural changes
  before implementing them. Keep behavior-preserving refactors separate from
  functional changes.
- Follow neighboring code. Prefer descriptive names, straightforward
  expressions, small functions, and explicit side effects over cleverness.
- Name modules after one program or feature and keep its settings together per
  layer. Split by responsibility, not length. Programs without settings belong
  in existing package or plugin lists.
- Extract shared code when its callers must change together. Avoid single-use
  wrappers that only forward arguments; extract functions to clarify distinct
  responsibilities.
- Keep changes scoped. Remove code and dependencies made obsolete by the task,
  but avoid unrelated cleanup or dependency updates.
- Start Bash scripts with `set -euo pipefail`. Handle errors or let them
  propagate; do not silently swallow them. Fix lint warnings rather than
  suppressing them; explain necessary suppressions beside the code.

### Nix

- Prefer NixOS and Home Manager options; use `home.file` or `xdg.configFile` for
  settings those options do not cover.
- Use literal attrsets and lists. Generate settings only to apply one value to
  several keys. Use `with` only around a list, such as `with pkgs; [ ... ]`.
- List imports and Lua `require` calls explicitly; never scan directories to
  load modules. Imports select this repository's features; do not wrap them in
  custom options or enable flags.
- Use `lib.mkForce` only to resolve conflicting definitions and explain what it
  overrides. Assign an option its default only as a documented upstream pin;
  check history before removing one.
- Verify unfamiliar options, packages, and library functions against pinned
  inputs, not examples for other releases.
- Keep nixpkgs and Home Manager on the same release branch and bump them
  together. Never bump `system.stateVersion` or `home.stateVersion` for a release.

## Comments and documentation

- Explain non-obvious rationale and constraints, not what the code does.
  Preserve useful rationale and document workaround removal conditions and
  upstream issues where applicable.
- No commented-out code, change diaries, or TODO/FIXME comments. Record open
  work in tasks; keep change history in commit messages.
- Keep the README a compact command reference with brief explanations of
  purpose and non-obvious relationships. No tutorials, provider workflows, or
  configuration inventories. Show shared procedures once.
- Fix outdated documentation in place. Add documentation files or sections only
  when requested; chat explanations do not authorize README expansion. Keep
  detailed one-time setup in tasks or requested temporary, untracked guides.
- Keep local rationale beside code and conventions here. Verify documented paths
  and flags against code and pinned inputs; use explicit placeholders and link
  upstream documentation for background.

## Validation

Stop at the first failure; fix it or report the blocker without bypassing it.
For every change, review staged and working-tree diffs and run `git diff --check`
and `git diff --cached --check`.

- **Documentation only:** verify affected commands, paths, and links. No build.
- **Scripts only:** run `nix fmt` (includes ShellCheck), `bash -n <script>` for
  Bash, and relevant safe behavioral checks. No system build unless the change
  also affects system configuration.
- **Nix, Home Manager, application configuration, or dependencies:** run the
  following in order for each affected host (`frieda` or `bridget`):

  1. Format and lint with `nix fmt`, then run `nix flake check`.
  2. If an option changed, confirm its evaluated value:

     ```sh
     nix eval '.#nixosConfigurations.<host>.config.<option>'
     ```

  3. Build without activating:

     ```sh
     nixos-rebuild build --flake '.#<host>'
     ```

  4. Compare package versions and closure changes against that host's deployed
     system. On `frieda`:

     ```sh
     nvd diff /run/current-system result
     ```

     Without a same-host baseline, inspect the closure instead:

     ```sh
     nix path-info --closure-size --human-readable ./result
     ```

Test meaningful behavior and regressions; connect new tests to a runnable check.
A successful build does not verify runtime behavior. Report checks passed,
skipped, or blocked and anything still unverified.

## Git

- Git-backed flakes ignore untracked files. Stage new task files with
  `git add -- <path>` before evaluation or building; tracked edits need no staging.
- Stage only task files. When asked to commit, use Conventional Commits:
  `<type>(<scope>): <summary>` (scope optional), with an imperative subject of at
  most 72 characters and no trailing period. Add a body only for a non-obvious
  reason or consequence.
