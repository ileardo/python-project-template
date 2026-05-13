Stage all changes and create a git commit. The argument is: `$ARGUMENTS`

Accepted argument forms (any order):

- _(empty)_ — commit only, update `[Unreleased]`
- `verbose` — commit only, verbose message
- `patch` / `minor` / `major` — commit + version bump in one shot
- `patch verbose` / `minor verbose` / `major verbose` — commit + bump, verbose message

## Step 1: Parse arguments

Scan `$ARGUMENTS` for these tokens:

- **bump type**: one of `patch`, `minor`, `major` (case-insensitive) — if found, set `BUMP_TYPE`
- **verbose flag**: the word `verbose` — if found, set `VERBOSE=true`

If no bump type is found → follow **Mode A** (commit only).
If a bump type is found → follow **Mode B** (commit + version bump).

---

## Mode A — Commit only (no bump type in arguments)

### Step A1: Understand the current state

Run these commands in parallel to gather context:

1. `git status` — identify all modified, added, and deleted files
2. `git diff HEAD` — read the full diff of all changes
3. `git log --oneline -5` — read recent commit messages to match the project's commit style
4. Read `CHANGELOG.md` — inspect the current `## [Unreleased]` section

### Step A2: Update CHANGELOG.md

Before staging anything, update `CHANGELOG.md` to reflect the changes in the diff.

**Rules:**
- Add entries ONLY under the `## [Unreleased]` section
- Use Keep a Changelog subsections: `### Added`, `### Changed`, `### Fixed`, `### Removed`, `### Deprecated`, `### Security` — include only those that apply
- Each entry is a single bullet: `- <concise description of what changed>`
- Do NOT duplicate entries already present in `[Unreleased]`
- Keep bullets concise (one line each), factual, user-facing in tone
- Do NOT mention file names or internal implementation details unless essential
- Write in English

### Step A3: Stage the changes

Stage files individually by name (do NOT use `git add -A` or `git add .`):

- List every file reported by `git status` that should be committed
- Always include `CHANGELOG.md` (modified in Step A2)
- Skip files that likely contain secrets (`.env`, credentials, private keys)
- Run `git add <file1> <file2> ...` with the specific paths

### Step A4: Draft the commit message

Read the diff and recent log carefully, then write a commit message following the rules below.

**CRITICAL rules — never violate these:**
- Do NOT include `Co-Authored-By`, `Generated with`, or any reference to Claude, Anthropic, or AI tools
- Do NOT include any footer lines at all
- Use the conventional commit format: `<type>(<scope>): <description>` where scope is optional

**If `VERBOSE` is false:**

- Write a **single line only** — title only, no blank line, no body, no bullets
- Keep it under 72 characters
- Example: `feat(models): add transformer encoder block`

**If `VERBOSE` is true:**

- Write a **title line** (under 72 chars), then a **blank line**, then a **bullet-point body**
- The body should explain _what_ changed and _why_, one bullet per logical change
- Example:

  ```text
  feat(models): add transformer encoder block

  - implement multi-head self-attention with configurable heads and dropout
  - add positional encoding with learned embeddings
  - register encoder in MODEL_REGISTRY under key 'transformer_encoder'
  - add type hints and Google-style docstrings to all public methods
  ```

### Step A5: Commit

Run the commit using a HEREDOC to preserve formatting:

```bash
git commit -m "$(cat <<'EOF'
<your drafted message here>
EOF
)"
```

### Step A6: Verify

Run `git log --oneline -3` and confirm the new commit appears at the top with the correct message.

---

## Mode B — Commit + version bump (bump type present)

Everything lands in **one single commit**: code changes, version files, and CHANGELOG.

### Step B1: Gather context

Run in parallel:

1. `git status` — all modified, added, and deleted files
2. `git diff HEAD` — full diff of all changes
3. `git log --oneline -5` — recent commit messages to match the project's commit style
4. Read `CHANGELOG.md` — capture any existing entries under `## [Unreleased]`
5. Read `pyproject.toml` — extract the current `version = "X.Y.Z"` value

### Step B2: Compute the new version

Parse the current version as `MAJOR.MINOR.PATCH` and apply the bump rule:

- `patch` → increment PATCH by 1, keep MAJOR and MINOR
- `minor` → increment MINOR by 1, reset PATCH to 0, keep MAJOR
- `major` → increment MAJOR by 1, reset MINOR and PATCH to 0

New version string: `NEW_VERSION = "X.Y.Z"`

### Step B3: Update CHANGELOG.md

Edit `CHANGELOG.md` in a single operation:

1. Collect all entries currently under `## [Unreleased]` (may be empty).
2. Derive new entries for this commit from the diff (same rules as Mode A Step A2).
3. Merge both sets (existing [Unreleased] entries first, then new entries), deduplicating.
4. Insert a new versioned section immediately after `## [Unreleased]`:

   ```markdown
   ## [Unreleased]

   ## [X.Y.Z] - YYYY-MM-DD

   ### Added
   - ...
   ```

5. Leave `## [Unreleased]` empty (no entries).

### Step B4: Update version files

Edit both files atomically:

- `pyproject.toml`: replace `version = "OLD"` → `version = "NEW_VERSION"` (double quotes)
- `src/{{PACKAGE_NAME}}/__init__.py`: replace `__version__ = 'OLD'` → `__version__ = 'NEW_VERSION'` (single quotes)

Use the actual package directory name found under `src/`.

### Step B5: Stage all files

Stage every file that was modified:

- All code files from `git status` (excluding secrets)
- `CHANGELOG.md`
- `pyproject.toml`
- `src/<package_name>/__init__.py`

Never use `git add -A` or `git add .`.

### Step B6: Draft the commit message

Same conventional commit format as Mode A. Same CRITICAL rules (no AI references, no footer).

**If `VERBOSE` is false:**

- Single-line title only, under 72 characters
- Example: `feat(api): add rate limiting`

**If `VERBOSE` is true:**

- Title + blank line + bullet body
- Last bullet must be: `- bumps version to X.Y.Z`
- Example:

  ```text
  feat(api): add rate limiting

  - add token-bucket middleware with configurable window and limit
  - expose RATE_LIMIT_RPM env variable for runtime configuration
  - bumps version to 1.2.0
  ```

### Step B7: Commit

```bash
git commit -m "$(cat <<'EOF'
<your drafted message here>
EOF
)"
```

### Step B8: Verify

Run both checks:

1. `make version` — must exit 0, confirming both version files are consistent
2. `git log --oneline -3` — confirm the commit appears at the top
