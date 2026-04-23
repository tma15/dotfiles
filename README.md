# Dotfiles

[![CI](https://github.com/tma15/dotfiles/workflows/CI/badge.svg)](https://github.com/tma15/dotfiles/actions/workflows/ci.yaml)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/tma15/dotfiles)](https://github.com/tma15/dotfiles/releases)
[![License](https://img.shields.io/github/license/tma15/dotfiles)](https://github.com/tma15/dotfiles/blob/main/LICENSE)

Personal dotfiles for shell, editor, terminal, and SSH setup on macOS and Linux.

Managed configs:

- `zsh`
- `vim`
- `tmux`
- `ssh`
- `Ghostty`
- `VS Code`

## Quick Start

### Requirements

- macOS or Linux
- `git`
- `curl`
- `zsh`

### Install

```sh
git clone https://github.com/tma15/dotfiles.git
cd dotfiles
zsh init.zsh
```

`init.zsh` initializes submodules, backs up existing files when needed, creates
symlinks, and installs Deno if `$HOME/.deno/bin/deno` does not exist. Existing
files are backed up as `*.backup.<timestamp>`.

## Local Overrides

Keep machine-specific values out of the repository.

- `~/.zshrc.local` for local paths, SDK setup, and secrets
- `~/.ssh/config.local` for host-specific SSH entries
- `zshrc.local.example` and `ssh/config.local.example` as templates

If you keep private files in a separate repository, place it at
`~/work/dotfiles-private` or set `DOTFILES_PRIVATE_DIR` before running
`init.zsh`.

When that overlay repository exists, `init.zsh` links:

- `zshrc.local` to `~/.zshrc.local`
- `ssh/config.local` to `~/.ssh/config.local`

## Managed Files

### Zsh

- `zprezto` is included as a git submodule
- Main shell settings live in `zpreztorc`
- `zshrc` sets up `pyenv`, Deno, Prezto, and local overrides
- `zshrc` loads `~/.zshrc.local` first, then a repo-local `zshrc.local` if present

### Vim

- Plugins are managed by `dein`
- Plugin lists live in `vim/dein/userconfig/plugins.toml` and
  `vim/dein/userconfig/plugins_lazy.toml`
- Deno-backed completion plugins are supported, so `init.zsh` installs Deno

### SSH

- Shared defaults live in `ssh/config`
- `ssh/config` includes `~/.ssh/config.local`
- Public defaults and private host aliases stay separate

### tmux

- `tmux.conf` is installed by `init.zsh`
- tmux auto-start is currently disabled in `zpreztorc`

### Ghostty

- `ghostty/config.ghostty` is linked to both
  `~/.config/ghostty/config.ghostty` and `~/.config/ghostty/config`

### VS Code

- `vscode/settings.json` and `vscode/keybindings.json` are included
- `init.zsh` links them on macOS when the VS Code user settings directory exists

## Updating

After pulling new changes, update submodules and re-run setup if needed.

```sh
git pull origin main
git submodule update --init --recursive
zsh init.zsh
```

## Maintenance

- Releases are managed with `tagpr`
- GitHub Actions workflows live in `.github/workflows/`
- Weekly workflows check submodule updates and security/dependency issues

## Author

Takuya Makino
