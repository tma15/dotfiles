---
name: cmux-markdown-preview
description: Use when the user wants to preview a Markdown file from a remote cmux session, open Markdown in a cmux browser pane, run md-preview-server, or troubleshoot remote localhost Markdown preview workflows. This covers the remote preview server, cmux browser open, and cmux remote proxy behavior on hosts such as makino-a100.
---

# Cmux Markdown Preview

## Workflow

Use this for Markdown files that live on a remote machine where the user is
working through cmux.

1. Start the preview server on the remote machine:

```sh
~/.local/bin/md-preview-server path/to/file.md --host 127.0.0.1 --port 8090
```

2. Open the remote-local URL in a cmux browser pane from another remote prompt:

```sh
cmux browser open http://127.0.0.1:8090
```

The preview server reads the remote Markdown file and serves rendered HTML on
remote `127.0.0.1:8090`. `cmux browser open` displays that URL in a cmux browser
pane. When the cmux remote proxy is active, `http://127.0.0.1:8090` resolves to
the remote server, not the local laptop.

## Notes

- Keep the server process running while the browser pane is open.
- Use `~/.local/bin/md-preview-server` after this dotfiles repo has been
  installed with `zsh init.zsh`; use `bin/md-preview-server` from a repo
  checkout if the helper has not been linked yet.
- The helper requires Python 3 and `markdown-it-py`; `uv` is optional.
- If `markdown_it` is missing, either install `markdown-it-py` in the remote
  Python environment or run one command with `uv run --with markdown-it-py ...`.
- Only use SSH port forwarding when the user wants to view the preview in a
  normal local browser instead of a cmux browser pane.
