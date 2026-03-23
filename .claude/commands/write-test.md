Write tests for the module `$ARGUMENTS` following the established conventions of this project.

## Step 1: Explore the module

Before writing any code, read the following files to understand what needs to be tested:

1. Read `src/{{PACKAGE_NAME}}/$ARGUMENTS/__init__.py` to identify the public API (exported classes,
   functions, constants).
   - Note: if `$ARGUMENTS` is in dot notation (e.g. `{{PACKAGE_NAME}}.model`), convert it to path
     notation (`src/{{PACKAGE_NAME}}/model`)
2. Read each source file referenced in `__init__.py` to understand function signatures, parameters,
   and expected behavior
3. Read existing files inside `tests/` as style references (pick the two most relevant ones)

## Step 2: Create the test directory structure

Create the following files:

```
tests/<module>/
├── __init__.py          (package marker with docstring only)
└── test_<submodule>.py  (one file per logical group of functionality)
```

Where `<module>` is the last segment of the module path (e.g. `mypackage.model` → `tests/model/`).

- `__init__.py` content: a single docstring `"""Tests for {{PACKAGE_NAME}}.<module> package."""`
- Create one test file per logical group (e.g. `test_architecture.py`, `test_loss.py`)
- If the module has few exports, a single `test_<module>.py` file is acceptable

## Step 3: Write the tests

### Mandatory coding standards (enforced — do not deviate)

- **Language**: ALL code, comments, docstrings, variable names in English
- **Type hints**: mandatory on every function and fixture parameter
- **Return type**: all test functions must be annotated `-> None`
- **Quotes**: single quotes `'...'` for all strings
- **Naming**: `test_<what_is_being_tested>` for test functions, `snake_case` for variables
- **Imports**: absolute only (e.g. `from {{PACKAGE_NAME}}.model.arch import MyClass`), never relative
- **Import order**: stdlib → third-party → project modules, sorted alphabetically within each group
- **Docstrings**: Google style, mandatory on every test function and fixture

### Docstring template

```python
def test_something(fixture_param: Path) -> None:
    """
    Test that <subject> <does what>.

    Args:
        fixture_param: Description of the fixture.
    """
```

### Test philosophy — essential tests only

- 3–9 tests per file: focus on happy paths and the most important behaviors
- Test public API only — do not test private methods or internal implementation details
- Each test must be short (5–15 lines of test code), focused on a single behavior
- Target execution time: the full new test suite must run in under 10 seconds
- Do NOT test: exhaustive parameter combinations, library internals, visualization, performance benchmarks

### Test categories to consider (apply only those relevant to this module)

1. **Initialization**: instantiate main classes with valid arguments → verify type and key attributes
2. **Factory functions / loaders**: call factory functions → verify return types
3. **Core operations**: call the main operation of each class/function → verify output type, shape, or value range
4. **I/O error handling**: if the module reads files, test `FileNotFoundError` with a missing path using `pytest.raises`
5. **Constants / mappings**: verify bidirectional consistency for any mappings or enumerations

### Fixtures

- Add new shared fixtures to `tests/conftest.py` if they will be reused across multiple test files
- Define local fixtures inside the test file if used only there
- Follow the fixture pattern from `tests/conftest.py`:

```python
@pytest.fixture
def fixture_name(parent_fixture: Path) -> ReturnType:
    """
    Brief description.

    Args:
        parent_fixture: Description.

    Returns:
        Description of what is returned.
    """
    return value
```

## Step 4: Update the Makefile

Add a new focused make target so the module's tests can be run in isolation:

1. Add `test-<module>` to the `.PHONY` line
2. Add a help line in the Testing section:
   ```
   @echo -e "  $(GREEN)make test-<module>$(NC)    - Run <module> tests only"
   ```
3. Add the target:
   ```makefile
   test-<module>:
       pytest tests/<module>/ -v
   ```

## Step 5: Run and verify

After writing all files:

1. Run `make test-<module>` and fix any failures before finishing
2. Run `make test` to verify existing tests still pass
3. Report the final test count and execution time
