# Vendored skills

One skill is checked in here, so an agent reading this repo gets the engine with no network clone
needed. It is a verbatim copy.

## scroll-world — MIT

- Source: https://github.com/oso95/scroll-world
- Path: `skills/scroll-world/`
- License: MIT, `Copyright (c) 2026 cyw` — `skills/scroll-world/LICENSE` is included.
- What matters here: `references/scrub-engine.js` (the portable vanilla-JS scrub engine),
  `references/index-template.html`, `references/pipeline.md`, `references/prompts.md`,
  `references/knockout.py`.

## Not vendored — scroll-cinematic

- Source: https://github.com/zubair-trabzada/scroll-cinematic-claude
- Upstream publishes **no LICENSE file**, so the default is all rights reserved. It is
  deliberately **not** redistributed here. Install it from upstream instead:

  ```bash
  bash install-skills.sh
  ```

  which clones it to `~/.claude/skills/scroll-cinematic` and skips anything already present.
- **Use only steps 0, 5, 6 and 7 of its `SKILL.md`.** Steps 2–4 are image/video generation against
  Higgsfield and are out of scope — see `DIRECTIVE.md` §2. The reusable parts are
  `templates/scroll-cinematic.js` (the engine plus `SCRUB_SECTIONS` config), `templates/index.html`,
  `templates/styles.css`, `templates/CinematicReveal.tsx`, `scripts/extract-frames.sh` and
  `scripts/compress-frames.sh`.
