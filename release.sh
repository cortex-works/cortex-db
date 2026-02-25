#!/usr/bin/env bash
# =============================================================================
# release.sh — Local Release Script (macOS Apple Silicon) for cortex-db
# =============================================================================
set -euo pipefail
export CARGO_TERM_COLOR=always

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"

APP_NAME="cortex-db"
BIN_NAME="cortex_db"

if [[ -f "Cargo.toml" ]]; then
  VERSION=$(grep '^version' "Cargo.toml" | head -1 | cut -d '"' -f2)
else
  VERSION="0.1.0"
fi
TAG="v$VERSION"

pass()  { printf "\033[32m✅  %s\033[0m\n" "$*"; }
info()  { printf "\033[34m──  %s\033[0m\n" "$*"; }
warn()  { printf "\033[33m⚠️   %s\033[0m\n" "$*"; }
banner(){ printf "\n\033[1;36m=== %s ===\033[0m\n" "$*"; }
die()   { printf "\033[31m❌  %s\033[0m\n" "$*" >&2; exit 1; }

extract_unreleased_notes() {
  awk '/^## \[Unreleased\][[:space:]]*$/ {in_unreleased=1; next} /^## \[/ {if (in_unreleased) exit} {if (in_unreleased) print}' CHANGELOG.md 2>/dev/null || true
}

repo_slug() {
  local origin="$(git remote get-url origin 2>/dev/null || true)"
  [[ -n "$origin" ]] || return 1
  origin="${origin%.git}"; origin="${origin#https://github.com/}"; origin="${origin#git@github.com:}"
  printf '%s' "$origin"
}

banner "$APP_NAME $TAG — Local Release"

if [[ ! -f "Cargo.toml" ]]; then
  warn "Cargo.toml not found. Skipping build logic. Only useful for tags currently."
else
  for cmd in cargo gh; do
    if ! command -v "$cmd" &>/dev/null; then die "Missing: $cmd"; fi
  done
fi

if ! $DRY_RUN; then
  [[ -z "$(git status --porcelain)" ]] || die "Working tree dirty. Commit first."
fi

REPO_SLUG="$(repo_slug || true)"
[[ -n "$REPO_SLUG" ]] || warn "Could not parse GitHub repo"
info "GitHub Repo: $REPO_SLUG"

UNRELEASED_NOTES="$(extract_unreleased_notes | sed -e 's/[[:space:]]\+$//')"
if [[ -z "${UNRELEASED_NOTES//[[:space:]]/}" ]]; then
  RELEASE_NOTES="Built locally from macOS (Apple Silicon)."
else
  RELEASE_NOTES="$(printf "## Release Notes\n\n%s\n\n---\n\nBuilt locally from macOS." "$UNRELEASED_NOTES")"
fi

if $DRY_RUN; then warn "Dry-run complete."; exit 0; fi

banner "Uploading GitHub Release"
gh release delete "$TAG" --repo "$REPO_SLUG" --yes 2>/dev/null || true
NOTES_FILE="$(mktemp)"
printf "%s\n" "$RELEASE_NOTES" > "$NOTES_FILE"
gh release create "$TAG" --title "$APP_NAME $TAG" --notes-file "$NOTES_FILE" --repo "$REPO_SLUG"
rm -f "$NOTES_FILE" || true
pass "Release $TAG live!"
