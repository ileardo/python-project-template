# Force bash as shell for echo -e support
SHELL := /bin/bash

# ── project parameters ────────────────────────────────────────────────────────
PACKAGE_NAME ?= mypackage
SRC_DIR      ?= src
# ─────────────────────────────────────────────────────────────────────────────

# Color codes for output
RED    = \033[0;31m
GREEN  = \033[0;32m
YELLOW = \033[1;33m
BLUE   = \033[0;34m
NC     = \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

# Phony targets (not actual files)
.PHONY: help install setup test version

help:
	@echo -e "$(BLUE){{PROJECT_NAME}}$(NC)"
	@echo ""
	@echo -e "$(BLUE)General targets:$(NC)"
	@echo -e "  $(GREEN)make help$(NC)       - Show this help message"
	@echo ""
	@echo -e "$(BLUE)Installation targets:$(NC)"
	@echo -e "  $(GREEN)make install$(NC)    - Install package in editable mode with dev dependencies"
	@echo ""
	@echo -e "$(BLUE)Setup targets:$(NC)"
	@echo -e "  $(GREEN)make setup$(NC)      - Generate .env from .env.example (run once)"
	@echo ""
	@echo -e "$(BLUE)Development targets:$(NC)"
	@echo -e "  $(GREEN)make test$(NC)       - Run pytest with coverage"
	@echo ""
	@echo -e "$(BLUE)Version management:$(NC)"
	@echo -e "  $(GREEN)make version$(NC)    - Show current version and check consistency"
	@echo ""

install:
	pip install -e ".[dev]"

setup:
	@if [ -f .env ]; then \
		echo -e "$(YELLOW)[skip]$(NC) .env already exists — delete it first to regenerate"; \
	else \
		cp .env.example .env; \
		echo -e "$(GREEN)[ok]$(NC)   .env created from .env.example"; \
		echo -e "$(YELLOW)[!]$(NC)    Fill in the required values in .env before running the project"; \
	fi

test:
	python -m pytest

version:
	@echo -e "$(BLUE)Current version:$(NC)"
	@echo -n "  pyproject.toml:                         "
	@grep "^version = " pyproject.toml | sed 's/version = "\(.*\)"/\1/'
	@echo -n "  $(SRC_DIR)/$(PACKAGE_NAME)/__init__.py: "
	@grep "^__version__ = " $(SRC_DIR)/$(PACKAGE_NAME)/__init__.py | sed "s/__version__ = '\(.*\)'/\1/"
	@echo ""
	@echo -e "$(BLUE)Version consistency check:$(NC)"
	@if [ "$$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/')" = "$$(grep '^__version__ = ' $(SRC_DIR)/$(PACKAGE_NAME)/__init__.py | sed "s/__version__ = '\(.*\)'/\1/")" ]; then \
		echo -e "  $(GREEN)[PASS]$(NC) Versions are synchronized"; \
	else \
		echo -e "  $(RED)[FAIL]$(NC) Versions are out of sync!"; \
		exit 1; \
	fi
