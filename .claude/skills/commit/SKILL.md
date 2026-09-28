---
name: commit
description: How to stage and commit changes in this repo. Use whenever the user asks to commit, save changes, or check in code — even without typing /add-and-commit.
---

# Committing in this repo

Mirrors `/add-and-commit` (`.claude/commands/add-and-commit.md`). Follow these rules any time
you commit here, whether invoked via the slash command or asked in plain language ("commit
this", "save these changes").

## Before committing

1. `git status` — see every modified/added/deleted file.
2. `git diff HEAD` — read the full diff.
3. `git log --oneline -5` — match the existing commit style.
4. Read `CHANGELOG.md` and update the `## [Unreleased]` section to reflect the diff:
   - Only add entries under `[Unreleased]`.
   - Use Keep a Changelog subsections (`### Added`, `### Changed`, `### Fixed`, `### Removed`,
     `### Deprecated`, `### Security`) — only the ones that apply.
   - One bullet per change, concise, factual, user-facing, in English.
   - Don't duplicate existing entries; don't mention file names or internals unless essential.

## Staging

- Stage files **individually by name** — never `git add -A` or `git add .`.
- Always include `CHANGELOG.md` once updated.
- Skip anything that looks like a secret (`.env`, credentials, keys) and flag it to the user.

## Commit message — rules that never bend

- Conventional Commits format: `<type>(<scope>): <description>` (scope optional).
- **No** `Co-Authored-By`, `Generated with`, or any AI/Claude/Anthropic reference, and no footer
  lines at all — this repo's convention overrides the global attribution default.
- Default: single-line title only, under 72 characters.
- If the user asks for a detailed/verbose message: title + blank line + bullet body explaining
  what and why, one bullet per logical change.
- Commit via heredoc to preserve formatting:
  ```bash
  git commit -m "$(cat <<'EOF'
  <message>
  EOF
  )"
  ```

## After committing

Run `git log --oneline -3` to confirm the commit landed with the right message.

## Bundling a version bump

If the user also wants a version bump in the same commit, follow [[bump-version]]'s version
computation and file edits first, fold those changes into the same staging/commit steps above,
and end the commit body (if verbose) with `- bumps version to X.Y.Z`. See
`.claude/commands/add-and-commit.md` Mode B for the exact sequencing.
