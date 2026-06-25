#!/bin/zsh

set -euo pipefail

source "${0:A:h}/lib.zsh"

tmux_conf="$REPO_ROOT/tmux.conf"

grep -q '^set-option -g default-terminal tmux-256color$' "$tmux_conf"
grep -q "^set-option -ga terminal-features ',xterm-256color:RGB'$" "$tmux_conf"
grep -q "^set-option -ga terminal-features ',xterm-ghostty:RGB'$" "$tmux_conf"
grep -q "^set-option -ga terminal-features ',tmux-256color:RGB'$" "$tmux_conf"
grep -q '^set-environment -gu NO_COLOR$' "$tmux_conf"
grep -q '^set-environment -gu CODEX_CI$' "$tmux_conf"
