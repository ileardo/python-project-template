---
name: bump-version
description: How to bump the project version in this repo. Use whenever the user asks to bump/release a patch, minor, or major version — even without typing /bump-version.
---

# Bumping the version in this repo

Mirrors `/bump-version` (`.claude/commands/bump-version.md`). Follow these rules whenever you
bump the version here, whether invoked via the slash command or asked in plain language ("bump
the patch version", "cut a minor release").

## Steps

1. If the bump type (`patch`/`minor`/`major`) isn't clear from the request, ask before proceeding.
2. Read the current version: `grep '^version = ' pyproject.toml`.
3. Compute the new version:
   - `patch` → increment PATCH only.
   - `minor` → increment MINOR, reset PATCH to 0.
   - `major` → increment MAJOR, reset MINOR and PATCH to 0.
4. Read `CHANGELOG.md`'s `## [Unreleased]` section. If it's empty, warn the user but proceed.
5. Update both version files atomically:
   - `pyproject.toml`: `version = "OLD"` → `version = "X.Y.Z"` (double quotes).
   - `src/<package>/__init__.py`: `__version__ = 'OLD'` → `__version__ = 'X.Y.Z'` (single quotes).
6. Rewrite `CHANGELOG.md`: empty out `[Unreleased]`, insert `## [X.Y.Z] - YYYY-MM-DD` right after
   it with today's date, moving all `[Unreleased]` entries into that new section.
7. Run `make version` to confirm the two files are synchronized; fix and re-run if it fails.
8. Stage exactly `pyproject.toml`, `src/<package>/__init__.py`, and `CHANGELOG.md` — nothing else.
9. Commit: `chore: bump version to X.Y.Z` — no body, no footer, no `Co-Authored-By`.
10. Confirm with `git log --oneline -3` and report the new version and files touched.

## Notes

- This is a version bump in isolation. If the user wants the bump folded into a broader commit
  with other code changes, use [[commit]] instead (it covers the combined flow).
- Bumping the version does **not** create or push a git tag — that's [[release]].
