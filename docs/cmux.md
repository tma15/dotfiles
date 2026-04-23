# cmux Notes

This repository treats `cmux` as the primary entry point for relay and remote
shells. `tmux` remains available as an explicit fallback, but the shell setup is
biased toward `cmux`.

## Relay Shells

- `zshrc` treats a shell as a cmux relay when `ZDOTDIR` is under
  `~/.cmux/relay/`
- Relay shells keep using `~/.zsh_history` instead of a relay-local history file
- `zshrc` makes sure `.zpreztorc` and `.p10k.zsh` are reachable inside the relay
  directory

## SSH Aliases

- Define real hosts in `~/.ssh/config.local`
- Run `cmux ssh <alias>` instead of wrapping SSH targets in shell functions
- Keep `IdentityFile`, `ForwardAgent`, `ProxyCommand`, and similar options scoped
  to the hosts that need them

## Ghostty

- `ghostty/config.ghostty` maps `Ctrl+M` to a carriage return explicitly for
  cmux and Ghostty sessions

## tmux Fallback

- `tmux.conf` stays in the repository for direct tmux use
- Prezto tmux auto-start is disabled
- Prezto tmux aliases are disabled so `cmux` stays the default entry point
