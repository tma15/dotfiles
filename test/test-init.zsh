#!/bin/zsh

set -euo pipefail

source "${0:A:h}/lib.zsh"

[[ -d "$REPO_ROOT/pyenv" ]] || fail "pyenv submodule is missing"
[[ -d "$REPO_ROOT/zprezto" ]] || fail "zprezto submodule is missing"

tmp_home="$(make_temp_dir dotfiles-init-home)"
private_dir="$(make_temp_dir dotfiles-private)"

mkdir -p "$tmp_home/.deno/bin" "$tmp_home/.ssh" "$tmp_home/.config/ghostty" "$private_dir/ssh"
print -r -- '#!/bin/sh' > "$tmp_home/.deno/bin/deno"
print -r -- 'exit 0' >> "$tmp_home/.deno/bin/deno"
chmod +x "$tmp_home/.deno/bin/deno"

print -r -- 'legacy zshrc' > "$tmp_home/.zshrc"
print -r -- 'legacy ssh config' > "$tmp_home/.ssh/config"
print -r -- 'export DOTFILES_PRIVATE_TEST=1' > "$private_dir/zshrc.local"
print -r -- 'Host private-host' > "$private_dir/ssh/config.local"

if [[ "$(uname)" == "Darwin" ]]; then
  mkdir -p "$tmp_home/Library/Application Support/Code/User"
  print -r -- '{}' > "$tmp_home/Library/Application Support/Code/User/settings.json"
  print -r -- '[]' > "$tmp_home/Library/Application Support/Code/User/keybindings.json"
fi

(
  cd "$tmp_home"
  HOME="$tmp_home" DOTFILES_PRIVATE_DIR="$private_dir" /bin/zsh -fc '
    export DOTFILES_SOURCE_ONLY=1
    source "$1/init.zsh"
    setup_git_submodule() { :; }
    main
  ' _ "$REPO_ROOT"
)

assert_symlink_target "$tmp_home/.zprezto" "$REPO_ROOT/zprezto"
assert_symlink_target "$tmp_home/.pyenv" "$REPO_ROOT/pyenv"
assert_symlink_target "$tmp_home/.zshrc" "$REPO_ROOT/zshrc"
assert_symlink_target "$tmp_home/.zpreztorc" "$REPO_ROOT/zpreztorc"
assert_symlink_target "$tmp_home/.vimrc" "$REPO_ROOT/vimrc"
assert_symlink_target "$tmp_home/.tmux.conf" "$REPO_ROOT/tmux.conf"
assert_symlink_target "$tmp_home/.local/bin/md-preview-server" "$REPO_ROOT/bin/md-preview-server"
assert_symlink_target "$tmp_home/.codex/skills/cmux-markdown-preview" "$REPO_ROOT/.agents/skills/cmux-markdown-preview"
assert_symlink_target "$tmp_home/.ssh/config" "$REPO_ROOT/ssh/config"
assert_symlink_target "$tmp_home/.config/ghostty/config.ghostty" "$REPO_ROOT/ghostty/config.ghostty"
assert_symlink_target "$tmp_home/.config/ghostty/config" "$REPO_ROOT/ghostty/config.ghostty"
assert_symlink_target "$tmp_home/.zshrc.local" "$private_dir/zshrc.local"
assert_symlink_target "$tmp_home/.ssh/config.local" "$private_dir/ssh/config.local"

zshrc_backups=("$tmp_home"/.zshrc.backup.*(N))
ssh_config_backups=("$tmp_home"/.ssh/config.backup.*(N))
assert_eq "${#zshrc_backups[@]}" "1" "expected one .zshrc backup after the first install"
assert_eq "${#ssh_config_backups[@]}" "1" "expected one SSH config backup after the first install"
assert_contains "$(cat "$zshrc_backups[1]")" "legacy zshrc"
assert_contains "$(cat "$ssh_config_backups[1]")" "legacy ssh config"

if [[ "$(uname)" == "Darwin" ]]; then
  assert_symlink_target "$tmp_home/Library/Application Support/Code/User/settings.json" "$REPO_ROOT/vscode/settings.json"
  assert_symlink_target "$tmp_home/Library/Application Support/Code/User/keybindings.json" "$REPO_ROOT/vscode/keybindings.json"

  vscode_settings_backups=("$tmp_home"/Library/Application\ Support/Code/User/settings.json.backup.*(N))
  vscode_keybindings_backups=("$tmp_home"/Library/Application\ Support/Code/User/keybindings.json.backup.*(N))
  assert_eq "${#vscode_settings_backups[@]}" "1" "expected one VS Code settings backup after the first install"
  assert_eq "${#vscode_keybindings_backups[@]}" "1" "expected one VS Code keybindings backup after the first install"
fi

(
  cd "$tmp_home"
  HOME="$tmp_home" DOTFILES_PRIVATE_DIR="$private_dir" /bin/zsh -fc '
    export DOTFILES_SOURCE_ONLY=1
    source "$1/init.zsh"
    setup_git_submodule() { :; }
    main
  ' _ "$REPO_ROOT"
)

zshrc_backups=("$tmp_home"/.zshrc.backup.*(N))
ssh_config_backups=("$tmp_home"/.ssh/config.backup.*(N))
assert_eq "${#zshrc_backups[@]}" "1" "expected .zshrc backups to stay stable across repeated installs"
assert_eq "${#ssh_config_backups[@]}" "1" "expected SSH config backups to stay stable across repeated installs"

if [[ "$(uname)" == "Darwin" ]]; then
  vscode_settings_backups=("$tmp_home"/Library/Application\ Support/Code/User/settings.json.backup.*(N))
  vscode_keybindings_backups=("$tmp_home"/Library/Application\ Support/Code/User/keybindings.json.backup.*(N))
  assert_eq "${#vscode_settings_backups[@]}" "1" "expected VS Code settings backups to stay stable across repeated installs"
  assert_eq "${#vscode_keybindings_backups[@]}" "1" "expected VS Code keybindings backups to stay stable across repeated installs"
fi
