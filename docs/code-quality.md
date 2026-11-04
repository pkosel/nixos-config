# Code quality

Optimize for how easily someone can understand the configuration and safely
change it, not for fewer lines or more abstraction. Simplicity and local
understandability usually take precedence over maximum reuse and conciseness.
Correctness, reproducibility, and safety remain guardrails, not trade-offs.

This is the authoritative repository standard for hand-written code, comments,
and supporting documentation. When repository guidance differs on comment or
documentation quality, this standard takes precedence. Apply it alongside the
repository layout, validation commands, and safety rules in
[AGENTS.md](../AGENTS.md). Setup and operating workflows belong in
[README.md](../README.md).

## Code

- **Clear intent and discoverability.** Use names and locations that communicate
  purpose. Make it predictable where a setting belongs and how it becomes active.
- **Local understanding.** Keep dependencies, overrides, and effects apparent.
  Avoid making the reader reconstruct behavior through unnecessary layers or
  implicit wiring.
- **Cohesive responsibilities.** Keep related settings together and unrelated
  responsibilities separate. Split files when it improves understanding and
  navigation, not to meet a size limit.
- **Simple solutions to present needs.** Prefer explicit, idiomatic code to clever
  compression or speculative flexibility. A helper should name a useful concept
  or make its callers easier to understand; reducing line count is not enough.
- **Appropriate reuse.** Share genuinely shared facts and concepts. Tolerate modest
  duplication when an abstraction would obscure independent choices. Neither
  duplication nor a single caller automatically makes a design wrong.
- **Consistency with judgment.** Use similar patterns for similar problems and
  follow language conventions. Existing code is a precedent, not a reason to
  preserve a confusing pattern. Introduce a better pattern deliberately.
- **Low clutter.** Avoid stale documentation, abandoned experiments, unused code,
  obsolete workarounds, and dependencies without a concrete need.

A setting equal to an upstream default may still express deliberate policy. Do
not remove it merely because it currently matches that default; establish its
intent and the effect of removal first. Treat generated files as generated
artifacts, not opportunities for hand-written style cleanup.

### Examples in this repository

- A few ordinary program options are usually clearer as direct assignments in
  their owning module than as a generic helper that constructs option paths.
