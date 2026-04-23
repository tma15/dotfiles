#!/bin/zsh

set -euo pipefail

typeset -gr TEST_DIR="${${(%):-%N}:A:h}"
typeset -gr REPO_ROOT="${TEST_DIR:h}"
typeset -ga TEST_TMPDIRS=()

make_temp_dir() {
  local prefix="${1:-dotfiles-test}"
  local tmpdir

  tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/${prefix}.XXXXXX")"
  TEST_TMPDIRS+=("$tmpdir")
  print -r -- "$tmpdir"
}

cleanup_temp_dirs() {
  local tmpdir

  for tmpdir in "${TEST_TMPDIRS[@]}"; do
    [[ -d "$tmpdir" ]] && rm -rf -- "$tmpdir"
  done
}

fail() {
  print -u2 -- "FAIL: $1"
  exit 1
}

assert_eq() {
  local actual="$1"
  local expected="$2"
  local message="${3:-expected '$expected', got '$actual'}"

  [[ "$actual" == "$expected" ]] || fail "$message"
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="${3:-expected output to contain '$needle'}"

  [[ "$haystack" == *"$needle"* ]] || fail "$message"
}

assert_exists() {
  local path="$1"

  [[ -e "$path" || -L "$path" ]] || fail "expected '$path' to exist"
}

assert_not_exists() {
  local path="$1"

  [[ ! -e "$path" && ! -L "$path" ]] || fail "expected '$path' to not exist"
}

assert_symlink_target() {
  local path="$1"
  local expected="$2"
  local actual
  local expected_abs

  [[ -L "$path" ]] || fail "expected '$path' to be a symlink"
  actual="${path:A}"
  expected_abs="${expected:A}"
  [[ "$actual" == "$expected_abs" ]] || fail "expected '$path' to point to '$expected_abs', got '$actual'"
}

trap cleanup_temp_dirs EXIT
