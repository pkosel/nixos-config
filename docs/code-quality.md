# Code quality

## Code

### Structure

- Each file in `modules/` configures one program or feature and is named after
  it (`git.nix`, `oil.lua`, `bat/default.nix`). Programs without settings go in
  a shared list instead (`home.packages`, `plugin_setups.lua`).
- Keep all settings of a program in one file per layer (NixOS, Home Manager).
- Split files only by program or feature, never by length.
- List every import and `require` explicitly. Never load files by scanning a
  directory (`builtins.readDir`).

### Abstractions

- Solve the current need directly. Don't add wrappers or parameters for hosts,
  users, or cases that don't exist.
- Define each fact in one place, so changing it takes one edit, like the theme
  names in `theme.nix`.
- Merge duplicated code only when the copies must change together. Leave code
  that merely looks alike duplicated.
- Add a helper only when it has two or more call sites and a name that says
  what it does. Inline a single-use helper unless its name replaces a comment.

### Names and readability

- Name things in full words after what they hold or do: booleans as yes/no
  questions (`isDark`), functions as verbs (`openPicker`). Established short
  names are fine (`pkgs`, `lib`, `opts`, `ctx`).
- Use single letters only for loop indices and one-line lambdas
  (`.map((c) => c.text)`).
- Use the same name for the same concept in every file.
- Prefer clear code over short code. Split dense expressions, such as nested
  ternaries or long chains, into named steps.
- Return early for edge cases instead of nesting the main path.
- Give unexplained literal values a named constant (`maxWidth = 80`). In Nix
  settings, the option name already names the value.
- Declare variables in the smallest scope, near their first use: `local` in
  Lua, `const` in TypeScript unless reassigned.

### Functions

- Give each function one job that you can describe without "and".
- Keep each function at one level of detail: a function that calls named steps
  doesn't also do low-level work inline.
- Don't pass booleans that switch what a function does. Write two functions.
- Don't hide side effects: a function named like a query (`getWidth`,
  `isReady`) must not change state.

### Nix

- Use a program's NixOS or Home Manager options for the settings they offer.
  Write raw config files (`home.file`, `xdg.configFile`) only for the rest.
- Write settings as literal attrsets and lists. Generate them (`map`,
  `genAttrs`) only to apply one value to a list of keys, as in `mimeapps.nix`.
- Use `with` only around a list (`with pkgs; [ … ]`).
- Don't add custom options or `enable` flags; importing a module is the switch.
- Override another module's value (`lib.mkForce`) only when a plain assignment
  conflicts, and comment what it overrides.
- Set an option to its default only to pin it against upstream changes, and say
  so in a comment. Before deleting a setting that equals the default, check its
  history for such a pin.
- Don't edit generated files (`hosts/*/hardware-configuration.nix`). Override
  their settings in the host's `default.nix`.

### Maintenance

- Solve a problem the way existing code solves it. Replace a pattern in a
  separate change that updates every use.
- Never swallow errors: handle them, report them, or let them propagate. Start
  shell scripts with `set -euo pipefail`.
- Fix linter warnings instead of suppressing them. Give every suppression a
  comment with its reason.
- Delete unused code and imports. Delete a workaround once its removal
  condition is met.
- Add a package, plugin, or flake input only for a feature you use, and remove
  it with that feature.

## Comments

- Comment only what the code can't say: the reason for a choice, a constraint,
  or a hazard. If deleting a comment loses no information, delete it.
- Never restate the code, narrate the next line, or explain language syntax.
  - Bad: `# Enable Bluetooth.` above `hardware.bluetooth.enable = true;`
  - Good: `# The symbol is a space because nvim mis-measures multi-width emoji.`
- If code needs a comment to explain what it does, rename or simplify the code
  instead.
- For a workaround or version pin, state the problem, link the upstream issue
  if there is one, and say when to remove it.
- For a hazard, say what breaks. "Don't change this" alone is not enough.
- Describe the code as it is. No history: "previously", "changed to", "fixed".
- Update or delete comments in the same change as their code. Rewrite a wrong
  comment instead of appending a correction.
- No commented-out code.
- No TODO or FIXME comments. Record open work as a todo.
- Use label comments (`# Networking`) only to name a group of entries, as in a
  long package list.
- Put comments directly above the code they explain.
- Write explanations as complete sentences in a neutral tone. No "Note:",
  "IMPORTANT", or exclamation marks.

## Documentation

- Put information where its reader looks:
  - Why specific code is written the way it is: a comment above that code.
  - How to install, rebuild, or update the system: `README.md`.
  - How to work in the repository (layout, commands, safety rules):
    `AGENTS.md`.
  - Rules for code, comments, and documentation: this file.
- Don't add documentation files, sections, or paragraphs unless asked; suggest
  them in your reply. Two exceptions, both in the same change:
  - Fix documentation your change makes wrong.
  - Document a manual step your change adds (command, prerequisite, secret).
- Check every command, path, option, and flag you document against the code
  and the pinned tool versions.
- State each fact once. Elsewhere, link to it with a relative link.
- Document only what the reader must do or know: commands, prerequisites,
  hazards. Don't explain Nix, the implementation, or what the files already
  show.
- Describe the current state. No changelogs, dates, or "new"/"previously".
  Explain your change in the commit message, your reply, or the todo.
- Start with the instruction or fact. No introductions, summaries, or filler
  ("simply", "just", "note that").
- Write commands as copy-pasteable code blocks, with placeholders like
  `<host>`.
- Add a rule to `AGENTS.md` only if an agent would otherwise get it wrong and
  no check catches it.
