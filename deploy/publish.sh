#!/usr/bin/env bash
# Run from the deploy machine (Tom's LXC container). Pulls main from GitHub, builds,
# checks the build, and rsyncs it to the web server.
# Usage: deploy/publish.sh [--dry-run]
#
# Expects the SSH host alias "lsweb" in ~/.ssh/config (the same one used for lawrencesystems.com).
# Override the target with PUBLISH_REMOTE if the folder differs.
set -euo pipefail

cd "$(dirname "$0")/.."
REMOTE="${PUBLISH_REMOTE:-lsweb:/var/www/thomaslawrence/public/}"
DRY=""
[[ "${1:-}" == "--dry-run" ]] && DRY="--dry-run"

# Publish exactly what is on GitHub's main branch, never local edits
if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: uncommitted changes in $(pwd). Publish only what is merged to main on GitHub." >&2
  exit 1
fi
git fetch --quiet origin main
git checkout --quiet main
git reset --quiet --hard origin/main

hugo --gc --minify --cleanDestinationDir

test -s public/index.html
grep -q "Tom Lawrence" public/index.html

rsync -az --delete --checksum $DRY public/ "$REMOTE"
echo "Published $(git rev-parse --short HEAD) ($(git log -1 --pretty=%s)) to $REMOTE${DRY:+ (dry run)}"
