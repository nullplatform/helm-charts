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
  repo_url="https://github.com/nullplatform/helm-charts"

  # Build compare URL for version header
  if [ -n "$last_tag" ]; then
    prev_version="${last_tag#${name}-}"
    version_header="## [${new_version}](${repo_url}/compare/${name}-${prev_version}...${name}-${new_version}) (${date})"
  else
    version_header="## [${new_version}](${repo_url}/releases/tag/${name}-${new_version}) (${date})"
  fi

  # Get commits with hash, subject for this chart
  if [ -n "$range" ]; then
    commits=$(git log "$range" --format="%H %s" -- "$dir" || true)
  else
    commits=$(git log --format="%H %s" -- "$dir" || true)
  fi

  # Initialize sections
  breaking_changes=""
  features=""
  fixes=""
  perf=""
  reverts=""
  other=""

  # Parse each commit and categorize
  while IFS= read -r line; do
    [ -z "$line" ] && continue

    hash=$(echo "$line" | cut -d' ' -f1)
    short_hash="${hash:0:7}"
    subject=$(echo "$line" | cut -d' ' -f2-)

    # Check for breaking change indicator
    is_breaking=""
    if echo "$subject" | grep -Eq '^[a-zA-Z]+(\([^)]+\))?!:'; then
      is_breaking="true"
    fi

    # Parse conventional commit: type(scope): message or type: message
    if echo "$subject" | grep -Eq '^[a-zA-Z]+(\([^)]+\))?!?:'; then
      type=$(echo "$subject" | sed -E 's/^([a-zA-Z]+)(\([^)]+\))?!?:.*/\1/')
      scope=$(echo "$subject" | sed -E 's/^[a-zA-Z]+(\(([^)]+)\))?!?:.*/\2/')
      message=$(echo "$subject" | sed -E 's/^[a-zA-Z]+(\([^)]+\))?!?:[[:space:]]*//')
    else
      type="other"
      scope=""
      message="$subject"
    fi

    # Format the entry
    if [ -n "$scope" ]; then
      entry="* **${scope}:** ${message} ([${short_hash}](${repo_url}/commit/${hash}))"
    else
      entry="* ${message} ([${short_hash}](${repo_url}/commit/${hash}))"
    fi

    # Categorize by type
    case "$type" in
      feat)
        features="${features}${entry}"$'\n'
        ;;
      fix)
        fixes="${fixes}${entry}"$'\n'
        ;;
      perf)
        perf="${perf}${entry}"$'\n'
        ;;
      revert)
        reverts="${reverts}${entry}"$'\n'
        ;;
      *)
        # Skip non-user-facing changes (chore, ci, docs, style, refactor, test)
        ;;
    esac

    # Add to breaking changes if applicable
    if [ -n "$is_breaking" ]; then
      breaking_changes="${breaking_changes}${entry}"$'\n'
    fi
  done <<< "$commits"

  # Build the changelog content
  content="${version_header}"$'\n\n'

  if [ -n "$breaking_changes" ]; then
    content="${content}"$'\n'"### BREAKING CHANGES"$'\n\n'"${breaking_changes}"
  fi

  if [ -n "$features" ]; then
    content="${content}"$'\n'"### Features"$'\n\n'"${features}"
  fi

  if [ -n "$fixes" ]; then
    content="${content}"$'\n'"### Bug Fixes"$'\n\n'"${fixes}"
  fi

  if [ -n "$perf" ]; then
    content="${content}"$'\n'"### Performance Improvements"$'\n\n'"${perf}"
  fi

  if [ -n "$reverts" ]; then
    content="${content}"$'\n'"### Reverts"$'\n\n'"${reverts}"
  fi

  # Write changelog
  if [ -f "$changelog" ]; then
    if [ "$(head -n 1 "$changelog")" = "# Changelog" ]; then
      { printf "# Changelog\n\n%s" "$content"; tail -n +2 "$changelog"; } > "${changelog}.tmp"
    else
      { printf "# Changelog\n\n%s\n" "$content"; cat "$changelog"; } > "${changelog}.tmp"
    fi
  else
    { printf "# Changelog\n\n%s" "$content"; } > "${changelog}.tmp"
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
