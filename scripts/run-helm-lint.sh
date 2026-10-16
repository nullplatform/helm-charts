#!/usr/bin/env sh
set -e

# Lint every chart with staged changes, the same check CI runs on a pull request.
# helm lint renders the templates, which yamllint can't parse (Go template syntax).

if ! command -v helm >/dev/null 2>&1; then
  echo "Warning: helm is not installed, skipping chart lint. Install with: brew install helm" >&2
  exit 0
fi

charts=$(git diff --cached --name-only --diff-filter=d | grep -E '^charts/[^/]+/' | cut -d/ -f1-2 | sort -u || true)

if [ -z "$charts" ]; then
  exit 0
fi

for chart in $charts; do
  if [ -f "$chart/Chart.yaml" ]; then
    helm lint "$chart"
  fi
done
