#!/usr/bin/env bash
set -euo pipefail

output_file="${GITHUB_OUTPUT:-/dev/stdout}"
base_sha="${BASE_SHA:-}"
head_sha="${HEAD_SHA:-HEAD}"

if [ -n "$base_sha" ]; then
  diff_range="${base_sha}..${head_sha}"
else
  diff_range="${head_sha}~1..${head_sha}"
fi

changed_dirs=$(git diff --name-only "$diff_range" -- charts/ | awk -F/ '/^charts\/[^/]+/ {print $1"/"$2}' | sort -u)
if [ -z "$changed_dirs" ]; then
  echo "has_changes=false" >> "$output_file"
  exit 0
fi

global_tag=$(git tag --list --sort=-v:refname | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -n1 || true)
: > .changed-charts
: > .chart-tags

for dir in $changed_dirs; do
  chart_file="$dir/Chart.yaml"
  if [ ! -f "$chart_file" ]; then
    continue
  fi

  name=$(awk -F': *' '$1=="name"{print $2; exit}' "$chart_file")
  version=$(awk -F': *' '$1=="version"{print $2; exit}' "$chart_file")
  if [ -z "$name" ] || [ -z "$version" ]; then
    echo "Missing name or version in $chart_file" >&2
    exit 1
  fi

  last_tag=$(git tag --list "${name}-*" --sort=-v:refname | head -n1 || true)
  if [ -n "$last_tag" ]; then
    range="${last_tag}..${head_sha}"
  elif [ -n "$global_tag" ]; then
    range="${global_tag}..${head_sha}"
  else
    range=""
  fi

  if [ -n "$range" ]; then
    log=$(git log "$range" --format=%s%n%b -- "$dir" || true)
    subjects=$(git log "$range" --format=%s -- "$dir" || true)
  else
    log=$(git log --format=%s%n%b -- "$dir" || true)
    subjects=$(git log --format=%s -- "$dir" || true)
  fi

  if [ -z "$subjects" ]; then
    continue
  fi

  bump="patch"
  if echo "$log" | grep -q "BREAKING CHANGE"; then
    bump="major"
  fi
  if echo "$subjects" | grep -Eq '^[a-zA-Z]+(\([^)]+\))?!:'; then
    bump="major"
  fi
  if [ "$bump" != "major" ]; then
    if echo "$subjects" | grep -Eq '^feat(\([^)]+\))?:'; then
      bump="minor"
    elif echo "$subjects" | grep -Eq '^(fix|perf)(\([^)]+\))?:'; then
      bump="patch"
    fi
  fi

  IFS='.' read -r major minor patch <<EOF
$version
EOF
  case "$bump" in
    major) major=$((major+1)); minor=0; patch=0 ;;
    minor) minor=$((minor+1)); patch=0 ;;
    patch) patch=$((patch+1)) ;;
  esac
  new_version="${major}.${minor}.${patch}"

  perl -0pi -e "s/^version:\\s*.*/version: ${new_version}/m" "$chart_file"

  changelog="$dir/CHANGELOG.md"
  date=$(date -u +%Y-%m-%d)
  section="## ${new_version} - ${date}\n"
  bullets=$(printf "%s\n" "$subjects" | sed '/^$/d' | sed 's/^/- /')
  content="${section}${bullets}\n"

  if [ -f "$changelog" ]; then
    if [ "$(head -n 1 "$changelog")" = "# Changelog" ]; then
      { printf "# Changelog\n\n%s\n" "$content"; tail -n +2 "$changelog"; } > "${changelog}.tmp"
    else
      { printf "# Changelog\n\n%s\n" "$content"; cat "$changelog"; } > "${changelog}.tmp"
    fi
  else
    { printf "# Changelog\n\n%s\n" "$content"; } > "${changelog}.tmp"
  fi
  mv "${changelog}.tmp" "$changelog"

  echo "$dir" >> .changed-charts
  echo "${name}-${new_version}" >> .chart-tags
done

if [ ! -s .changed-charts ]; then
  echo "has_changes=false" >> "$output_file"
  exit 0
fi

echo "has_changes=true" >> "$output_file"
