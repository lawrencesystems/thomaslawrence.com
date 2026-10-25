# thomaslawrence.com

Tom Lawrence's personal site: the homepage overview, a full history with sources (/history/), and his shows, talks, and guest appearances (/appearances/). The look borrows from early-1980s home computing: woodgrain, green-screen BASIC, pixel art. Built with [Hugo](https://gohugo.io/). Everything here is public.

## Edit the site

Almost every change is a data file. No HTML needed.

| What | File |
| --- | --- |
| Intro text, the line under the name, and the green screen's BASIC program | `content/_index.md` |
| The early years (homepage and top of /history/) | `data/history.yaml` |
| 2003 to today, with source links (/history/) | `data/timeline.yaml` |
| Shows hosted and guest appearances (/appearances/) | `data/appearances.yaml` |
| Channel and forum numbers, with their "as of" date | `data/stats.yaml` |
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

1. Changes go on a branch and arrive as a pull request on GitHub.
2. Tom reviews and merges to `main`.
3. Tom asks the Claude in his LXC container to publish. It runs `deploy/publish.sh`, which pulls `main`, builds, checks the build, and rsyncs it to the web server.

```bash
deploy/publish.sh --dry-run   # show what would change on the server
deploy/publish.sh             # publish
```

`publish.sh` refuses to run with uncommitted local changes, so the live site always matches `main` on GitHub. It uses the same `lsweb` SSH alias as the Lawrence Systems deploy and writes to `/var/www/thomaslawrence/public/` (override with `PUBLISH_REMOTE`).

Protect `main` in GitHub (Settings, Branches) so nothing lands on it without a pull request.

## Web server

Add the blocks in `deploy/Caddyfile` to `/etc/caddy/Caddyfile` (replacing the placeholder site), create `/var/www/thomaslawrence/public` owned by the deploy user, and run `systemctl reload caddy`.

## Optional: let the server pull by itself

`deploy/server-pull/` has a script and a systemd timer that make the web server check GitHub every five minutes and publish `main` on its own, with no LXC step. Setup steps are at the top of `deploy/server-pull/update.sh`. Use one method or the other, not both.
