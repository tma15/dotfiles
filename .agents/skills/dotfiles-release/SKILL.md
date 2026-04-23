---
name: dotfiles-release
description: この dotfiles リポジトリの version 判断、release PR の確認と merge、tag と GitHub Release の確認、release note の運用改善を進める。`VERSION`、`CHANGELOG.md`、`.tagpr`、`.github/release.yml`、`tagpr` workflow、GitHub Release を扱う依頼で使う。特に、次を patch/minor/major のどれにするか判断したいとき、open な release PR を安全に処理したいとき、release note や tag の反映まで確認したいときに使う。
---

# Dotfiles Release

## 概要

この repo の release 手順は `tagpr` 前提で動くので、通常の保守作業とは分けて扱う。`main` への push で `tagpr` が release PR を作成または更新し、その PR を merge すると tag と GitHub Release が作られる。release 関連ファイルと GitHub 側の状態を先に確認し、open な release PR があるかどうかで作業順を切り替える。

## 対象ファイル

- version と changelog: `VERSION`, `CHANGELOG.md`
- release 設定: `.tagpr`, `.github/release.yml`, `.github/workflows/tagpr.yaml`
- GitHub 側の確認対象: release PR, tag, GitHub Release, `tagpr` workflow run

## 基本ルール

- release PR を merge する前に、diff が release 用変更に閉じているか確認する。通常は `VERSION` と `CHANGELOG.md` が中心で、想定外の runtime 変更が紛れていないことを確認する。
- patch / minor / major は自動で決め打ちしない。直近の変更量と性質を見て、迷うときは判断根拠を明示してから進める。
- GitHub 側確認には `gh` を優先し、非対話で再現可能なコマンドを使う。
- sandbox や network 制約で `gh` / `git fetch` が失敗したら、同じ目的のコマンドを escalated permissions で再実行する。
- merge 後は GitHub Release 公開と tag のローカル同期まで確認して完了とする。

## version 判断の目安

- patch:
  - 小さな修正だけで、既存の使い方や install モデルに意味のある変更がない
  - docs の微修正や限定的な bug fix が中心
- minor:
  - 複数の実質的変更が溜まっている
  - install、README、cmux、test、repo workflow、skill 追加など、利用者や保守者の体験が広がる変更が入っている
- major:
  - 既存セットアップの前提を壊す
  - install 手順、配置、private overlay モデル、主要な操作フローが後方互換でなく変わる
- 判断が微妙なら、最後の tag 以降の PR 一覧と変更内容を見て、なぜ patch/minor/major が自然かを短く説明する。

## 作業フロー

1. まず `git status -sb` でローカルが clean か確認する。
2. `VERSION`、`CHANGELOG.md`、`.tagpr`、`.github/release.yml` を読んで現在の release 前提を把握する。
3. `git tag --sort=-v:refname` や最近の PR / commit を見て、前回 release 以降の変化量を確認する。
4. open な release PR があるか確認する。
5. release PR がある場合:
   - `gh pr view` と `gh pr diff` で title, body, diff を確認する。
   - version が妥当か、diff が release 用変更に閉じているかを見る。
   - 問題なければ merge する。
6. release PR がない場合:
   - まず直近の `tagpr` workflow がすでに走っているか確認する。
   - 今すぐ version を決めるべきか、まず `main` に変更を積む段階かを切り分ける。
   - version 判断だけ求められているなら、根拠付きで patch/minor/major を提案する。
7. merge 後は `gh run list --workflow tagpr`、`gh release view <tag>`、`git fetch --tags origin` を使って workflow、GitHub Release、tag を確認する。
8. 最後に `git pull --ff-only origin main` と tag 同期をして、ローカル状態を整える。

## release PR を扱うときの確認点

- title が `Release for vX.Y.Z` 系か確認する。
- body に version 変更方法や generated notes が入っていることを確認する。
- diff に `VERSION` と `CHANGELOG.md` 以外が含まれるなら、その理由を確認する。
- `mergeStateStatus` や checks が不安定なら、原因を見ずに merge しない。

## release note を改善するとき

- 現在の release note は `.github/release.yml` で制御される。まず今の generated body を確認して、何が読みづらいかを特定する。
- 改善案は、カテゴリ分け、除外 label、bot 更新の分離、短い要約の追加を優先する。
- release note を整えるには `.github/release.yml` だけでなく PR label 運用も必要になることを明示する。
- この改善は次回 release 以降に効く。すでに出た release 本文を直すなら、GitHub Release 本文の編集が別途必要になる。

## 検証

- release 操作前:
  - `git status -sb`
  - `git tag --sort=-v:refname | head`
- release PR 確認:
  - `gh pr view <number> --json title,body,state,mergeStateStatus,headRefName,baseRefName,url`
  - `gh pr diff <number>`
- merge 後確認:
  - `gh run list --workflow tagpr --limit 5`
  - `gh release view vX.Y.Z`
  - `git fetch --tags origin`
  - `git tag --sort=-v:refname | head`
  - `git pull --ff-only origin main`

## 依頼例

- "今の変更量だと次は patch と minor のどちらが自然か見て"
- "open な release PR を確認して、問題なければ merge して"
- "release 後に tag と GitHub Release まで反映されたか確認して"
- "今後の release note を読みやすくするために `.github/release.yml` を整えて"
