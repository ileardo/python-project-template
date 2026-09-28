# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```txt
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

**Final verification is the user's call, not yours.** Once the work itself is done, don't run the closing test/lint/run pass yourself — environment mismatches (wrong Python/conda env, missing permissions) make Claude-run verification unreliable and waste time chasing false failures. Instead, end with the exact commands the user should run (tests, lint, running the app, etc.) and stop there. This doesn't apply to the quick checks you run on yourself while actively writing code — only to the concluding pass that closes out a task or plan.

## 5. Git Stays Manual

**Never run git add/commit/push/tag on your own initiative.**

- Don't add git steps to a plan, and don't perform them as the "wrap-up" of a finished task.
- Only touch git when the user explicitly asks in that message, or via the dedicated commands in `.claude/commands/` (`/add-and-commit`, `/pr`, `/release`).
- Read-only git commands (`git status`, `git diff`, `git log`) are always fine — this rule is about commands that change repo or remote state.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## Project Overview

`{{PROJECT_NAME}}` — {{DESCRIPTION}}

### Stack

- **Language**: Python >={{PYTHON_MIN_VERSION}}
- **Build**: hatchling via `pyproject.toml`
- _(add your stack entries here: LLM framework, database, web framework, ML library, etc.)_

### Module Map

| Module | Responsibility |
|---|---|
| `{{PACKAGE_NAME}}.<module>` | _(describe what this module does)_ |

_(Replace the table above with the actual module map once the project structure is defined.)_

---

## Code Style Conventions

### MANDATORY CODING STANDARDS

**CRITICAL**: All code written in this repository MUST follow these standards:

#### Language and Documentation

- **Language**: ALL code, comments, docstrings, and variable names MUST be in English
- **Type Hints**: Mandatory for all functions, methods, and class attributes
- **Docstrings**: Every class, method, and function MUST have detailed docstrings in Google/NumPy style
- **Quotes**: Use single quotes `'...'` for strings (enforced by Ruff), not double quotes `"..."`

#### Naming Conventions

- **Functions/Variables**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE`

#### Inline Comments

- **Language**: English only
- **Style**: Lowercase first letter (e.g., `# this is a comment`, not `# This is a comment`)
- **Usage**: Use sparingly, only for complex logic that isn't self-explanatory

#### Documentation Format Template

```python
def example_function(param1: int, param2: str, optional_param: float = 1.0) -> Tuple[np.ndarray, Dict[str, Any]]:
    """
    Brief description of the function.

    Args:
        param1: Description of param1.
        param2: Description of param2.
        optional_param: Description of optional parameter. Defaults to 1.0.

    Returns:
        Tuple containing:
            - np.ndarray: Description of array returned.
            - Dict[str, Any]: Description of dictionary returned.

    Raises:
        ValueError: When invalid parameters are provided.

    Example:
        >>> result_array, result_dict = example_function(42, 'test')
        >>> print(result_array.shape)
    """
    # complex calculation follows
    intermediate_result = param1 * optional_param

    return create_array(intermediate_result), {'param': param2}
```

---

## Version Management

This project follows [Semantic Versioning](https://semver.org/): **MAJOR.MINOR.PATCH**

**CRITICAL**: Versions in `pyproject.toml` and `src/{{PACKAGE_NAME}}/__init__.py` MUST always be identical.

### Increment Rules

- **PATCH**: Bug fixes, refactoring, docs, performance — update `CHANGELOG.md` only
- **MINOR**: New features, API additions, new modules — update `CHANGELOG.md` + relevant `CLAUDE.md` sections
- **MAJOR**: Breaking changes — **CONFIRM WITH USER** first, update `CHANGELOG.md` + comprehensive `CLAUDE.md`

### Version Bump Workflow

When asked to bump the version, update atomically:

1. `pyproject.toml`: `version = "X.Y.Z"` (double quotes)
2. `src/{{PACKAGE_NAME}}/__init__.py`: `__version__ = 'X.Y.Z'` (single quotes)
3. `CHANGELOG.md`: move `[Unreleased]` entries to `[X.Y.Z] - YYYY-MM-DD`
4. `CLAUDE.md`: update relevant sections (MINOR/MAJOR only)

Then suggest:

```bash
git add -A && git commit -m "release: version X.Y.Z"
git tag -a vX.Y.Z -m "Release version X.Y.Z"
git push origin main vX.Y.Z
```

Run `make version` to verify consistency between the two files.

---

## Environment

**Virtual environment**: {{ENV_SETUP_NOTE}}. Commands that need it (tests, running scripts, `pip`)
may fail or use the wrong interpreter if run without activating it first — when in doubt, hand the
command to the user instead of running it (see Goal-Driven Execution → final verification).

All secrets and connection strings are stored in `.env` (gitignored). Copy `.env.example` to `.env`
and fill in the values before running any command. Run `make setup` to do this automatically.

Use `python-dotenv` to load the environment — never hardcode credentials.

---

## Common Commands

```bash
make install    # install package in editable mode with dev dependencies
make setup      # generate .env from .env.example (run once)
make test       # run pytest with coverage
make version    # verify version consistency across pyproject.toml and __init__.py
```
