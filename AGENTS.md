# AGENTS.md

NixOS flake for one host, `frieda` (x86_64-linux), and user `philipp`.
Home Manager runs as a NixOS module; system and user environments build and
activate together.

## Code quality

Read this file in full before auditing or editing the repository. Follow the
intent of each rule, not workarounds that satisfy its wording. Review the
complete diff against these rules before finishing.

### Design and ownership

- Solve the current need. Do not add wrappers, compatibility layers, or
  parameters for nonexistent hosts, users, or use cases.
- Name each module after its single program or feature (`git.nix`,
  `bat/default.nix`). Keep its settings together per layer (NixOS or Home
  Manager); split by responsibility, never by length.
- Put programs without settings in existing package or plugin lists, not
  separate configuration modules.
- Define each fact once. Extract duplicate code only when the copies must
  change together; similar-looking code may stay duplicated.
- Helpers need at least two call sites. Inline a single-use helper unless its
  name replaces a comment.
- Read neighboring files and follow their patterns. Propose architectural
  changes before implementing them. Keep behavior-preserving refactors
  separate from functional changes.

### Readability

- Prefer clear code over short or clever code. Break dense expressions and
  long chains into named steps; handle edge cases before the main path.
- Use full, descriptive names; use the same name for the same concept.
  Booleans ask yes/no questions (`isDark`); functions name actions
  (`openPicker`). Established names such as `pkgs`, `lib`, `opts`, and `ctx`
  are fine. Reserve single letters for loop indices and one-line lambdas.
- Declare variables near first use in the smallest scope: `local` in Lua and
  `const` in TypeScript unless reassignment is needed.
- Give functions one job and one level of detail. Separate orchestration from
  low-level implementation; do not use boolean arguments to select unrelated
  behaviors.
- Keep side effects explicit. Queries such as `getWidth` or `isReady` must not
  change state.
- Name unexplained literal values. Nix option names usually explain their
  values already.

### Nix

- Prefer NixOS and Home Manager options over raw files or imperative scripts.
  Use `home.file` or `xdg.configFile` for settings those options do not cover.
- Use literal attrsets and lists. Generate settings only to apply one value
  to several keys, as in `mimeapps.nix`.
- List imports and Lua `require` calls explicitly; never scan directories to
  load modules. Imports are the switch: do not add custom options or `enable`
  flags around this repository's configuration.
- Use `with` only around a list (`with pkgs; [ ... ]`).
- Use `lib.mkForce` only to resolve conflicting definitions; comment what it
  overrides. Assign an option its default only to pin it against upstream
  changes, with a comment explaining the pin. Check history before removing
  such a setting.
- Verify unfamiliar options, packages, and library functions against pinned
  inputs; examples for other releases may not apply.

Olaf Freund's [Patterns] and [Anti-patterns] are optional examples, not binding
architecture. Local rules take precedence, including those on reusable modules
and feature flags.

[Patterns]: https://github.com/olafkfreund/nixos_config/blob/main/docs/PATTERNS.md
[Anti-patterns]: https://github.com/olafkfreund/nixos_config/blob/main/docs/NIXOS-ANTI-PATTERNS.md

### Maintenance

- Keep changes scoped to the request; no unrelated cleanup or dependency
  updates.
- Handle errors, report them, or let them propagate; never silently swallow
  them. Start Bash scripts with `set -euo pipefail`.
- Fix linter warnings rather than suppressing them. Explain necessary
  suppressions beside them.
- Remove unused code and imports, workarounds whose removal conditions are
  met, and dependencies with the features that need them.
- Test meaningful behavior and regressions, not tautologies or library
  behavior. Connect each new test to a runnable check.

### Comments and documentation

Describe current behavior, not implementation history. Keep change history
and per-change reports in commit messages or tasks. Update or delete stale
text with its code; rewrite errors rather than appending corrections.

#### Comments

- Default to none. Comment only non-obvious reasons, constraints, hazards, or
  relationships; never narrate code, repeat option names, or explain syntax.
  - Bad: `# Enable Bluetooth.` above `hardware.bluetooth.enable = true;`
  - Useful: `# The symbol is a space because nvim mis-measures multi-width emoji.`
- Simplify or rename confusing code instead of explaining what it does.
  Preserve non-obvious rationale even when the code is clear.
- For workarounds and pins, explain the problem, link any upstream issue, and
  state when to remove them. For hazards, say what breaks, not just "do not
  change this".
- Put comments directly above their code. Be concise without removing a
  necessary constraint to fit a line limit.
