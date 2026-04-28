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

## Markdown Preview

`bin/md-preview-server` serves a single remote Markdown file as HTML on remote
localhost. `init.zsh` links it to `~/.local/bin/md-preview-server`.

From a remote machine terminal, start the preview server:

```sh
~/.local/bin/md-preview-server docs/example.md --host 127.0.0.1 --port 8090
```

From another remote terminal, another cmux pane, or a prompt where the server is
not occupying stdin, open the remote-local URL in a cmux browser pane:

```sh
cmux browser open http://127.0.0.1:8090
```

The server reads the Markdown file on the remote machine and serves rendered
HTML at `127.0.0.1:8090`. `cmux browser open` displays that URL in a browser
pane, and with the cmux remote proxy active it reaches the remote server. A
normal local browser only needs to be involved when you explicitly set up SSH
port forwarding.

The helper requires Python 3 and the `markdown_it` Python module, provided by
the `markdown-it-py` package, on the remote host where it runs. `uv` is not
required by the helper itself; it is only a convenient way to provide
`markdown-it-py` for one command without installing it globally:

```sh
uv run --with markdown-it-py ~/.local/bin/md-preview-server docs/example.md --host 127.0.0.1 --port 8090
```

## tmux Fallback

- `tmux.conf` stays in the repository for direct tmux use
- Prezto tmux auto-start is disabled
- Prezto tmux aliases are disabled so `cmux` stays the default entry point
