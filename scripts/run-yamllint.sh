#!/usr/bin/env sh
set -e

if ! command -v yamllint >/dev/null 2>&1; then
  echo "Warning: yamllint is not installed. Install with: pip install yamllint" >&2
  exit 0
fi

yamllint -c .yamllint .
