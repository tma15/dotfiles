#!/bin/zsh

set -euo pipefail

typeset -gr TEST_DIR="${${(%):-%N}:A:h}"

for test_script in "$TEST_DIR"/test-*.zsh; do
  print -r -- "==> ${test_script:t}"
  /bin/zsh "$test_script"
done
