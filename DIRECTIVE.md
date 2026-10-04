# DIRECTIVE — scroll-driven cinematic hero: requirements

**You own this end to end.** This document is the complete brief. Everything you need to decide,
build and prove is here or reachable from here. Nothing in it requires the owner to answer
questions, approve steps, or relay instructions.

Source of the technique: Komputer Mechanic — "How to Build $10,000 3D Animated Websites With
Claude Code" (https://www.youtube.com/watch?v=mFgRGSOGNPM). The generation steps of that
tutorial are removed here; see §2.

---

## 0. HOW YOU OPERATE

### Autonomy
Work straight through, phase by phase, without stopping for approval. Do not ask the owner to
paste, confirm or choose anything this document already decides.

### The only three reasons to contact the owner
1. An action would cost money.
2. A change would land outside the working repository and `~/.claude/skills/`.
3. You are genuinely blocked — after **three distinct attempts**, each with real output.

Everything else: decide, do it, document it in the final report. "Waiting for confirmation" is
not a reason for an unfinished job — the confirmation is this document.

### Escalation format
One message, no preamble:
```
BLOCKED: <the single thing that cannot proceed>
Tried: <attempt 1 + real output> / <attempt 2 + real output> / <attempt 3 + real output>
Decision needed: <one question, with the options you see>
Continuing meanwhile with: <what you are doing that is not blocked>
```
Never send two of these without doing the unblocked work first.

### Honesty rules
- Real command output only. Never summarise output you did not run.
- Never mark a criterion PASS that you did not measure. Attach the measurement.
- Never narrate intention ("I will now…"). Do the thing, then report the result.
- If something is broken at the end, say so in one line with the next step. An honest blocker is
  a finished job; a false "done" is not.

## 1. SCOPE

Make the existing hero **scroll-scrubbed and cinematic** using the assets already in this
repository. Then carry the same treatment to the other cinematic sections, and finish the
loading, mobile and reduced-motion behaviour.

Out of scope: redesign, rebuild, new sections, new pages, new branding, new visual assets,
touching approved copy or imagery.

## 2. EXCLUSIONS — hard

- **No image or video generation. No Higgsfield. No generation MCP. No paid API calls.** Every
  visual already exists in the repo. Where third-party material names a generation model, read it
  as *"use the existing asset at this path"*.
- **No build step for the site.** No npm, no Node, no bundler, no Python process in the page
  pipeline. Plain HTML + CSS + JS served as static files. Installing a *skill* into
  `~/.claude/skills/` is fine — that is tooling, not the site.
- No frameworks, no CDN added for this work.
- No writes outside the working repository and `~/.claude/skills/`.
- Backup before every change: copy the files you are about to modify into
  `backups/<timestamp>/` inside the project, then edit.

## 3. THE EFFECT — what you are actually building

Not Three.js. Not a live 3D scene. It is a **canvas image-sequence scrub**:

> a short cinematic clip is pre-exported to a numbered strip of JPEGs; all frames are preloaded;
> the frame drawn to a `<canvas>` is chosen from scroll progress. Scrolling forward plays the
> strip forward, scrolling back plays it backward. Floating overlay copy completes the illusion.

The "3D" lives entirely in the source footage. Nothing is rendered at runtime.

## 4. ENGINE CONTRACT — implement exactly this

Deviate only if you record the deviation and its justification in the final report.

| # | Rule |
|---|---|
| C1 | Progress comes from the hero scene's own rect, never the document: `progress = clamp((-rect.top) / (rect.height - innerHeight), 0, 1)` |
| C2 | Scene height = scrub distance + 100vh. The pinned stage eats one viewport, so real scrub length is `sceneHeight − 100vh`. Apply any speed multiplier to the **scrub distance**, then add 100vh back. Never multiply the scene height. Best-practice band: 200–500vh of scroll per scene |
| C3 | `position: sticky; top: 0; height: 100vh` inner stage inside a tall outer scene |
| C4 | Cover-fit canvas draw; `devicePixelRatio` capped at 2 |
| C5 | Damped follow: `smooth += (target - smooth) * 0.14` each frame. Settles in ~1s, steps 1–2 frame indices per frame |
| C6 | If the rAF loop stops when settled it **must be re-kicked from the scroll handler**, or the film freezes after its first settle. Symptom: target updates, smooth stays pinned |
| C7 | Preload every frame, paint frame 0 immediately, redraw only when the frame index changes |
| C8 | Frame budget: ≤1600px wide, JPEG q88, 80–180 frames, **≤15 MB per section** |
| C9 | Parks at progress 1 and stops consuming scroll. Scrolling back reverses exactly to frame 0 |
| C10 | `IntersectionObserver` gating: no rAF work while the section is off-screen |
| C11 | Loading curtain ~2–3s with visible progress, so frame 0 never pops in mid-page |
| C12 | `prefers-reduced-motion: reduce` → a single static hero frame, no scrub |
| C13 | Narrow viewports shrink the stage rather than re-cropping the footage |
| C14 | Continuous source motion only. No hard cuts anywhere in the strip — a cut looks broken when scrubbed backwards |

