Create a git worktree for parallel work. The argument is: `$ARGUMENTS`

Do not enter plan mode. Execute directly.

## Step 1: Determine the branch name

`$ARGUMENTS` is the branch name. If it's empty, ask the user for one before proceeding.

## Step 2: Check the target path is free

The worktree goes at `.worktree/<branch>/` (relative to the repo root). If that path already
exists, stop and tell the user — do not overwrite it.

## Step 3: Create the worktree

Check whether the branch already exists locally:

```bash
git branch --list <branch>
```

- **If the branch exists**, attach the worktree to it:
  ```bash
  git worktree add .worktree/<branch> <branch>
  ```
- **If the branch doesn't exist**, create it from the current `HEAD` (i.e. branching off wherever
  the main working directory currently is):
  ```bash
  git worktree add .worktree/<branch> -b <branch>
  ```

## Step 4: Confirm

Report to the user:
- Worktree path: `.worktree/<branch>/`
- Branch: `<branch>` (new or existing)
- Remind them to `cd .worktree/<branch>` and activate their conda environment there manually —
  this command does not set up `.env` or any environment, each worktree needs its own.

## Rules

- Never delete or modify anything outside `.worktree/<branch>/`.
- Never force an operation (no `git worktree add --force`) — if git refuses, surface the error.
