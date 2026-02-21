#!/usr/bin/env bash
set -euo pipefail

PERSONAL_REPO_URL="${OSSETUP_PERSONAL_REPO_URL:-https://github.com/biendo27/emanon-ossync.git}"
PERSONAL_REPO_REF="${OSSETUP_PERSONAL_REPO_REF:-main}"
PERSONAL_DIR="${OSSETUP_PERSONAL_DIR:-$HOME/.local/share/emanon-ossync}"

PROFILE="${OSSETUP_PROFILE:-default}"
TARGET="${OSSETUP_TARGET:-auto}"
HOST="${OSSETUP_HOST:-auto}"

mkdir -p "$(dirname "$PERSONAL_DIR")"

if [[ -d "$PERSONAL_DIR/.git" ]]; then
  git -C "$PERSONAL_DIR" fetch --depth 1 origin "$PERSONAL_REPO_REF"
  git -C "$PERSONAL_DIR" checkout -f FETCH_HEAD
else
  git clone --depth 1 --branch "$PERSONAL_REPO_REF" "$PERSONAL_REPO_URL" "$PERSONAL_DIR"
fi

workspace="$PERSONAL_DIR/.ossetup-workspace.json"
if [[ ! -f "$workspace" ]]; then
  echo "workspace config missing: $workspace" >&2
  exit 1
fi

command -v jq >/dev/null 2>&1 || { echo "missing dependency: jq" >&2; exit 1; }

core_url_override="${OSSETUP_CORE_REPO_URL:-}"
core_ref_override="${OSSETUP_CORE_REPO_REF:-}"

core_url="${core_url_override:-$(jq -r '.core_repo_url // empty' "$workspace")}"
core_ref="${core_ref_override:-$(jq -r '.core_repo_ref // "main"' "$workspace")}"
core_rel="$(jq -r '.core_repo_path // empty' "$workspace")"

if [[ -z "$core_url" || -z "$core_rel" ]]; then
  echo "invalid workspace config (core_repo_url/core_repo_path required): $workspace" >&2
  exit 1
fi

core_dir="$PERSONAL_DIR/$core_rel"
mkdir -p "$(dirname "$core_dir")"

if [[ -d "$core_dir/.git" ]]; then
  git -C "$core_dir" fetch --depth 1 origin "$core_ref"
  git -C "$core_dir" checkout -f FETCH_HEAD
else
  git clone --depth 1 --branch "$core_ref" "$core_url" "$core_dir"
fi

cd "$PERSONAL_DIR"
exec "$core_dir/bin/ossetup" install --profile "$PROFILE" --target "$TARGET" --host "$HOST"
