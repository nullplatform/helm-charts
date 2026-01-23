#!/usr/bin/env sh
set -e

if [ ! -f .changed-charts ]; then
  exit 0
fi

while read -r dir; do
  [ -z "$dir" ] && continue
  if [ -f "$dir/README.md.gotmpl" ]; then
    helm-docs --chart-search-root "$dir"
  fi
done < .changed-charts