- Explicit imports in
  [cli/default.nix](../modules/home-manager/cli/default.nix) and explicit `require`
  calls in [Neovim's entry point](../modules/home-manager/editors/nvim/init.lua)
  show what becomes active. Automatic file discovery needs a concrete benefit
  that outweighs hiding that wiring and any ordering requirements.
- Shared theme choices in
  [theme.nix](../modules/home-manager/theme.nix) represent a meaningful shared
  concept. Unrelated preferences do not need a shared helper just because their
  attribute sets look alike.
- A small, related Lua setup can stay together. Moving each assignment into a
  separate file can make one idea harder to follow without adding a useful
  boundary.

## Comments

Do not add comments by default. A comment must preserve useful information that
the code cannot reasonably express. Before adding or keeping one, ask what a
maintainer would lose if it were deleted. If the code already says it, omit the
comment.

Valid reasons are a non-obvious constraint, the reason for a surprising choice,
and an invariant or hazard that a future edit could violate. A workaround or
temporary pin needs a comment that explains why it is needed and when it can be
removed. Narrating the next statement, restating a name or value, labeling an
obvious section, describing the patch, and explaining ordinary syntax are not
valid reasons.

For example, `# Enable Bluetooth.` above `hardware.bluetooth.enable = true;`
adds nothing. In [starship.nix](../modules/home-manager/cli/starship.nix), "The
symbol is a space because nvim mis-measures multi-width emoji." explains a value
that would otherwise look like a mistake.

If code needs a long explanation of what it does, try to simplify the code
first. Write precise, neutral, complete sentences. When a change makes a comment
inaccurate, update or remove it rather than appending a correction or keeping
implementation history. A necessary explanation may span several lines, and a
heading that aids navigation in a long file is not clutter by itself.

## Documentation

Do not add documentation by default. When a change makes existing documentation
inaccurate, updating it is part of that change. Add new material only when it
records a necessary workflow, interface, constraint, or hazard that is not
adequately expressed elsewhere. Propose optional documentation in the response
instead of adding it.

- Do not create documentation files, or expand documentation during unrelated
  work, without agreement.
- Give each maintained fact one authoritative home, and link to it rather than
  repeating it.
- Limit documentation to what a reader needs to use, operate, or safely change
  the configuration. Do not teach general Nix or walk through the implementation.
- Do not add changelogs to source files or turn implementation summaries into
  permanent documentation. Task-specific explanations belong in the final
  response or the relevant todo.

Expected outcomes for common changes:

- A behavior-preserving refactor normally needs no documentation change.
- A changed command, flag, or prerequisite needs its reference updated in the
  same change.
- A new workaround or temporary pin needs a comment with its reason and removal
  condition.
- An optional guide or broader explanation is proposed, not created.

## Review checklist

Use these questions for a change and its relevant context, or for an audited
area:

1. **Simplicity and intent:** Is this the simplest reasonable implementation, and
   are its purpose, dependencies, and activation clear?
2. **Structure and scope:** Is it free of unnecessary indirection, confusing
   boundaries, stale or unused material, and unrelated changes?
3. **Comments:** Does every comment supply information that the code cannot
   reasonably express?
4. **Documentation:** Is the documentation necessary, accurate, and in its
   authoritative place?

These are review prompts, not a score. Explain concrete issues and trade-offs;
there is no need to reproduce a checked-off list in every completion message.

## Auditing existing code

Audits are read-only unless fixes are requested. Review coherent areas, including
import paths and relevant surrounding configuration, rather than judging files
in isolation. Use the pinned versions when checking defaults and APIs. Check
existing todos first; do not repeat covered review or reopen completed findings
without new evidence.

Record audits in the local todo list (`.pi/todos/`), not in tracked repository
files. The audit todo records the scope, reviewed revision, relevant
working-tree changes, anything not reviewed, and the checks performed and their
limits, separately from confirmed findings. Create a follow-up todo for each
coherent problem, or link the existing todo that covers it. For each finding,
record:

- **Location:** The relevant files and settings.
- **Kind and priority:** Functional defect, maintainability problem, or optional
  preference; explain the impact that justifies the priority.
- **Principle and evidence:** What is wrong or unnecessarily difficult to
  understand, and the evidence for that conclusion.
- **Smallest useful improvement:** A focused recommendation, not an invitation
  to redesign the surrounding area.
- **Validation needed:** How to check the improvement and preserve intended
  behavior.

A functional defect needs evidence of incorrect behavior. A maintainability
problem needs a concrete, avoidable cost to understanding or safe modification.
A different style, fewer lines, or another possible abstraction is not sufficient
by itself. Mark unverified hypotheses as such.

An audit may find little or nothing to fix. Do not turn optional preferences
into mandatory work or use a new standard to justify a repository-wide rewrite.

## Making changes

Before editing, read the relevant surrounding code and trace how it becomes
active. Choose the smallest coherent change that solves the actual problem.

Keep cleanup behavior-preserving by default. Make functional changes intentional
and separate them from structural cleanup when practical. Do not expand a change
into unrelated cleanup; explain any supporting refactor the requested work needs.

Before declaring completion:

- Review the complete diff, including new files, against the checklist, and
  remove additions that do not meet this standard.
- Run the validation required by [AGENTS.md](../AGENTS.md) and relevant behavioral
  checks. A successful build alone does not establish correct runtime behavior.
- Report what changed, checks actually performed and their outcomes, skipped or
  blocked checks and why, and any behavior that remains unverified.
- Explain deliberate exceptions and their trade-offs. Raise material conflicts
  with this standard before implementing a change rather than silently waiving
  it. This does not waive the repository's safety rules.

For substantial structural changes, seek a separate read-only review when
practical. Self-review is useful, but it is not independent verification.

## Enforcement and limits

Use formatting, linting, evaluation, and build checks for rules they can judge
reliably. Required CI checks can block merges where branch protection is
configured; local hooks are conveniences and can be bypassed. These mechanisms
must be configured separately; this standard does not add them.

Readability, useful boundaries, and appropriate abstractions require reasoned
review. Do not substitute arbitrary length limits, comment quotas, or clean-code
scores for that judgment. If a rule repeatedly produces needless changes, revise
the standard explicitly instead of accumulating hidden exceptions.