- Use complete sentences, neutral language, and plain punctuation. No
  decorative banners, "IMPORTANT", "Note:", exclamation marks, or promotional
  language. Short group labels such as `# Networking` are fine in long lists.
- No commented-out code or TODO/FIXME comments; record open work as a task.

#### Documentation

- Keep local rationale beside the code, setup and everyday operations in
  [README.md](README.md), and repository conventions here. Link to the
  authoritative location rather than copying it.
- Document prerequisites, commands, constraints, hazards, and manual steps,
  not configuration inventories or what the code already shows.
- Create documentation files or sections only when requested. In the same
  change, fix text your change makes wrong and document manual steps it adds.
- Start with the instruction or fact. Cut filler, introductions, and prose
  about the document itself.
- Check paths, options, commands, and flags against the code and pinned
  versions. Write copy-pasteable command blocks with explicit placeholders
  such as `<host>`.

## Structure

```text
.
├── flake.nix                 # Inputs, outputs, formatter, and checks
├── hosts/frieda/             # Host-specific system and hardware configuration
├── users/philipp/            # Home Manager profile and user package list
├── modules/
│   ├── system/               # System configuration
│   └── home/                 # User configuration, including Neovim Lua
├── pkgs/                     # Local package definitions
├── overlays/                 # Add or override packages in nixpkgs
└── scripts/                  # Installation helpers
```

- Follow imports from `flake.nix` through `hosts/frieda/default.nix` or
  `users/philipp/default.nix` to find a setting's owner. A module has no effect
  until imported; check the relevant `default.nix`.
- Put machine-specific settings in `hosts/frieda/`. User settings needing no
  root belong in Home Manager. Boot, hardware, system services, networking,
  firewall, and the display manager belong in NixOS. When in doubt, prefer
  Home Manager.
- Both layers receive `inputs`. Keep program themes and color settings in
  their respective program modules.

## Versions and pins

- `system.stateVersion` and `home.stateVersion` record the original install;
  do not bump them with releases.
- nixpkgs and Home Manager track the same release branch and are bumped
  together.

## Git

- When asked to commit, use [Conventional Commits]: `<type>(<scope>): <summary>`.
  Scope is optional. Types: `feat` for features, `fix` for fixes, `docs` for
  documentation, `refactor` for behavior-preserving restructuring, and `chore`
  for maintenance. Use an imperative subject of at most 72 characters, without
  a trailing period. Add a body only for a non-obvious reason or consequence.
- Review working-tree and staged diffs. Preserve unrelated user changes and
  stage only task files.
- Git-backed flakes see only tracked files. Stage new task files with
  `git add -- <path>` before evaluating or building; no commit is required.

[Conventional Commits]: https://www.conventionalcommits.org/en/v1.0.0/

## Validation

Documentation-only changes need the documentation checks above and a
whitespace check, not a system rebuild:

```sh
git diff --check
```

For code or configuration changes, run these in order; stop at the first
failure:

1. Format Nix, Lua, and TypeScript with treefmt:

   ```sh
   nix fmt
   ```

   Generated hardware configuration and `flake.lock` are excluded.

2. Check flake outputs, deadnix, and statix:

   ```sh
   nix flake check
   ```

3. If an option value changed, confirm its evaluated value:

   ```sh
   nix eval '.#nixosConfigurations.frieda.config.<option>'
   ```

4. Build without activating:

   ```sh
   nixos-rebuild build --flake .#frieda
   ```

5. Review package versions and closure changes:

   ```sh
   nvd diff /run/current-system result
   ```

   The build leaves `result` in the repository root. Configuration-only
   changes can appear as added and removed paths rather than version changes.

There is no CI or test suite. Evaluation, building, and activation are
separate; a successful build does not verify runtime behavior. Report checks
run, skipped, or blocked, their results, and anything still unverified.

## Hazards and boundaries

- Do not activate, install, or repartition: no `nixos-rebuild switch`, `boot`,
  or `test`, no `nixos-install`, and no `scripts/setup-partitions`. The user
  performs activation and installation.
- Do not use `sudo` or `--impure`.
- Do not update `flake.lock`, commit, push, or rewrite Git history unless
  explicitly asked. Do not bypass a failing check.
- Do not edit generated `hosts/*/hardware-configuration.nix`; override
  settings in the host's `default.nix`.
- Never put passwords, tokens, or private keys in source, logs, commits, or
  the Nix store. Keep credentials out of command arguments and tool output.