Page sizing rule: 1920x1080 is the **comparison screenshot** size only, never the page's size.
Build with relative units so the page fills any window — no fixed pixel page width or height, no
horizontal scroll.

## 5. THE FAILURE THIS JOB EXISTS TO FIX

If any of these reappear the job has failed, however good it looks:

1. Progress derived from the whole page (`scrollY / documentHeight`) instead of the hero rect.
2. A fixed `z-index: 0` full-page background layer that keeps travelling after the section has
   scrolled past — the "extra layer, not a wire" symptom.
3. A render loop that never stops once the section is out of view.

## 6. ASSETS

**Target repository:** https://github.com/aelnaji/al-ryum-clone — the working scroll-3D branch
is `scroll-3d-cinematic` (the live-site baseline is `main`). Clone the branch, do not start from
`main`, or you will be rebuilding work that already exists.

Frame strips are already in the repository. **Locate them yourself and report the real numbers.**
Do not trust any figure written here, including these — measured on a copy of the project:

| Strip | Frames | Measured size | Verdict |
|---|---|---|---|
| `assets/projects/louvre/frames/` | 80 | ~8.7 MB | within budget |
| `assets/projects/warner-bros/frames/` | 80 | ~49 MB | over budget |
| `assets/projects/emirates/frames/` | 80 | ~55 MB | over budget |
| `assets/projects/warner-bros/frames-720p-backup/` | 80 | ~11 MB | **already within budget — use this** |
| `assets/projects/emirates/frames-720p-backup/` | 80 | ~10 MB | **already within budget — use this** |

The two 720p strips are the compressed versions and already satisfy C8. **Check for them before
compressing anything** — the budget problem may already be solved in the repo. Only re-encode if
they are missing or the visual quality is not good enough.

Source clips: `assets/cinematic-source/` (louvre-abu-dhabi, warner-bros, zayed-national-museum,
emirates-palace) plus `hero-garden.mp4`, `hero-mist.mp4`, `seamless-mist-loop.mp4`.

Verified on this machine: **ffmpeg 8.1.2** and **ffprobe** at `/usr/local/bin`.

- Re-slice: `ffmpeg -i <clip>.mp4 -vf "fps=10" -vsync 0 -q:v 3 frames/frame_%04d.jpg`
  (an 8s clip → 80 frames).
- Compress: `scripts/compress-frames.sh <frames-dir> 1600 88` from the scroll-cinematic skill
  (§7) after you install it.

80 frames is acceptable if the stride is even. If scrubbing visibly steps, re-slice at a higher
fps up to 180 frames — no further. More frames only buys load time.

## 7. SKILLS — what to install, what not to

Full landscape, tiers, star counts and install commands: **`SKILLS.md`**.

- **Install Tier A:** `scroll-craft` (plugin), `scroll-video-website-skill`, and optionally
  `motion-dev-animations-skill`. Verify each install with its real output.
- **Tier B is read-only.** Clone to a temp folder, read, cite, delete.
- **Never install Tier C** — they need paid generation (§2).
- `scroll-world` is vendored here at `skills/scroll-world/` (MIT, licence included). Its
  `references/scrub-engine.js` is the engine to start from. Read it before writing an engine.
- `scroll-cinematic` is **not** vendored. Install it from upstream: `bash install-skills.sh`
  (or the clone command in `SKILLS.md`). Use **only steps 0, 5, 6, 7** of its `SKILL.md` —
  steps 2–4 are generation and are excluded.
- After installing, state which skill you are actually using for the engine and why. Installing a
  skill and then ignoring it is not a plan.

## 8. WHERE TO GET HELP

Read these before escalating. Reading beats guessing.

| Need | Source |
|---|---|
| The scrub engine, working reference | `skills/scroll-world/references/scrub-engine.js` (448 lines) |
| Fly-through pipeline, mobile canvases, knockout | `skills/scroll-world/references/pipeline.md`, `prompts.md`, `knockout.py` |
| Frame slicing + compression recipes | `~/.claude/skills/scroll-cinematic/SKILL.md` steps 5–7, `scripts/extract-frames.sh`, `scripts/compress-frames.sh` |
| A multi-section scrub config example | `~/.claude/skills/scroll-cinematic/templates/scroll-cinematic.js` and `index.html` |
| ffmpeg filters | `ffmpeg -h filter=<name>`, `ffmpeg -filters`, the ffmpeg docs |
| `IntersectionObserver`, canvas, sticky, `clamp()` | MDN |
| Claude Code plugins, skills, subagents, hooks | `/help` in-session, plus the Claude Code docs |
| A skill's install failure | that skill's README and issues page |
| Motion and design judgement | `~/.claude/skills/taste-skill/`, `design/`, `design-system/`, and the subagents in §9 |

