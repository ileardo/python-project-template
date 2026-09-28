---
name: worktree
description: How to create a git worktree in this repo for parallel work. Use whenever the user asks to create a worktree, work on a branch in parallel, or start a separate/isolated session on another branch — even without typing /worktree.
---

# Creating a worktree in this repo

Mirrors `/worktree` (`.claude/commands/worktree.md`). Follow these rules whenever you create a
worktree here, whether invoked via the slash command or asked in plain language ("set up a
worktree for feature X", "let's work on this in parallel").

## Steps

1. Get the branch name from the request; ask if it isn't clear.
2. Worktree path is always `.worktree/<branch>/`. If that path already exists, stop and tell
   the user — don't overwrite it.
3. Check if the branch already exists (`git branch --list <branch>`):
   - Exists → `git worktree add .worktree/<branch> <branch>`.
   - Doesn't exist → create it from the current `HEAD`: `git worktree add .worktree/<branch> -b <branch>`.
4. Report the path and branch, and remind the user to `cd .worktree/<branch>` and activate their
   conda environment there themselves — this doesn't set up `.env` or any environment per
   worktree, that's on the user.

## Rules

- Never touch anything outside `.worktree/<branch>/`.
- Never force the operation (no `--force`) — surface git's error instead.
- `.worktree/` is gitignored; don't try to track it.
- When the worktree is no longer needed, use [[worktree-remove]] rather than deleting the
  directory by hand.
