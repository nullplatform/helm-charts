#!/usr/bin/env sh
set -e

branch="${1:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)}"
if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
  exit 0
fi

pattern='^(feat|feature|fix|docs|style|refactor|perf|test|build|ci|chore|revert)/.+$|^(main|master)$'
if echo "$branch" | grep -Eq "$pattern"; then
  exit 0
fi

cat <<EOF
Invalid branch name: $branch
Expected: type/description
  Examples: feat/add-login, fix/bug-123, docs/readme
Valid types: feat, feature, fix, docs, style, refactor, perf, test, build, ci, chore, revert
EOF
exit 1
