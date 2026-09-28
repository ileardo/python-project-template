---
name: release
description: How to tag and push a release in this repo. Use whenever the user asks to release, tag, or ship the current version — even without typing /release.
---

# Releasing in this repo

Mirrors `/release` (`.claude/commands/release.md`). Follow these rules whenever you cut a
release here, whether invoked via the slash command or asked in plain language ("release this",
"tag a release").

## Steps

1. Read the current version: `grep '^version = ' pyproject.toml`.
2. `git status` — if the working tree isn't clean, stop and tell the user to commit or stash first.
3. `make version` — if it fails, stop and tell the user the version files are out of sync.
4. `git tag --list "vX.Y.Z"` — if the tag already exists, stop and ask whether the version was
   actually bumped (see [[bump-version]]).
5. Create and push the tag:
   ```bash
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin vX.Y.Z
   ```
   Pushing a tag is a shared, hard-to-reverse action — confirm with the user before this step if
   the request to release wasn't explicit and specific.
6. Confirm to the user: tag created and pushed to `origin`.

## Rules

- Never bump the version here — that's a separate step ([[bump-version]]) that must already be
  committed before releasing.
- Never modify `CHANGELOG.md` or create a commit as part of a release.
