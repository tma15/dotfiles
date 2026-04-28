#!/bin/zsh

set -euo pipefail

source "${0:A:h}/lib.zsh"

skip() {
  print -r -- "SKIP: $1"
  exit 0
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  local message="${3:-unexpected output contains '$needle'}"

  [[ "$haystack" != *"$needle"* ]] || fail "$message"
}

typeset nvim_bin="${DOTFILES_TEST_NVIM:-}"
if [[ -z "$nvim_bin" ]]; then
  if command -v nvim >/dev/null 2>&1; then
    nvim_bin="$(command -v nvim)"
  elif [[ -x /opt/homebrew/bin/nvim ]]; then
    nvim_bin=/opt/homebrew/bin/nvim
  else
    skip "nvim is not installed"
  fi
fi

typeset -r DEIN_REPOS_SOURCE="${DOTFILES_TEST_DEIN_REPOS:-$HOME/.vim/dein/repos}"

[[ -x "$nvim_bin" ]] || skip "nvim is not executable at $nvim_bin"
[[ -d "$DEIN_REPOS_SOURCE/github.com/Shougo/dein.vim" ]] || skip "dein repos are not available at $DEIN_REPOS_SOURCE"
[[ -d "$DEIN_REPOS_SOURCE/github.com/Shougo/ddc.vim" ]] || skip "ddc.vim is not available at $DEIN_REPOS_SOURCE"

tmp_home="$(make_temp_dir dotfiles-nvim-home)"
mkdir -p \
  "$tmp_home/.config/nvim" \
  "$tmp_home/.vim/dein" \
  "$tmp_home/.local/state" \
  "$tmp_home/.local/share" \
  "$tmp_home/.cache"

ln -s "$REPO_ROOT/nvim/init.vim" "$tmp_home/.config/nvim/init.vim"
ln -s "$REPO_ROOT/vimrc" "$tmp_home/.vimrc"
ln -s "$REPO_ROOT/vim/bin" "$tmp_home/.vim/bin"
ln -s "$REPO_ROOT/vim/snippet" "$tmp_home/.vim/snippet"
ln -s "$REPO_ROOT/vim/dein/userconfig" "$tmp_home/.vim/dein/userconfig"
ln -s "$DEIN_REPOS_SOURCE" "$tmp_home/.vim/dein/repos"

typeset -r log_path="$tmp_home/nvim.log"
typeset -r check_path="$tmp_home/check.txt"
typeset -r messages_path="$tmp_home/messages.txt"

typeset -a nvim_args=(
  --headless
  -n
  -i NONE
  --cmd 'set nomore'
  "+redir => g:check | silent echo has('nvim-0.11.3') | silent echo executable('deno') | silent echo exists('*ddc#enable') | redir END | call writefile(split(g:check, \"\\n\"), '$check_path')"
  "+redir => g:msgs | silent messages | redir END | call writefile(split(g:msgs, \"\\n\"), '$messages_path')"
  '+qall!'
)

if ! HOME="$tmp_home" \
    XDG_CONFIG_HOME="$tmp_home/.config" \
    XDG_DATA_HOME="$tmp_home/.local/share" \
    XDG_STATE_HOME="$tmp_home/.local/state" \
    XDG_CACHE_HOME="$tmp_home/.cache" \
    "$nvim_bin" "${nvim_args[@]}" >"$log_path" 2>&1; then
  print -u2 -- "nvim startup test failed:"
  sed -n '1,200p' "$log_path" >&2 || true
  [[ -f "$messages_path" ]] && sed -n '1,200p' "$messages_path" >&2 || true
  fail "nvim exited with a non-zero status"
fi

typeset -a checks=("${(@f)$(<"$check_path")}")

[[ "${checks[1]:-0}" == "1" ]] || skip "nvim is below the ddc-supported version"
[[ "${checks[2]:-0}" == "1" ]] || skip "deno is not executable from nvim"
assert_eq "${checks[3]:-0}" "1" "expected ddc#enable to be loaded in Neovim"

messages_content=""
[[ -f "$messages_path" ]] && messages_content="$(<"$messages_path")"
assert_not_contains "$messages_content" 'E519:' "Neovim-only unsupported options are still set"
assert_not_contains "$messages_content" 'poet-v' "poet-v is still loaded for Neovim startup"
