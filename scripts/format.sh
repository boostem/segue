#!/usr/bin/env sh
# Formats our own C code with clang-format. third_party/ is left alone.
#
#   scripts/format.sh          rewrite files in place
#   scripts/format.sh --check  fail if anything needs formatting
set -eu

cd "$(dirname "$0")/.."

if [ "${1:-}" = "--check" ]; then
  find src include tests tools \( -name '*.c' -o -name '*.h' \) -print0 |
    xargs -0 clang-format --dry-run --Werror
else
  find src include tests tools \( -name '*.c' -o -name '*.h' \) -print0 |
    xargs -0 clang-format -i
fi
