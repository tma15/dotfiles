# Herdr Notes

This repository manages shared Herdr defaults in `herdr/config.toml`.
Machine-specific Herdr behavior should stay in local config where possible.

## File Viewer

This setup binds the `herdr-file-viewer` plugin to `ctrl+t f` for a split pane
and `ctrl+t F` for a new tab. Install the plugin after linking the config:

```sh
herdr plugin install smarzban/herdr-file-viewer
herdr server reload-config
```

For styled Markdown, diffs, and syntax highlighting, install its optional
renderers on macOS:

```sh
brew install glow git-delta bat
```

## Remote Notifications

Herdr remote sessions use the Herdr server and agent integrations on the remote
host where the agent runs. If agent completion sounds do not play after opening
a remote session, check the remote host rather than the local client first.

On the remote host, make sure the agent integration is installed and current:

```sh
herdr integration status
herdr integration install codex
```

Also make sure the remote Herdr config enables sounds:

```toml
[ui.sound]
enabled = true
```

Reload the remote server after changing `~/.config/herdr/config.toml`:

```sh
herdr server reload-config
```

You can verify the remote notification path with:

```sh
herdr notification show "Herdr remote test" --body "done sound test" --sound done
```
