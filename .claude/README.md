# Claude Code configuration

This directory holds the Claude Code configuration for this repo: slash commands, permission
settings, and (when added) custom skills.

## Slash commands (`commands/`)

| Command | Arguments | What it does |
|---|---|---|
| `/add-and-commit` | _(none)_ \| `verbose` \| `patch`\|`minor`\|`major` \| `<bump> verbose` | Stages changes, updates `CHANGELOG.md`, and commits. With no bump type, it's a plain commit. With a bump type, the version bump (`pyproject.toml`, `__init__.py`, `CHANGELOG.md`) lands in the same commit. `verbose` adds a bullet-point body to the commit message. |
| `/bump-version` | `patch`\|`minor`\|`major` (asked if omitted) | Bumps the version in isolation: updates `pyproject.toml`, `src/<package>/__init__.py`, and `CHANGELOG.md`, verifies with `make version`, and creates a dedicated `chore: bump version to X.Y.Z` commit. |
| `/release` | _(none)_ | Creates and pushes the git tag `vX.Y.Z` for the current version. Does not bump the version, touch `CHANGELOG.md`, or create a commit — run this after the version bump is already committed. |
| `/pr` | `<title>` (optional) | Pushes the current branch and opens a pull request into `main`, with a summary generated from the commit log and diff. |
| `/worktree` | `<branch>` | Creates a git worktree at `.worktree/<branch>/` for parallel work — attaches to the branch if it exists, otherwise branches it off the current `HEAD`. Doesn't set up `.env` or an environment; activate your conda env manually inside the new worktree. |
| `/worktree-remove` | `<branch>` | Removes the worktree at `.worktree/<branch>/` and safely deletes the branch (`git branch -d`, never forced) if it's fully merged. |

## Typical flow

```
/add-and-commit minor      # commit + bump version in one shot
/pr                        # open the PR
# ... merge into main ...
/release                   # tag and push the release
```

For a one-off commit with no version bump, just use `/add-and-commit` (optionally `verbose`),
then bump and tag separately with `/bump-version` and `/release` when ready to ship.

## Skills (`skills/`)

Each skill mirrors one of the commands above and encodes the same rules, but triggers
automatically on plain-language requests too — so Claude follows the same conventions
(commit message format, no AI attribution, staging discipline, ...) even when asked to
"commit this" or "open a PR" instead of typing the slash command.

| Skill | Mirrors | Triggers on |
|---|---|---|
| `commit` | `/add-and-commit` | "commit this", "save these changes", committing as a side effect of another task |
| `bump-version` | `/bump-version` | "bump the version", "cut a minor/patch/major release" |
| `release` | `/release` | "release this", "tag a release" |
| `pr` | `/pr` | "open a PR", "send this for review" |
| `worktree` | `/worktree` | "create a worktree for...", "work on X in parallel" |
| `worktree-remove` | `/worktree-remove` | "remove the worktree for...", "clean up that branch" |

The slash commands remain the source of truth for the exact step-by-step; the skills reference
them rather than duplicating every step.

## Other files

- `settings.local.json` — whitelists the Bash commands (`make`, `git`, `pip`, `pytest`,
  `ruff check`, ...) that Claude Code can run without asking for confirmation.
