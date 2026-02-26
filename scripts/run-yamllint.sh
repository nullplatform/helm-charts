#!/usr/bin/env sh
set -e

if ! command -v yamllint >/dev/null 2>&1; then
  echo "Warning: yamllint is not installed. Install with: pip install yamllint" >&2
  exit 0
fi

# Lint only staged YAML files to avoid errors in generated/vendored files
staged=$(git diff --cached --name-only --diff-filter=d | grep -E '\.(ya?ml)$' || true)

if [ -z "$staged" ]; then
  exit 0
fi

echo "$staged" | xargs yamllint -c .yamllint
