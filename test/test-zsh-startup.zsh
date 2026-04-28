#!/bin/zsh

set -euo pipefail

source "${0:A:h}/lib.zsh"

plain_home="$(make_temp_dir dotfiles-zsh-plain)"
mkdir -p "$plain_home/.zprezto" "$plain_home/.local/bin"
: > "$plain_home/.zprezto/init.zsh"

HOME="$plain_home" ZDOTDIR="$plain_home" /bin/zsh -fc '
  source "$1/zshrc"
  [[ "${DOTFILES_IS_CMUX_RELAY:-0}" == "0" ]] || exit 1
  [[ ! -e "$ZDOTDIR/.zpreztorc" ]] || exit 1
  [[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || exit 1
' _ "$REPO_ROOT"

relay_home="$(make_temp_dir dotfiles-zsh-relay)"
mkdir -p "$relay_home/.zprezto" "$relay_home/.cmux/relay/session"
: > "$relay_home/.zprezto/init.zsh"
: > "$relay_home/.zpreztorc"
: > "$relay_home/.p10k.zsh"

HOME="$relay_home" ZDOTDIR="$relay_home/.cmux/relay/session" /bin/zsh -fc '
  source "$1/zshrc"
  source "$1/zpreztorc"

  relay_zpreztorc="$ZDOTDIR/.zpreztorc"
  relay_p10k="$ZDOTDIR/.p10k.zsh"
  expected_zpreztorc="$HOME/.zpreztorc"
  expected_p10k="$HOME/.p10k.zsh"
  zstyle -s ":prezto:module:history" histfile histfile
  zstyle -t ":prezto:module:tmux:alias" skip

  [[ "${DOTFILES_IS_CMUX_RELAY:-0}" == "1" ]] || exit 1
  [[ "$histfile" == "$HOME/.zsh_history" ]] || exit 1
  [[ -L "$relay_zpreztorc" ]] || exit 1
  [[ -L "$relay_p10k" ]] || exit 1
  [[ "${relay_zpreztorc:A}" == "${expected_zpreztorc:A}" ]] || exit 1
  [[ "${relay_p10k:A}" == "${expected_p10k:A}" ]] || exit 1
' _ "$REPO_ROOT"
