Remove a git worktree created by `/worktree` and clean up its branch. The argument is: `$ARGUMENTS`

Do not enter plan mode. Execute directly.

## Step 1: Determine the branch name

`$ARGUMENTS` is the branch name whose worktree should be removed. If it's empty, ask the user.

## Step 2: Verify the worktree exists

Run `git worktree list` and confirm `.worktree/<branch>` is listed. If it isn't, stop and tell
the user there's nothing to remove.

## Step 3: Remove the worktree

```bash
git worktree remove .worktree/<branch>
```

If this fails (e.g. uncommitted changes inside the worktree), stop and show the user the error —
do **not** retry with `--force`.

## Step 4: Clean up the branch

Attempt a safe delete:

```bash
git branch -d <branch>
```

- If it succeeds, the branch was merged and is gone.
- If it fails because the branch isn't fully merged, stop and tell the user — ask whether they
  want to force-delete it (`git branch -D <branch>`) before doing so. Never force-delete on your
  own initiative.

## Step 5: Confirm

Report to the user: worktree removed, and whether the branch was deleted or left in place (with
the reason if left in place).
