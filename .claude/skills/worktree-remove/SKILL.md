---
name: worktree-remove
description: How to remove a git worktree and clean up its branch in this repo. Use whenever the user asks to remove/delete a worktree, clean up a finished branch, or tear down a parallel work session — even without typing /worktree-remove.
---

# Removing a worktree in this repo

Mirrors `/worktree-remove` (`.claude/commands/worktree-remove.md`). Follow these rules whenever
you tear down a worktree here, whether invoked via the slash command or asked in plain language
("remove the worktree for X", "clean up that branch").

## Steps

1. Get the branch name from the request; ask if it isn't clear.
2. Confirm `.worktree/<branch>` is actually listed in `git worktree list`; if not, tell the user
   there's nothing to remove.
3. `git worktree remove .worktree/<branch>`. If it fails (e.g. uncommitted changes inside), stop
   and show the error — never retry with `--force`.
4. Try a safe branch delete: `git branch -d <branch>`.
   - Succeeds → branch was merged, done.
   - Fails (not fully merged) → stop, tell the user, and ask before force-deleting with
     `git branch -D <branch>`. Never force-delete on your own initiative.
5. Report what happened: worktree removed, branch deleted or left in place (and why).

## Rules

- Never force either the worktree removal or the branch deletion without the user's explicit
  go-ahead — both can discard uncommitted or unmerged work.
