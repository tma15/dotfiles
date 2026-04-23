# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export DENO_INSTALL=$HOME/.deno
export PATH="$DENO_INSTALL/bin:$PATH"

if [[ -n "${ZDOTDIR:-}" && "$ZDOTDIR" == "$HOME/.cmux/relay/"* && -d "$ZDOTDIR" ]]; then
  [[ -e "$ZDOTDIR/.zpreztorc" ]] || ln -s "$HOME/.zpreztorc" "$ZDOTDIR/.zpreztorc" 2>/dev/null
  if [[ -e "$HOME/.p10k.zsh" && ! -e "$ZDOTDIR/.p10k.zsh" ]]; then
    ln -s "$HOME/.p10k.zsh" "$ZDOTDIR/.p10k.zsh" 2>/dev/null
  fi
fi

if [[ -r "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
elif [[ -r "$HOME/.zprezto/init.zsh" ]]; then
  source "$HOME/.zprezto/init.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

. "$HOME/.local/bin/env"

# Load machine-specific overrides outside version control.
typeset -g DOTFILES_ZSHRC_DIR="${${(%):-%N}:A:h}"
for _dotfiles_local_zshrc in "$HOME/.zshrc.local" "$DOTFILES_ZSHRC_DIR/zshrc.local"; do
  if [[ -r "$_dotfiles_local_zshrc" ]]; then
    source "$_dotfiles_local_zshrc"
    break
  fi
done
unset _dotfiles_local_zshrc
