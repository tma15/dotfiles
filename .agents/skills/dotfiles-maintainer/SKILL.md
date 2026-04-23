---
name: dotfiles-maintainer
description: この dotfiles リポジトリを安全かつ一貫した方針で保守する。`zsh`、`vim`、`tmux`、`ssh`、`ghostty`、`vscode` の共有設定、`init.zsh` のブートストラップ処理、repo スコープの Codex skill、関連するドキュメントやテストを追加・更新するときに使う。特に、local/private overlay、cmux relay の挙動、symlink ベースのインストール、smoke test の整合性を壊さず変更したいときに使う。
---

# Dotfiles Maintainer

## 概要

このリポジトリを汎用的な dotfiles repo として扱わず、既存の運用方針に合わせて変更する。公開してよい共通設定は version control に残し、マシン依存値や秘密情報は local overlay に逃がし、挙動を変えたら docs と tests も同じ変更の中で追従させる。

## 基本ルール

- 秘密情報、host 固有の identity、proxy 設定、マシンローカルな SDK path を tracked file に入れない。local 専用の値は `~/.zshrc.local`、`~/.ssh/config.local`、`zshrc.local.example`、`ssh/config.local.example`、`DOTFILES_PRIVATE_DIR` を使って扱う。
- `init.zsh` の install モデルを維持する。既存ファイルの backup、repo 管理ファイルの `$HOME` への symlink、private overlay repo のサポート、`uname` で分岐する macOS 固有の VS Code linking を壊さない。
- cmux 前提を維持する。`cmux` は primary entry point、`tmux` は明示的な fallback、relay shell では `ZDOTDIR` が `~/.cmux/relay/` 配下になり得る。tracked config を host 固有の shell wrapper に依存させない。
- 挙動が明示的に macOS 固有でない限り、共有設定は cross-platform を保つ。Darwin 前提で雑に書かず、platform 分岐は明示する。
- 変更は最小の一貫した単位で行う。挙動が変わるなら、近接する docs と tests も同じ patch で更新する。

## ファイル対応表

- bootstrap と install 挙動: `init.zsh`, `README.md`, `test/test-init.zsh`
- Zsh、Prezto、cmux relay 挙動: `zshrc`, `zpreztorc`, `docs/cmux.md`, `test/test-zsh-startup.zsh`
- SSH の共有 default と local overlay の形: `ssh/config`, `ssh/config.local.example`, `test/test-ssh-config.zsh`
- Vim の startup と plugin bootstrap: `vimrc`, `vim/dein/userconfig/plugins.toml`, `vim/dein/userconfig/plugins_lazy.toml`, `vim/bin/`, `test/test-vim-startup.zsh`
- terminal / editor surface: `tmux.conf`, `ghostty/config.ghostty`, `vscode/settings.json`, `vscode/keybindings.json`
- repo スコープの Codex behavior: `.agents/skills/`

## 作業フロー

1. 編集前に、影響を受けるファイルと最寄りの tests / docs を読む。
2. その変更を public repo に置くべきか、example file にするべきか、local/private overlay に逃がすべきかを先に決める。
3. 挙動、docs、install wiring の整合性を保てる最小のファイル集合だけを編集する。
4. まず最も具体的な test を回し、複数面にまたがる変更なら広い smoke suite を追加で回す。
5. 実行していない validation や残存リスクがあるなら、最後に明示する。

## 検証

- `init.zsh`、managed file linking、private overlay の挙動を変えたら `zsh test/test-init.zsh` を回す。
- `zshrc`、`zpreztorc`、relay 処理、cmux 関連挙動を変えたら `zsh test/test-zsh-startup.zsh` を回す。
- SSH default や local overlay の example を変えたら `zsh test/test-ssh-config.zsh` を回す。
- Vim startup、plugin bootstrap、`vim/bin` 配下の helper wrapper を変えたら `zsh test/test-vim-startup.zsh` を回す。
- 複数面にまたがる変更なら `zsh test/run.zsh` を回す。
- docs や skill text だけを変えた場合は、その artifact に対応する最小の validator を使う。

## 編集指針

- 新しい managed file を足すときは `init.zsh` と `README.md` も更新し、install 挙動が変わるなら test を追加または拡張する。
- 設定を public と local の間で移すときは、public repo は最小に保ち、local 側の形は `*.example` で文書化する。
- shell startup を触るときは interactive startup を重くしない。prompt や対話入力を増やして non-interactive test を壊さない。
- cmux 挙動を触るときは relay 固有 path がまだ機能するかを確認し、Prezto の tmux auto-start や alias を誤って再有効化しない。
- editor や terminal の keybinding を触るときは、明示的な依頼がない限り repo の現在意図を保つ。

## 依頼例

- "Ghostty の設定を追加して、installer の symlink も崩れないようにして"
- "SSH の default を public config から外して、local example も正しく直して"
- "Vim の bootstrap 挙動を調整して、必要なら startup test も更新して"
- "`.agents/skills` 配下の repo スコープ skill を追加または修正して"
