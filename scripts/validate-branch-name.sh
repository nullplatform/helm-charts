#!/usr/bin/env sh
set -e

branch="${1:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)}"
if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
  exit 0
fi

pattern='^(feature|bugfix|hotfix|chore)/[a-z0-9-]+$|^release/[0-9]+\.[0-9]+\.[0-9]+$|^(main|master)$'
if echo "$branch" | grep -Eq "$pattern"; then
  exit 0
fi

cat <<EOF
Invalid branch name: $branch
Expected:
- feature|bugfix|hotfix|chore/<kebab-case>
- release/x.y.z
EOF
exit 1
