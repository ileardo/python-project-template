---
name: pr
description: How to open a pull request in this repo. Use whenever the user asks to open, create, or send a PR — even without typing /pr.
---

# Opening a PR in this repo

Mirrors `/pr` (`.claude/commands/pr.md`). Follow these rules whenever you open a pull request
here, whether invoked via the slash command or asked in plain language ("open a PR", "send this
for review").

## Steps

1. `git branch --show-current` — if it's `main`, stop and tell the user (PRs must come from a
   feature branch).
2. `git push -u origin HEAD` to make sure the branch is pushed. Opening a PR pushes code and
   creates something visible to others — this is expected when the user explicitly asks for a
   PR, but don't push/open one speculatively as a side effect of an unrelated task.
3. Gather context in parallel: `git log main...HEAD --oneline` and `git diff main...HEAD --stat`.
4. Draft title and body:
   - Title: use the user's wording verbatim if given, otherwise derive a concise one (< 70 chars)
     from the commit list.
   - Body: always just
     ```
     ## Summary
     - <bullet per logical change, derived from commits and diff stat>
     ```
5. Create it:
   ```bash
   gh pr create --base main --title "<title>" --body "$(cat <<'EOF'
   ## Summary
   - ...

   EOF
   )"
   ```
6. Report the PR URL back to the user.

## Rules

- No `Co-Authored-By` lines or AI tool references in the PR body — same override as [[commit]].
- No `--draft` or other flags unless explicitly requested.
- No `Test Plan` section.
