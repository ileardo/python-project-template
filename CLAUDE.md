# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
