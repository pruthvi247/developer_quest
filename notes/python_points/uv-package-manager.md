## Project Initialization


```bash
# Create new project
uv init my-project
cd my-project

# Initialize in existing directory
uv init

# Create application project with entry points
uv init --app my-app

```

## Dependency Management

UV provides intuitive dependency management that automatically updates both `pyproject.toml` and the lockfile:[](https://dev.to/thomas_bury_b1a50c1156cbf/mastering-python-project-management-with-uv-part-2-deep-dives-and-advanced-use-4mlb)

```bash
# Add dependencies
uv add requests
uv add pytest --group dev        # Development dependencies
uv add "fastapi>=0.100"         # With version constraints

# Remove dependencies  
uv remove requests

# Install all dependencies
uv sync

# Install specific groups
uv sync --group dev

```

## Virtual Environment Management

Unlike pip, UV automatically manages virtual environments:[](https://docs.astral.sh/uv/pip/environments/)
```bash
# Create virtual environment
uv venv
uv venv --python 3.11           # Specific Python version
uv venv my-env                  # Custom name

# Run commands in project environment
uv run python script.py
uv run pytest

# Traditional activation (optional)
source .venv/bin/activate

```
## Python Version Management

UV can install and manage Python versions directly:
```bash
# Install latest Python
uv python install

# Install specific versions
uv python install 3.11 3.12

# List available versions
uv python list

# Install alternative implementations
uv python install pypy@3.10

```
## Tool Management

UV replaces pipx functionality with built-in tool management:[](https://astral.sh/blog/uv-unified-python-packaging)

```bash
# Install tools globally
uv tool install ruff
uv tool install pytest

# Run tools without installation
uvx black .                     # Alias for uv tool run
uv tool run mypy src/

# List and manage tools
uv tool list
uv tool upgrade --all
uv tool uninstall ruff

```
`uv run script.py`

## Lockfile Management

UV generates comprehensive, cross-platform lockfiles:[](https://astral.sh/blog/uv-unified-python-packaging)

```bash
# Generate/update lockfile
uv lock

# Sync from lockfile
uv sync

# Check lockfile consistency  
uv lock --locked

# Export to requirements format
uv export --format requirements-txt --output-file requirements.txt

```
## pip Interface Compatibility

UV provides a drop-in replacement for common pip workflows:[](https://docs.astral.sh/uv/pip/compatibility/)
```bash
# Direct pip replacements
uv pip install requests        # Instead of: pip install requests
uv pip install -r requirements.txt
uv pip uninstall requests
uv pip list
uv pip freeze
uv pip show requests

# pip-tools replacements
uv pip compile requirements.in  # Instead of: pip-compile
uv pip sync requirements.txt    # Instead of: pip-sync

```
## Configuration and Customization

## Project Configuration

UV configuration is managed through `pyproject.toml` or dedicated `uv.toml` files:[](https://docs.astral.sh/uv/concepts/configuration-files/)
```bash
# pyproject.toml
[tool.uv]
index-url = "https://pypi.org/simple"
extra-index-url = ["https://test.pypi.org/simple"]
no-cache = false

[tool.uv.sources]
my-package = { path = "../my-package", editable = true }

# Development dependencies
[dependency-groups]
dev = ["pytest>=6.0", "ruff", "mypy"]
docs = ["sphinx>=4.0"]

```
## Common Command Mappings

| pip Workflow                      | UV Equivalent                              |
| --------------------------------- | ------------------------------------------ |
| `pip install requests`            | `uv add requests`                          |
| `pip install -r requirements.txt` | `uv sync`                                  |
| `python -m venv .venv`            | `uv venv`                                  |
| `pip freeze > requirements.txt`   | `uv export --output-file requirements.txt` |
| `pip-compile requirements.in`     | `uv pip compile requirements.in`           |
| `pipx install black`              | `uv tool install black`                    |


### Cache Management
```bash
# Clear cache
uv cache clean

# Check cache size
uv cache dir

```

### Debugging
```bash
# Verbose output
uv add requests -v

# Show resolution without installing  
uv add requests --dry-run

# Check dependency tree
uv tree

```
