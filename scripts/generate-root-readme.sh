#!/usr/bin/env sh
set -e

tmp_file="$(mktemp)"

cat > "$tmp_file" <<'EOF'
<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    Helm Charts Repository
    <br>
</h2>

Welcome to the Helm Charts repository for nullplatform. This repository hosts packaged Helm charts and serves them via GitHub Pages.

## Charts

This repository contains the following charts:

| Chart | Description | Version |
|------|-------------|---------|
EOF

list_charts() {
  for chart in charts/*/Chart.yaml; do
    name=$(awk -F': *' '$1=="name"{print $2; exit}' "$chart")
    version=$(awk -F': *' '$1=="version"{print $2; exit}' "$chart")
    desc=$(awk '
      /^description:/ {
        sub(/^description:[[:space:]]*/, "", $0)
        if ($0 != "" && $0 != ">-" && $0 != ">") {
          print $0
          exit
        }
        in_desc = 1
        next
      }
      in_desc {
        if ($0 ~ /^[^[:space:]]/) {
          exit
        }
        sub(/^[[:space:]]+/, "", $0)
        if (line == "") {
          line = $0
        } else {
          line = line " " $0
        }
      }
      END {
        if (line != "") {
          print line
        }
      }
    ' "$chart")
    printf "%s\t%s\t%s\n" "$name" "$desc" "$version"
  done
}

list_charts | sort | while IFS=$'\t' read -r name desc version; do
  printf "| %s | %s | %s |\n" "$name" "$desc" "$version" >> "$tmp_file"
done

cat >> "$tmp_file" <<'EOF'

## How to Use This Repository

### 1. Add Helm Repository

```bash
helm repo add nullplatform https://nullplatform.github.io/helm-charts
helm repo update
```

### 2. Search Charts in the Repository

```bash
helm search repo nullplatform
```

### 3. Install a Helm Chart

```bash
helm install <release-name> nullplatform/<chart-name> --version <chart-version>
```

### 4. Upgrade a Helm Chart

```bash
helm upgrade <release-name> nullplatform/<chart-name> --version <new-chart-version>
```

### 5. Remove a Helm Release

```bash
helm uninstall <release-name>
```

## Conventions

### Branch naming

Accepted formats:
- feature/<kebab-case>
- bugfix/<kebab-case>
- hotfix/<kebab-case>
- chore/<kebab-case>
- release/x.y.z

### Commit messages

This repository uses Conventional Commits.

Examples:
- feat: add autoscaling values
- fix: correct service name
- chore: update docs

## Tooling

Install yamllint for local YAML validation:

```bash
pip install yamllint
```
EOF

mv "$tmp_file" README.md
