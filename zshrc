# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g DOTFILES_ZSHRC_DIR="${${(%):-%N}:A:h}"
typeset -gi DOTFILES_IS_CMUX_RELAY=0

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if (( $+commands[pyenv] )); then
  eval "$(pyenv init --path)"
fi

export DENO_INSTALL=$HOME/.deno
export PATH="$DENO_INSTALL/bin:$PATH"

dotfiles_link_cmux_relay_file() {
  local source="$1"
  local target="$2"

  [[ -e "$source" || -L "$source" ]] || return 0
  ln -snf "$source" "$target" 2>/dev/null
}

if [[ -n "${ZDOTDIR:-}" && "$ZDOTDIR" == "$HOME/.cmux/relay/"* && -d "$ZDOTDIR" ]]; then
  DOTFILES_IS_CMUX_RELAY=1
  dotfiles_link_cmux_relay_file "$HOME/.zpreztorc" "$ZDOTDIR/.zpreztorc"
  dotfiles_link_cmux_relay_file "$HOME/.p10k.zsh" "$ZDOTDIR/.p10k.zsh"
fi
unset -f dotfiles_link_cmux_relay_file

if [[ -r "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
elif [[ -r "$HOME/.zprezto/init.zsh" ]]; then
  source "$HOME/.zprezto/init.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -r "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Load machine-specific overrides outside version control.
for _dotfiles_local_zshrc in "$HOME/.zshrc.local" "$DOTFILES_ZSHRC_DIR/zshrc.local"; do
  if [[ -r "$_dotfiles_local_zshrc" ]]; then
    source "$_dotfiles_local_zshrc"
    break
  fi
done
unset _dotfiles_local_zshrc
