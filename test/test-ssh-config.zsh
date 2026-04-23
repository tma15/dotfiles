#!/bin/zsh

set -euo pipefail

source "${0:A:h}/lib.zsh"

tmpdir="$(make_temp_dir dotfiles-ssh-config)"
rendered_config="$tmpdir/config"
local_config="$tmpdir/config.local"

sed "s|Include ~/.ssh/config.local|Include $local_config|" "$REPO_ROOT/ssh/config" > "$rendered_config"

cat > "$local_config" <<'EOF'
Host remote-gpu
  HostName example-host
  User example-user
  Port 22
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  ForwardAgent yes
  ProxyCommand /path/to/ssh-proxy %h %p
EOF

generic_output="$(ssh -G generic-host -F "$rendered_config" 2>/dev/null)"
remote_output="$(ssh -G remote-gpu -F "$rendered_config" 2>/dev/null)"

assert_contains "$generic_output" $'serveraliveinterval 60'
assert_contains "$generic_output" $'addkeystoagent true'
assert_contains "$generic_output" $'forwardagent no'

assert_contains "$remote_output" $'hostname example-host'
assert_contains "$remote_output" $'user example-user'
assert_contains "$remote_output" $'forwardagent yes'
assert_contains "$remote_output" $'identityfile ~/.ssh/id_ed25519'
assert_contains "$remote_output" $'proxycommand /path/to/ssh-proxy %h %p'