Browser tooling for verification: whatever headless Chrome/Chromium is already available
(Puppeteer, Playwright, or raw CDP). Run it outside the site — do not add a project dependency
to get it.

## 9. SUB-AGENTS

Reuse what exists in `~/.claude/agents/`: `web-designer`, `ui-designer`, `design-reviewer`,
`code-reviewer`, `nextjs-lead`, `a11y-auditor`.

Create what is missing:

| Agent | Owns | Does not |
|---|---|---|
| `scrub-engineer` | the scrub engine, height math, damping, preload, rAF lifecycle | touch copy, or any non-hero section |
| `frame-pipeline` | ffmpeg slicing, compression, frame naming, weight budget, loading curtain | change JS logic |
| `cinematic-reviewer` | fresh-eyes comparison of the live page against the approved hero; concrete diffs with locations; PASS/FAIL | fix anything, or pass anything it has not compared |
| `perf-budget-auditor` | frame weight, first paint, memory, rAF cost; fails the build over budget | approve "close enough" |

**Reviewer gate:** the developer loops against the reviewer and stops at the **first PASS** or
after **five rounds**, whichever comes first. Without the gate the reviewer always finds
something and the loop never closes. Five is the ceiling; two is acceptable on a tight budget.

Before sending a rough instruction to a sub-agent, rewrite it once for precision, then send the
polished version. It measurably improves their accuracy.

## 10. ASSUMPTIONS YOU ARE NOT ALLOWED TO MAKE

Each of these is a real way this job gets faked. They are prohibited shortcuts.

1. That the strips are within budget. **Measure them.**
2. That a headless screenshot proves the scrub works. Headless tooling blanks sticky canvases
   when scrolled — verify by **sampling canvas pixels at scroll positions**, and confirm once in
   a real browser.
3. That "the animation plays" means the contract is met. It must be **hero-bound and finite**:
   sample the progress values and show they come from the hero rect and park at 1.
4. That more frames means smoother. Past ~180 frames it means slower.
5. That `prefers-reduced-motion` on your own machine reflects the real audience. If your profile
   reports `reduce`, override the media feature for verification (devtools / CDP) instead of
   concluding the animation is broken — and still implement C12 properly.
6. That installing a skill is the same as using it.
7. That a passing build, an HTTP 200 or "no console errors" is evidence of anything.
8. That a section can be clipped without any risk of falling back to page-level progress.

## 11. DEFINITION OF DONE

Every line needs real output attached. Not a summary — the output.

| # | Criterion | How it is measured |
|---|---|---|
| D1 | Progress is hero-bound | the code path shown, plus sampled `target` and `smooth` across a scroll jump |
| D2 | Frame index changes across the scrub | canvas pixel samples at 3 progress points (start / middle / end), values differ |
| D3 | Reversible | the same points sampled scrolling back; indices return toward frame 0 |
| D4 | Parks at 1, no runaway | sampled values flat past the end of the hero; no movement after the section |
| D5 | No page-level progress anywhere | grep of the engine for document-height-based progress: zero hits |
| D6 | Weight | `du -sh` per strip, each ≤15 MB, with frame count and resolution reported |
| D7 | First interactive paint | measured and reported |
| D8 | Smoothing | `smooth` converges toward `target` over ~1s; frame counter steps 1–2 per sample, never 5+ |
| D9 | Reduced motion | a static frame with the media feature forced on — screenshot |
| D10 | Mobile | narrow-viewport screenshot, subject still framed |
| D11 | Off-screen cost | no rAF work while the section is out of view |
| D12 | Visual match | side-by-side screenshot of the live page against the approved hero, produced by you |
| D13 | Reviewer verdict | PASS, or five rounds with the outstanding diffs listed |

## 12. FINAL REPORT

One message, at the end, in this shape:

```
WHAT CHANGED
  <file>  <what changed>  <why>
  (one line per file, no summaries)

EVIDENCE
  D1  <raw output>
  D2  <raw output>
  ... through D13

ARTEFACTS
  screenshots: <absolute paths>
  strips: <path> <frames> <MB>

DEVIATIONS FROM THE CONTRACT
  <rule>  <what you did instead>  <why>          (or "none")

NOT DONE / BROKEN
  <item>  <state>  <next step>                    (or "none")

SKILLS USED
  <skill>  <what you took from it>
```

That report is the deliverable. Send it once, complete. The owner must not have to ask a
follow-up question to learn whether any single criterion passed.
