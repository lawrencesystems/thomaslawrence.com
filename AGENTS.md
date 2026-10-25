# Notes for agents working on this repo

Tom Lawrence's personal site. Read README.md first.

## Rules

- Never push to `main`. Work on a branch and open a pull request; merging to `main` publishes the site.
- This repo is public. Never commit anything private: no client names, booking links, private email addresses, tokens, or server details beyond what is already here.
- Do not invent facts or copy in Tom's voice. Talks, dates, roles, numbers, and bios come from Tom. If something is missing, ask or leave it out.
- Keep the page face-free unless Tom sets `params.headshot`.
- Pixel art in `data/sprites.yaml` must be original. Do not draw logos, mascots, game characters, or copy box or cartridge art from Atari, Tandy, or anyone else. Generic objects (a joystick, a TV, a cassette) are fine.
- Huntress work is listed as Tom's role. Do not describe Huntress products or make claims on Huntress's behalf.
- Run `hugo --gc --minify` before opening a pull request; it must finish with no errors or warnings.

## Writing

- No em dashes. Use commas, colons, or a new sentence.
- Plain, direct sentences. No hype.
- Homepage copy is first person. Speaker bios are third person.
- State facts, not verdicts. Numbers, dates, and names of projects or events are fine; adjectives about Tom ("expert", "practical", "renowned") are not.
- No comparisons that imply others do worse ("the tools I actually use", "explained by someone who runs it").
- Put credentials where the reader needs them: bios and role descriptions. The opening lines say what Tom does, not how good he is at it.
