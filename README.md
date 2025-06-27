# Dotfiles

[![CI](https://github.com/tma15/dotfiles/workflows/CI/badge.svg)](https://github.com/tma15/dotfiles/actions/workflows/ci.yaml)
[![tagpr](https://github.com/tma15/dotfiles/workflows/tagpr/badge.svg)](https://github.com/tma15/dotfiles/actions/workflows/tagpr.yaml)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/tma15/dotfiles)](https://github.com/tma15/dotfiles/releases)
[![License](https://img.shields.io/github/license/tma15/dotfiles)](https://github.com/tma15/dotfiles/blob/main/LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/tma15/dotfiles)](https://github.com/tma15/dotfiles/commits/main)

The dotfiles repository contains configuration files for the following tools:

- tmux
- vim
- zsh
- VS Code

## Install
```sh
git clone https://github.com/tma15/dotfiles.git
cd dotfiles
zsh init.zsh
```

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

## Author
Takuya Makino