# Code quality

Optimize for how easily someone can understand the configuration and safely
change it, not for fewer lines or more abstraction. Simplicity and local
understandability usually take precedence over maximum reuse and conciseness.
Correctness, reproducibility, and safety remain guardrails, not trade-offs.

This is the authoritative repository standard for hand-written code and
supporting documentation, including comments. When repository guidance differs
on comment or documentation quality, this standard takes precedence. Apply it
alongside the repository layout, validation commands, and safety rules in
[AGENTS.md](../AGENTS.md). Setup and operating workflows belong in
[README.md](../README.md).

## Principles

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
- **Useful documentation.** Provide useful, accurate context that the code alone
  does not communicate clearly: non-obvious constraints, surprising decisions,
  and workarounds. Avoid narrating obvious code. For temporary pins and
  workarounds, explain why they are needed and when they can be removed.
- **Low clutter.** Avoid stale documentation, abandoned experiments, unused code,
  obsolete workarounds, and dependencies without a concrete need.

A setting equal to an upstream default may still express deliberate policy. Do
not remove it merely because it currently matches that default; establish its
intent and the effect of removal first. Treat generated files as generated
artifacts, not opportunities for hand-written style cleanup.

## Examples in this repository

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

## Review checklist

Use this checklist for an audited area or a change and its relevant context:

1. **Intent:** Are the purpose and names clear?
2. **Navigation:** Is the code in the expected place, and is its activation clear?
3. **Local understanding:** Are dependencies, overrides, and effects apparent
   without excessive jumping between files?
4. **Simplicity:** Is there a simpler, equally clear solution? Does each
   abstraction earn its complexity?
5. **Boundaries:** Are related settings together and unrelated responsibilities
   separate?
6. **Documentation:** Does it provide useful, accurate context rather than
   narrating obvious code? Are non-obvious constraints and decisions explained?
7. **Hygiene:** Is the relevant area free of stale documentation, unused code,
   and obsolete workarounds?
8. **Safe change:** Are behavior changes intentional, unrelated cleanup excluded,
   and validation appropriate to the affected behavior?

These are review prompts, not a score. Explain concrete issues and trade-offs;
there is no need to reproduce a checked-off list in every completion message.

## Auditing existing code

Audits are read-only unless fixes are requested. Review coherent areas, including
import paths and relevant surrounding configuration, rather than judging files
in isolation. Use the pinned versions when checking defaults and APIs.

Record the scope, reviewed revision, relevant working-tree changes, and anything
not reviewed. Reports belong in `docs/reviews/`. For each finding, record:

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
by itself. Mark unverified hypotheses as such. Summarize checks performed and
validation limits separately from confirmed findings.

Prioritize useful fixes after the audit. Do not turn optional preferences into
mandatory work or use a new standard to justify a repository-wide rewrite.

## Making changes

Before editing, read the relevant surrounding code and trace how it becomes
active. Choose the smallest coherent change that solves the actual problem.

Keep cleanup behavior-preserving by default. Make functional changes intentional
and separate them from structural cleanup when practical. Do not expand a change
into unrelated cleanup; explain any supporting refactor the requested work needs.

Before declaring completion:

- Review the complete diff, including new files, against the checklist.
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
review. Do not substitute arbitrary file-length limits, comment quotas, or
clean-code scores for that judgment. If a rule repeatedly produces needless
changes, revise the standard explicitly instead of accumulating hidden
exceptions.
