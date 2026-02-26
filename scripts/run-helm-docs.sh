#!/usr/bin/env sh
set -e

# Accept chart dirs as arguments, or fall back to .changed-charts file
if [ $# -gt 0 ]; then
  for dir in "$@"; do
    [ -z "$dir" ] && continue
    if [ -f "$dir/README.md.gotmpl" ]; then
      helm-docs --chart-search-root "$dir"
    fi
  done
elif [ -f .changed-charts ]; then
  while read -r dir; do
    [ -z "$dir" ] && continue
    if [ -f "$dir/README.md.gotmpl" ]; then
      helm-docs --chart-search-root "$dir"
    fi
  done < .changed-charts
fi
