---
name: commit
description: "Read this skill before making git commits"
---

<!--
Adapted from mitsuhiko/agent-stuff's commit skill:
https://github.com/mitsuhiko/agent-stuff/blob/8bcbea2c3b46761f8d9773a8bc7475225e51fc25/skills/commit/SKILL.md
Modified to require an Assisted-by trailer.
Upstream: Apache-2.0; local modifications: MIT. See LICENSE.
-->

Create a git commit for the current changes using a concise Conventional Commits-style subject.

## Format

`<type>(<scope>): <summary>`

- `type` REQUIRED. Use `feat` for new features, `fix` for bug fixes. Other common types: `docs`, `refactor`, `chore`, `test`, `perf`.
- `scope` OPTIONAL. Short noun in parentheses for the affected area (e.g., `api`, `parser`, `ui`).
- `summary` REQUIRED. Short, imperative, <= 72 chars, no trailing period.

## Notes

- Body is OPTIONAL. If needed, add a blank line after the subject and write short paragraphs.
- Do NOT include breaking-change markers or footers other than the required `Assisted-by` trailer.
- Do NOT add sign-offs (no `Signed-off-by`).
- Only commit; do NOT push.
- If it is unclear whether a file should be included, ask the user which files to commit.
- Treat any caller-provided arguments as additional commit guidance. Common patterns:
  - Freeform instructions should influence scope, summary, and body.
  - File paths or globs should limit which files to commit. If files are specified, only stage/commit those unless the user explicitly asks otherwise.
  - If arguments combine files and instructions, honor both.

## Attribution

Every commit created by pi must end with exactly one `Assisted-by: pi (<current model display name>)` trailer, separated from the subject or optional body by a blank line. This applies across repositories, even when pi only commits changes written by the user. Attribute only the model making the commit, not models that previously edited the changes.

Immediately before each commit, run this script with `codemode` to read the active model identity from the shell tool and resolve its configured display name from pi's model registry:

```javascript
const result = await tools.bash({
  command: "set -euo pipefail\nprintf '%s\\n' \"${PI_PROVIDER:?Missing PI_PROVIDER}\" \"${PI_MODEL:?Missing PI_MODEL}\"",
});
if (result.exit_code !== 0) {
  throw new Error("Cannot read the current pi model. Ask the user before committing.");
}
const [provider, modelId] = result.output.trim().split("\n");
const model = await models.getModelOfType("chat", provider, modelId);
const displayName = model?.name?.trim();
if (!displayName || displayName === modelId || /[\r\n]/.test(displayName)) {
  throw new Error("No usable model display name. Ask the user before committing.");
}
text(`Assisted-by: pi (${displayName})`);
```

Use the returned trailer verbatim. Do not reuse a previous lookup after switching models. If `codemode` or model metadata is unavailable, the lookup fails, or the display name is missing or only repeats the raw model ID, stop and ask the user which display name to use before running `git commit`. Do not guess a name, fall back to the raw ID, or silently omit attribution.

This is an instruction for pi-created commits, not a Git hook. Leave commits the user creates independently untouched.

## Steps

1. Infer from the prompt if the user provided specific file paths/globs and/or additional instructions.
2. Review `git status` and `git diff` to understand the current changes (limit to argument-specified files if provided).
3. (Optional) Run `git log -n 50 --pretty=format:%s` to see commonly used scopes.
4. If there are ambiguous extra files, ask the user for clarification before committing.
5. Stage only the intended files (all changes if no files specified).
6. Resolve the current model's attribution trailer as described above, asking the user if necessary.
7. Run `git commit -m "<subject>"` (and `-m "<body>"` if needed), followed by `-m "<resolved attribution trailer>"` as the final paragraph.
