# Dotfiles
dotfiles have configuration files of following tools:

- tmux
- vim
- zsh

## Install
```sh
git clone https://github.com/tma15/dotfiles.git
cd dotfiles
zsh init.zsh
```

## Features
### Vim
My configuration of vim manages plugins via [dein](https://github.com/Shougo/dein.vim).
For the first use of vim in my configuration, dein installs plugins, which are written in `vimrc`.

Plugins are modern ones such as [ddc](https://github.com/Shougo/ddc.vim), [vim-lsp](https://github.com/prabirshrestha/vim-lsp) for completion.
Because ddc depends on [Deno](https://deno.land/), it will be installed by `init.zsh`.

Dein in my configuration also installs plugins such as [black](https://github.com/psf/black) and [vim-indent-guide](https://github.com/thaerkh/vim-indentguides) for assisting writing of Python sources.
In addition, a [flake8](https://flake8.pycqa.org/en/latest/)-based linter is enabled by `vim-lsp`.

### Zsh
My configuration of zsh depends on [prezto](https://github.com/sorin-ionescu/prezto).
Main configuration based on prezto is written in `zpreztorc`.

Because Python environment is built by [pyenv](https://github.com/pyenv/pyenv), its configuration is written in `zshrc`.

### Tmux
Whenever opening a terminal, tmux will be automatically started.

## Author
Takuya Makino
