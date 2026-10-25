#!/usr/bin/env bash
# Runs on the web server from a systemd timer. Pulls main from GitHub and, when it changed,
# rebuilds the site and publishes it. The server only reads a public repo: no deploy keys,
# and nothing in GitHub can log in to the server.
#
# Paths (override in the systemd unit's Environment= lines):
#   REPO_DIR  the clone of the repo
#   WEB_ROOT  the folder Caddy serves
#
# One-time setup, as root on the web server:
#   apt install -y git rsync && install Hugo 0.146+ from the official GitHub release .deb
#   useradd --system --no-create-home --shell /usr/sbin/nologin sitebuild
#   git clone https://github.com/OWNER/REPO.git /srv/thomaslawrence.com
#   mkdir -p /var/www/thomaslawrence/public
#   chown -R sitebuild:sitebuild /srv/thomaslawrence.com /var/www/thomaslawrence
#   cp /srv/thomaslawrence.com/deploy/server-pull/thomaslawrence-update.{service,timer} /etc/systemd/system/
#   systemctl daemon-reload && systemctl enable --now thomaslawrence-update.timer
set -euo pipefail

REPO_DIR="${REPO_DIR:-/srv/thomaslawrence.com}"
WEB_ROOT="${WEB_ROOT:-/var/www/thomaslawrence/public}"
BRANCH="${BRANCH:-main}"

cd "$REPO_DIR"
git fetch --quiet origin "$BRANCH"

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$BRANCH")
if [[ "$LOCAL" == "$REMOTE" && -s "$WEB_ROOT/index.html" && "${1:-}" != "--force" ]]; then
  exit 0
fi

git reset --quiet --hard "origin/$BRANCH"

BUILD=$(mktemp -d)
trap 'rm -rf "$BUILD"' EXIT
hugo --gc --minify --quiet --destination "$BUILD"

# Refuse to publish an obviously broken build
test -s "$BUILD/index.html"
grep -q "Tom Lawrence" "$BUILD/index.html"

rsync -a --delete "$BUILD/" "$WEB_ROOT/"
echo "Published $(git rev-parse --short HEAD): $(git log -1 --pretty=%s)"
