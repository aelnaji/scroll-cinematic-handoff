# Scroll / 3D-scroll agent skills — ranked, with install commands

Every entry below was pulled live from the GitHub API on **4 October 2026** — star counts are
verified, and each repo was probed to confirm it actually ships a skill or plugin
(`SKILL.md`, a `skills/` dir, a `.claude-plugin/` manifest). Star counts drift; re-check with
`gh api repos/<owner>/<repo> --jq .stargazers_count` before quoting them.

## Read this first — the signal is weak

This niche has almost no rating signal. Above roughly 130 stars the ranking means something;
below it, most repos are clones of #1. At one point the candidate set contained six
near-identical "fly through the world" repos sitting at 0–1 stars. One repo has 1,079 forks,
which is where most of those clones came from. Do not treat a low star count as a bad skill or
a high one as a good fit — use the tiers below, which are about fit for *this* job.

## Agent instructions

1. Install **Tier A only**. Verify each install by running it and pasting the real command
   output. If an install fails, report the failure — do not substitute a repo you found
   yourself.
2. **Tier B is read-only.** Clone nothing into `~/.claude/skills`. If you want to read one,
   `git clone --depth 1` into a temp folder, read it, delete it, and cite what you took.
3. **Tier C must not be installed.** Those depend on paid image/video generation, which is
   excluded by `DIRECTIVE.md` §2.
4. After installing, report: what is now in `~/.claude/skills`, what each skill is for, and
   which one you are actually going to use for the engine — with a reason. Do not install
   something and then ignore it.

---

## Vendored in this repo — no install needed

| Skill | Stars | Where |
|---|---|---|
| `oso95/scroll-world` | 9,690 | `skills/scroll-world/` — MIT, licence included |

Start from `skills/scroll-world/references/scrub-engine.js`. It is the origin of most of this
niche and the highest-rated thing in it.

## Install from upstream — not vendored

| Skill | Stars | Install |
|---|---|---|
| `zubair-trabzada/scroll-cinematic-claude` | 65 | `bash install-skills.sh` — or `git clone https://github.com/zubair-trabzada/scroll-cinematic-claude.git ~/.claude/skills/scroll-cinematic` |

That repo publishes **no LICENSE file**, so it is not vendored here — pull it from upstream. Use
only steps 0, 5, 6, 7 of its `SKILL.md`; steps 2–4 are image/video generation and are excluded
by `DIRECTIVE.md` §2. What you want from it: `scripts/extract-frames.sh`,
`scripts/compress-frames.sh`, `templates/scroll-cinematic.js` and `templates/index.html`.

`install-skills.sh` installs both skills and skips anything already present.

---

## Tier A — install these

### 1. `nateherkai/scroll-craft` — 2,943 stars
Premium, immersive, scroll-driven sites as a real Claude Code plugin. The only credible
alternative to `scroll-world`, and the one that cares about typography and restraint rather
than only the scroll effect — it explicitly targets the two failure modes of AI-generated
sites: forgettable, or flashy scroll wrapped around 2.1:1 body text and a six-line headline
on a phone. Relevant to us because the hero has to sit under real content.

```
/plugin marketplace add nateherkai/scroll-craft
/plugin install nateherk-design
```
If it prints `Run /reload-plugins to activate.`, run that.

### 2. `musoyangrigor/scroll-video-website-skill` — 52 stars
Video → scroll-controlled canvas with **WebP frames and progressive loading**. The cleanest
frame-loading implementation in the list, and directly relevant to our problem: the existing
strips are 80 frames at 49 MB and 55 MB. Read its loading strategy before compressing ours.

```
npx skills add musoyangrigor/scroll-video-website-skill --skill scroll-video-website
```

### 3. `199-biotechnologies/motion-dev-animations-skill` — 101 stars
Motion.dev skill — 120fps animation, spring physics, scroll effects, gestures. Take this if
the overlay copy and section reveals end up feeling mechanical. Optional, not required.

```
git clone https://github.com/199-biotechnologies/motion-dev-animations-skill.git ~/.claude/skills/motion-dev-animations
```

---

## Tier B — reference only, do not install

| Repo | Stars | Why look at it |
|---|---|---|
| `amirmushichge/cinematic-scroll-prompt-kit` | 215 | The highest-rated *prompt* system for cinematic 2.5D sites — same idea as the Komputer Mechanic prompt pack, better rated. Read its brief structure. |
| `tsogjavklann/awwwards-3d` | 24 | Three.js r170 + GSAP + Lenis, `SKILL.md` at root. Reference for a true-3D variant if the canvas scrub is not enough. |
| `zyliu0/3d-frontend` | 17 | Scroll-driven 3D sites, GSAP + ScrollTrigger over CDN, single-file HTML output. No `SKILL.md` — clone and read. |
| `ElixIsmael/elix-scroll-3d` | 9 | Scroll-driven 3D that is explicitly built to stay fast, indexable and usable — useful on the accessibility/seo side. |
| `MustBeSimo/web-design-studio` | 39 | 28 live examples plus accessible fallbacks. Read the fallbacks, not the install. |
| `iotron/gsap-cookbook` | 9 | Production GSAP recipes — plain scroll, text, SVG, canvas. A reference, not a skill. |
| `gongnyang/awesome-html-scrolline-deck` | 28 | Scroll-driven HTML decks rather than sites. Different output shape, same engine class; its CLI is npm-based so it does not fit our no-build rule. |

---

## Tier C — do not install (generation-dependent)

These need paid image/video generation, which `DIRECTIVE.md` §2 excludes. Their *engine* code
is still readable if you clone one read-only into a temp folder and take nothing but the
scrub logic.

| Repo | Stars | Dependency |
|---|---|---|
| `AIwithhassan/lets-scroll` | 129 | AI-generated scenes and camera flights |
| `medhachoum/cinematic-landing-kit` | 64 | Higgsfield pipeline |

`MustBeSimo/web-design-studio` and `amirmushichge/cinematic-scroll-prompt-kit` also generate
assets, but their non-generation parts are worth reading — they are listed under Tier B for
that reason, with the dependency noted.

---

## Not skills — excluded from the ranking

Listed so nobody re-derives this the hard way:

- `scenario-labs/skills` (871) — 3D/image/video/audio asset generation over MCP. High stars,
  wrong category.
- `meshy-dev/meshy-3d-agent` (96), `thrixel/build-world` (95) — 3D asset generators.
- `no1msd/seance` (135) — a scrolling terminal multiplexer. Matched on the word "scroll".
- `orwa-mahmoud/nightshift` (72) — long-running agent autonomy tooling.

---

## If a skill in Tier A misbehaves

- `/plugin install` does nothing → restart Claude Code, then `/reload-plugins`.
- `npx skills add` fails → it needs Node; if Node is unavailable, clone the skill folder out of
  the repo directly into `~/.claude/skills/` and say so in your report.
- A skill's own install script writes to a path outside `~/.claude/skills` → stop and ask.
  Never let a third-party installer touch the site repo.
