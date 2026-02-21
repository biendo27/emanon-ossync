#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_ROOT="$ROOT/templates/personal-data"

ensure_file() {
  local rel="$1"
  local dst="$ROOT/$rel"
  local src="$TEMPLATE_ROOT/$rel"

  if [[ -f "$dst" ]]; then
    return 0
  fi
  [[ -f "$src" ]] || {
    echo "missing required baseline template: $src" >&2
    exit 1
  }
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "seeded: $rel"
}

ensure_dir() {
  local rel="$1"
  mkdir -p "$ROOT/$rel"
}

ensure_file ".ossetup-workspace.json"
ensure_file "manifests/profiles/default.yaml"
ensure_file "manifests/layers/core.yaml"
ensure_file "manifests/layers/targets/linux-debian.yaml"
ensure_file "manifests/dotfiles.yaml"
ensure_file "manifests/secrets.yaml"

ensure_dir "manifests/layers/users"
ensure_dir "manifests/layers/hosts"
ensure_dir "manifests/state/linux-debian"
ensure_dir "hooks/pre-install.d"
ensure_dir "hooks/post-install.d"
ensure_dir "dotfiles"
ensure_dir "functions"

if [[ -f "$ROOT/.ossetup-workspace.json" ]]; then
  mode="$(jq -r '.mode // empty' "$ROOT/.ossetup-workspace.json" 2>/dev/null || true)"
  if [[ "$mode" == "personal-overrides" ]]; then
    jq '.mode = "personal-only"' "$ROOT/.ossetup-workspace.json" > "$ROOT/.ossetup-workspace.json.tmp"
    mv "$ROOT/.ossetup-workspace.json.tmp" "$ROOT/.ossetup-workspace.json"
    echo "normalized workspace mode: personal-overrides -> personal-only"
  fi
fi

echo "personal data initialized"
