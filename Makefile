SHELL := /bin/bash
SOURCE_FOLDERS=legal_instruments tests


isort:
	@poetry run isort $(SOURCE_FOLDERS)
.PHONY: isort

black:
	@poetry run black -q $(SOURCE_FOLDERS)
.PHONY: black

pylint:
	@poetry run pylint $(SOURCE_FOLDERS)
.PHONY: pylint

mypy:
	@poetry run mypy --no-error-summary $(SOURCE_FOLDERS)
.PHONY: mypy

lint: isort black pylint mypy
.PHONY: lint

clean:
	@find . -type d -name '__pycache__' -exec rm -rf {} +
	@find . -type d -name '*pytest_cache*' -exec rm -rf {} +
	@find . -type d -name '.mypy_cache' -exec rm -rf {} +
	@rm -rf tests/output
.PHONY: clean

output-dir:
	@mkdir -p ./tests/output

test: output-dir
	@poetry run pytest --durations=0 tests/
	@rm -rf ./tests/output/*
.PHONY: test


