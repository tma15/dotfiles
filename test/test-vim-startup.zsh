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

typeset -r DEIN_REPOS_SOURCE="${DOTFILES_TEST_DEIN_REPOS:-$HOME/.vim/dein/repos}"
typeset -r PYLSP_ALL_SOURCE="${DOTFILES_TEST_PYLSP_ALL:-$HOME/.local/share/vim-lsp-settings/servers/pylsp-all}"

command -v vim >/dev/null 2>&1 || skip "vim is not installed"
[[ -d "$DEIN_REPOS_SOURCE/github.com/Shougo/dein.vim" ]] || skip "dein repos are not available at $DEIN_REPOS_SOURCE"
[[ -d "$PYLSP_ALL_SOURCE" ]] || skip "pylsp-all server is not available at $PYLSP_ALL_SOURCE"

tmp_home="$(make_temp_dir dotfiles-vim-home)"
mkdir -p \
  "$tmp_home/.vim/dein" \
  "$tmp_home/.local/share/vim-lsp-settings/servers"

ln -s "$REPO_ROOT/vimrc" "$tmp_home/.vimrc"
ln -s "$REPO_ROOT/vim/bin" "$tmp_home/.vim/bin"
ln -s "$REPO_ROOT/vim/snippet" "$tmp_home/.vim/snippet"
ln -s "$REPO_ROOT/vim/dein/userconfig" "$tmp_home/.vim/dein/userconfig"
ln -s "$DEIN_REPOS_SOURCE" "$tmp_home/.vim/dein/repos"
ln -s "$PYLSP_ALL_SOURCE" "$tmp_home/.local/share/vim-lsp-settings/servers/pylsp-all"

typeset -r log_path="$tmp_home/vim.log"
typeset -r messages_path="$tmp_home/messages.txt"

typeset -a vim_args=(
  -Nu NONE
  -n
  -i NONE
  -es
  --cmd 'set nocp'
  --cmd 'let g:denops#disabled = 1'
  --cmd 'set nomore'
  "+source $tmp_home/.vimrc"
  '+call dein#source()'
  "+redir => g:msgs | silent messages | redir END | call writefile(split(g:msgs, \"\\n\"), '$messages_path')"
  '+qall!'
)

if ! HOME="$tmp_home" vim "${vim_args[@]}" >"$log_path" 2>&1; then
  print -u2 -- "vim startup test failed:"
  sed -n '1,200p' "$log_path" >&2 || true
  [[ -f "$messages_path" ]] && sed -n '1,200p' "$messages_path" >&2 || true
  find "$tmp_home/.vim/dein" -maxdepth 3 -type f >&2 || true
  fail "vim exited with a non-zero status"
fi

HOME="$tmp_home" "$REPO_ROOT/vim/bin/pylsp-all" --version >/dev/null 2>&1 \
  || fail "pylsp-all wrapper did not start from the temp HOME"

assert_exists "$tmp_home/.vim/dein/.cache/.vimrc/.dein/autoload/ddc.vim"
assert_exists "$tmp_home/.vim/dein/.cache/.vimrc/.dein/autoload/lsp.vim"
assert_exists "$tmp_home/.vim/dein/.cache/.vimrc/.dein/colors/molokai.vim"

messages_content=""
[[ -f "$messages_path" ]] && messages_content="$(<"$messages_path")"
assert_not_contains "$messages_content" 'E185:' "colorscheme loading still fails"
assert_not_contains "$messages_content" 'E117:' "ddc functions are still missing at startup"
assert_not_contains "$messages_content" 'E631:' "LSP write failures are still happening"
assert_not_contains "$messages_content" 'ch_sendraw()' "LSP channel writes are still failing"
