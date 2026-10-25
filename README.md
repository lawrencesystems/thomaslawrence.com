# thomaslawrence.com

Tom Lawrence's personal site: where it started, what he works on, talks, a speaker kit for event organizers, and links. The look borrows from early-1980s home computing: woodgrain, green-screen BASIC, pixel art. One page, built with [Hugo](https://gohugo.io/). Everything here is public.

## Edit the site

Almost every change is a data file. No HTML needed.

| What | File |
| --- | --- |
| Intro text, the line under the name, and the green screen's BASIC program | `content/_index.md` |
| The early years ("Where it started") | `data/history.yaml` |
| Pixel art | `data/sprites.yaml`, one character per pixel |
| Current roles (Lawrence Systems, Huntress, shows) | `data/roles.yaml` |
| Talks and speaking topics | `data/speaking.yaml` |
| Short and long speaker bios | `data/bios.yaml` |
| "Find me" links | `data/links.yaml` |
| Speaking contact email, optional headshot | `hugo.yaml` (`params.contactEmail`, `params.headshot`) |
| Share image | `assets/og/og.png` (1200x630) |
| Layout and styles | `layouts/`, `assets/css/site.css` |

Preview locally with `hugo server`, then open http://localhost:1313. Hugo 0.146 or newer; the standard edition is enough.

Fonts are self-hosted from Google Fonts (Silkscreen, VT323, Atkinson Hyperlegible), so pages make no third-party requests.

## Workflow

1. Changes go on a branch and arrive as a pull request.
2. Tom reviews and merges to `main`.
3. Within five minutes the web server pulls `main`, builds, and publishes.

Merging to `main` is publishing. Protect the branch in GitHub (Settings, Branches) so nothing lands on it without a pull request.

## How deploys work

The server pulls; GitHub never pushes. A systemd timer on the web server runs `deploy/update.sh` every five minutes. It fetches `main`, and only if something changed, builds the site into a temporary folder, checks the build, and rsyncs it into the folder Caddy serves. The repo is public, so the server needs no credentials, and there is no deploy key in GitHub that could reach the server.

### One-time server setup

Run as root on the web server (Debian or Ubuntu with Caddy already installed):

```bash
# Hugo from the official release (distro packages are too old), plus git and rsync
apt install -y git rsync
curl -fsSLO https://github.com/gohugoio/hugo/releases/download/v0.152.2/hugo_0.152.2_linux-amd64.deb
dpkg -i hugo_0.152.2_linux-amd64.deb && hugo version

# A user that can only build this site
useradd --system --no-create-home --shell /usr/sbin/nologin sitebuild
git clone https://github.com/OWNER/REPO.git /srv/thomaslawrence.com
mkdir -p /var/www/thomaslawrence/public
chown -R sitebuild:sitebuild /srv/thomaslawrence.com /var/www/thomaslawrence

# The timer
cp /srv/thomaslawrence.com/deploy/thomaslawrence-update.{service,timer} /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now thomaslawrence-update.timer
systemctl start thomaslawrence-update.service      # first build now
journalctl -u thomaslawrence-update.service -n 20   # should end with "Published ..."
```

Then add the blocks in `deploy/Caddyfile` to `/etc/caddy/Caddyfile` (replacing the placeholder site) and run `systemctl reload caddy`.

Changes to the systemd units in this repo are not picked up automatically. Copy them again and run `systemctl daemon-reload`.

To force a rebuild: `systemctl start thomaslawrence-update.service`, or run `deploy/update.sh --force` as `sitebuild`.
