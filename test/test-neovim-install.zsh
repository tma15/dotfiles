#!/bin/zsh

set -euo pipefail

source "${0:A:h}/lib.zsh"

export DOTFILES_SOURCE_ONLY=1
source "$REPO_ROOT/init.zsh"

version_at_least "0.11.3" "0.11.3" || fail "expected equal Neovim versions to be accepted"
version_at_least "0.12.0" "0.11.3" || fail "expected newer Neovim version to be accepted"
if version_at_least "0.11.2" "0.11.3"; then
  fail "expected older Neovim version to be rejected"
fi

skip_home="$(make_temp_dir dotfiles-nvim-skip-home)"
(
  HOME="$skip_home"
  export HOME DOTFILES_SKIP_NVIM_INSTALL=1
  install_neovim
)
assert_not_exists "$skip_home/.local/bin/nvim"

install_home="$(make_temp_dir dotfiles-nvim-install-home)"
archive_root="$(make_temp_dir dotfiles-nvim-archive-root)"
fake_bin="$(make_temp_dir dotfiles-nvim-fake-bin)"
archive_path="$archive_root/nvim-linux-x86_64.tar.gz"

mkdir -p "$archive_root/nvim-linux-x86_64/bin"
print -r -- '#!/bin/sh' > "$archive_root/nvim-linux-x86_64/bin/nvim"
print -r -- 'printf "%s\n" "NVIM v0.12.0"' >> "$archive_root/nvim-linux-x86_64/bin/nvim"
chmod +x "$archive_root/nvim-linux-x86_64/bin/nvim"
tar -C "$archive_root" -czf "$archive_path" nvim-linux-x86_64

print -r -- '#!/bin/sh' > "$fake_bin/uname"
print -r -- 'if [ "$1" = "-m" ]; then' >> "$fake_bin/uname"
print -r -- '  printf "%s\n" "x86_64"' >> "$fake_bin/uname"
print -r -- 'else' >> "$fake_bin/uname"
print -r -- '  printf "%s\n" "Linux"' >> "$fake_bin/uname"
print -r -- 'fi' >> "$fake_bin/uname"
chmod +x "$fake_bin/uname"

print -r -- '#!/bin/sh' > "$fake_bin/curl"
print -r -- 'out=""' >> "$fake_bin/curl"
print -r -- 'while [ "$#" -gt 0 ]; do' >> "$fake_bin/curl"
print -r -- '  if [ "$1" = "-o" ]; then' >> "$fake_bin/curl"
print -r -- '    shift' >> "$fake_bin/curl"
print -r -- '    out="$1"' >> "$fake_bin/curl"
print -r -- '  fi' >> "$fake_bin/curl"
print -r -- '  shift' >> "$fake_bin/curl"
print -r -- 'done' >> "$fake_bin/curl"
print -r -- '[ -n "$out" ] || exit 2' >> "$fake_bin/curl"
print -r -- 'cp "$DOTFILES_TEST_NVIM_ARCHIVE" "$out"' >> "$fake_bin/curl"
chmod +x "$fake_bin/curl"

(
  HOME="$install_home"
  PATH="$fake_bin:/usr/bin:/bin:/usr/sbin:/sbin"
  DOTFILES_TEST_NVIM_ARCHIVE="$archive_path"
  export HOME PATH DOTFILES_TEST_NVIM_ARCHIVE
  install_neovim
)

expected_nvim="$install_home/.local/opt/dotfiles/nvim-linux-x86_64/bin/nvim"
assert_symlink_target "$install_home/.local/bin/nvim" "$expected_nvim"
assert_contains "$("$install_home/.local/bin/nvim" --version)" "NVIM v0.12.0"
