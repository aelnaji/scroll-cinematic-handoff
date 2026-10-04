# Vendored skills

Both skills are checked in here so an agent reading this repo needs no install step and no
network clone to get the engine and the pipeline scripts. They are verbatim copies.

## scroll-world — MIT

- Source: https://github.com/oso95/scroll-world
- Path: `skills/scroll-world/`
- License: MIT, `Copyright (c) 2026 cyw` — `skills/scroll-world/LICENSE` is included.
- What matters here: `references/scrub-engine.js` (the portable vanilla-JS scrub engine),
  `references/index-template.html`, `references/pipeline.md`, `references/prompts.md`.

## scroll-cinematic

- Source: https://github.com/zubair-trabzada/scroll-cinematic-claude
- Path: `skills/scroll-cinematic/`
- Pinned commit: `5f3cc0e65e474dab1d80ee3fda1e847f3552f708`
- **License: upstream publishes no LICENSE file**, so the default is all rights reserved.
  It is vendored here deliberately to make the handoff self-contained. Attribution and the
  pinned revision are recorded above; remove the folder and run `install-skills.sh` if you
  would rather pull it straight from upstream.
- **Use only steps 0, 5, 6 and 7 of its `SKILL.md`.** Steps 2–4 are image/video generation
  against Higgsfield and are explicitly out of scope for this build — see `DIRECTIVE.md` §2.
  The reusable parts are `templates/scroll-cinematic.js` (the engine + `SCRUB_SECTIONS`
  config), `templates/index.html`, `templates/styles.css`, `templates/CinematicReveal.tsx`
  and `scripts/extract-frames.sh` / `scripts/compress-frames.sh`.

## Installing them into an agent instead

`install-skills.sh` clones both into `~/.claude/skills/`, skipping anything already present
and fast-forwarding `scroll-cinematic` if it is a git checkout.
