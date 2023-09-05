SHELL := /bin/bash
SOURCE_FOLDERS=legal_instruments tests


black:
	@poetry run black $(SOURCE_FOLDERS)
.PHONY: black

isort:
	@poetry run isort $(SOURCE_FOLDERS)
.PHONY: isort

mypy:
	@poetry run mypy $(SOURCE_FOLDERS)
.PHONY: mypy

lint:
	@poetry run pylint $(SOURCE_FOLDERS)

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


