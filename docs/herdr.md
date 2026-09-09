# Herdr Notes

This repository manages shared Herdr defaults in `herdr/config.toml`.
Machine-specific Herdr behavior should stay in local config where possible.

## Pane Display

The shared config uses Herdr 0.9.0's `ui.pane_borders = "always"` with
`ui.pane_outer_borders = true` to frame single panes as well as splits.
Agent labels on pane borders remain enabled. Kitty graphics are enabled
through `terminal.kitty_graphics = true` for image rendering in compatible
outer terminals. An image viewer must emit the Kitty graphics protocol.
Changing this setting requires restarting the affected server and reattaching
the client; config reload alone does not apply it.

After editing these display settings, use the UI's `reload config` action
to reload the local client's presentation settings, including for SSH machines.

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
