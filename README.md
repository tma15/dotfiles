# Dotfiles

[![CI](https://github.com/tma15/dotfiles/workflows/CI/badge.svg)](https://github.com/tma15/dotfiles/actions/workflows/ci.yaml)
[![tagpr](https://github.com/tma15/dotfiles/workflows/tagpr/badge.svg)](https://github.com/tma15/dotfiles/actions/workflows/tagpr.yaml)
[![Security Check](https://github.com/tma15/dotfiles/workflows/Security%20and%20Dependency%20Check/badge.svg)](https://github.com/tma15/dotfiles/actions/workflows/security-check.yaml)
[![Submodule Update](https://github.com/tma15/dotfiles/workflows/Submodule%20Update%20Check/badge.svg)](https://github.com/tma15/dotfiles/actions/workflows/submodule-update.yaml)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/tma15/dotfiles)](https://github.com/tma15/dotfiles/releases)
[![License](https://img.shields.io/github/license/tma15/dotfiles)](https://github.com/tma15/dotfiles/blob/main/LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/tma15/dotfiles)](https://github.com/tma15/dotfiles/commits/main)

The dotfiles repository contains configuration files for the following tools:

- tmux
- vim
- zsh
- VS Code

## Install

### Requirements
- macOS or Linux
- Git
- Zsh (will be configured automatically)

### Installation
```sh
git clone https://github.com/tma15/dotfiles.git
cd dotfiles
zsh init.zsh
```

**Note**: The installation script will automatically install Deno and configure symbolic links.

## Features
### Vim
The vim configuration manages plugins via [dein](https://github.com/Shougo/dein.vim).
On the first launch, dein installs plugins defined in `vim/dein/userconfig/plugins.toml` and `vim/dein/userconfig/plugins_lazy.toml`.

Modern plugins such as [ddc](https://github.com/Shougo/ddc.vim) and [vim-lsp](https://github.com/prabirshrestha/vim-lsp) are included for code completion.
Since ddc depends on [Deno](https://deno.land/), it will be installed by `init.zsh`.

Dein also installs plugins like [black](https://github.com/psf/black) and [vim-indent-guide](https://github.com/thaerkh/vim-indentguides) to assist with Python development.
Additionally, a [flake8](https://flake8.pycqa.org/en/latest/)-based linter is enabled via `vim-lsp`.

### Zsh
The zsh configuration is based on [prezto](https://github.com/sorin-ionescu/prezto), with the main settings in `zpreztorc`.

The Python environment is managed by [pyenv](https://github.com/pyenv/pyenv), with its configuration in `zshrc`.

### Tmux
tmux is automatically started whenever a terminal is opened.

### VS Code
VS Code configuration files are also included. The `vscode/` directory contains editor settings and recommended extensions, allowing you to quickly set up a comfortable development environment in VS Code.

## Development

### Version Management
This repository uses [tagpr](https://github.com/Songmu/tagpr) for automatic version management and release creation.

#### How to update version
1. **Make changes** to dotfiles configuration
2. **Create a pull request** with your changes
3. **Add version labels** to the PR:
   - `major`: for breaking changes (e.g., major configuration restructure)
   - `minor`: for new features (e.g., new tool configuration)
   - No label: for patch updates (e.g., bug fixes, minor tweaks)
4. **Merge the PR** to the main branch

#### What happens automatically
- tagpr creates a release PR with updated `VERSION` file and `CHANGELOG.md`
- When the release PR is merged:
  - Git tag is created (e.g., `v1.2.3`)
  - GitHub Release is published
  - Version files are synchronized

#### Manual version update (if needed)
If you need to manually update the version:
```bash
# Edit VERSION file
echo "1.2.3" > VERSION

# Commit and push
git add VERSION
git commit -m "bump version to 1.2.3"
git push
```

### CI/CD
The repository includes comprehensive GitHub Actions workflows for automation and quality assurance:

#### Core Workflows
- **CI** (`ci.yaml`): 
  - Tests syntax and installation on Ubuntu/macOS
  - Validates configuration files and dependencies
  - Checks for code quality issues (trailing whitespace, line endings)
  - Verifies submodule integrity and symlink health
- **tagpr** (`tagpr.yaml`): Automatic version management and releases

#### Automated Maintenance
- **Submodule Update Check** (`submodule-update.yaml`):
  - Runs weekly (Monday 9:00 AM UTC)
  - Automatically checks for new pyenv releases and zprezto updates
  - Creates pull requests when updates are available
  - Includes proper labeling for dependency updates
- **Security & Dependency Check** (`security-check.yaml`):
  - Runs weekly (Tuesday 2:00 AM UTC)
  - Scans for security vulnerabilities using Trivy
  - Checks for outdated tools (Deno, GitHub Actions)
  - Validates license compliance across submodules
  - Reports results to GitHub Security tab

#### Manual Triggers
All automated workflows can be manually triggered via GitHub Actions interface for immediate checks when needed.

#### Workflow Badges
You can monitor the status of these workflows through the badges at the top of this README:
- CI status shows the health of the latest tests
- tagpr status indicates the state of version management
- Additional workflow statuses can be viewed in the Actions tab

#### Security Features
- **Vulnerability Scanning**: Automated security scans with results uploaded to GitHub Security tab
- **Dependency Review**: Automatic review of dependency changes in pull requests
- **License Compliance**: Regular checks to ensure all components maintain proper licensing

### Submodule Management
This repository uses git submodules for `pyenv` and `zprezto`. To update submodules:

```bash
# Update all submodules to latest
git submodule update --remote

# Update specific submodule (pyenv to specific version)
cd pyenv
git checkout v2.6.3  # or latest version
cd ..
git add pyenv
git commit -m "update pyenv to v2.6.3"

# Update zprezto submodule (typically stays on master)
cd zprezto
git checkout master
git pull origin master
cd ..
git add zprezto
git commit -m "update zprezto to latest master"

# Check submodule status
git submodule status
```

**Note**: 
- `pyenv` uses semantic versioning tags (e.g., v2.6.3)
- `zprezto` typically uses the master branch
- Always commit submodule updates to track the specific versions used

## Author
Takuya Makino