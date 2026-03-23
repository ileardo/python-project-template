# Release Command

1. Ask the user whether this is a `major`, `minor`, or `patch` bump
2. Bump the version atomically in `pyproject.toml` and `src/{{PACKAGE_NAME}}/__init__.py`
3. Move `[Unreleased]` entries in `CHANGELOG.md` to the new `[X.Y.Z] - YYYY-MM-DD` section
4. Run `make version` to verify consistency — fix and retry if it fails
5. Commit with message: `chore: bump version to X.Y.Z`
6. Create git tag: `git tag -a vX.Y.Z -m "Release version X.Y.Z"`
7. Push branch and tags: `git push origin main vX.Y.Z`

Rules:
- Commit messages in English, no Co-Authored-By
- Do not enter plan mode, execute directly
- Always run `make version` before committing
