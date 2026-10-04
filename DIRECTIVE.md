# DIRECTIVE — scroll-driven cinematic hero pass

Hand this file to Claude Code as the first message: `Read DIRECTIVE.md and PROMPTS.md in this repo, then wait for prompt 0.`

Source: Komputer Mechanic — "How to Build $10,000 3D Animated Websites With Claude Code"
(https://www.youtube.com/watch?v=mFgRGSOGNPM · tutorial: https://komputermechanic.com/tutorials/scroll-animation-website)

---

## 1. MISSION

The site is already built and approved. The only job is the **scroll-driven hero animation
("final touch")**, wired into the existing page.

Not in scope: redesign, rebuild, new sections, new pages, new branding, new visual assets.

| Item | Decision |
|---|---|
| Goal | Existing hero + project frame strips become a scroll-scrubbed cinematic that plays forward on scroll-down and reverses on scroll-up |
| Success criterion | At 3 different scroll positions the painted canvas frame index differs and progresses monotonically; scrolling back restores frame 0; the page parks and never runs away; verified side-by-side against the approved reference screenshot |
| Failure signals | Whole-page scroll coupling; animation continues past the hero; background layer keeps moving after the section; canvas blank on scroll; "it compiles / returns 200" presented as done |
| Starting point | **Reuse.** The frame strips, videos and existing approved CSS/JS stay. No regeneration of any asset. |
| Execution mode | Patch the existing engine in place, smallest correct fix, one section at a time |

## 2. HARD EXCLUSIONS

- **No Higgsfield. No MCP connector. No image or video generation of any kind.** Every visual already exists in the repo. If a prompt in `PROMPTS.md` names a generation model, treat it as *"use the existing asset at the given path"* instead.
- **No new runtime dependency in the site**: no npm install, no Node, no Python, no bundler. Plain HTML + CSS + JS, served as static files.
- No paid API calls, no credits spent.
- No touch to existing approved imagery or copy.
- Every change is backup-first (see §7).

## 3. GROUND TRUTH — WHAT THE EFFECT IS

The viral "3D scroll" effect is **not** Three.js and not a live 3D scene. It is a
**canvas image-sequence scrub**:

> a short cinematic clip is exported to ~180 numbered JPGs, all preloaded, and the frame
> drawn to a `<canvas>` is chosen by scroll progress. Scrolling forward/backward plays the
> clip. Add smooth (damped) scroll-linked overlay copy and it reads as premium 3D.

The "3D" comes entirely from the source footage. Nothing is rendered at runtime.

## 4. ENGINE CONTRACT — non-negotiable

Implement exactly this. Deviations must be called out and justified before coding.

1. **Hero-bound finite scrub.** Progress is computed from the hero scene's own rect, never
   from the document:
   `progress = clamp((-rect.top) / (rect.height - innerHeight), 0, 1)`
2. **Scene height = scrub distance + 100vh.** The pinned stage consumes one viewport, so the
   real scrub length is `sceneHeight − 100vh`. Best-practice band: 200–500vh of scroll per
   scene. Apply a speed multiplier to the *scrub distance*, then add 100vh back — never
   multiply the scene height itself.
3. **Sticky stage.** Outer scene tall; inner `position: sticky; top: 0; height: 100vh`.
4. **Cover-fit draw + HiDPI.** `devicePixelRatio` capped at 2.
5. **Damped follow.** Ease an intermediate value toward the raw target each frame:
   `smooth += (target - smooth) * 0.14`. Settles in ~1s; steps 1–2 frame indices per frame.
6. **rAF re-kick.** If the rAF loop stops when settled it must be restarted from the scroll
   handler, or the film freezes after its first settle. Symptom: target updates, smooth
   stays pinned, frame never advances.
7. **Redraw only on frame-index change.** Preload every frame; paint frame 0 immediately.
8. **Frame budget:** ≤ 1600px wide, q88 JPEG, ~180 frames, < ~15 MB per section.
9. **Parks at 1, restores at 0.** At `progress >= 1` the film holds its last frame and stops
   consuming scroll; scrolling back reverses it to frame 0 exactly.
10. **Visibility-gated render.** `IntersectionObserver` on the sticky stage — no rAF work
    while the section is off-screen.
11. **Loading curtain.** ~2–3s preload gate so frame 0 never pops in mid-page.
12. **Reduced-motion + mobile:** honour `prefers-reduced-motion` (render a still hero frame);
    on narrow viewports shrink the stage rather than re-cropping the footage.
13. **Continuous motion only.** No hard cuts in the source clip — cuts look broken when
    scrubbed backwards.

## 5. KNOWN FAILURE — DO NOT REINTRODUCE

The bug this pass exists to kill:

- progress derived from the **whole page** (`scrollY / documentHeight`) so the animation
  advances across the entire site instead of inside the hero;
- a **fixed `z-index: 0` background layer** that keeps travelling once the section has
  scrolled past, producing "an extra layer, not a wire";
- a render loop that never stops after the section is out of view.

The contract in §4 (hero-bound `rect`-based progress, parking at 1, visibility gating) is the
fix. Any regression to page-level progress is a failed delivery.

## 6. SKILLS

### Already installed on this machine — verified
- `~/.claude/skills/scroll-world/` — fly-through scrub skill. Reuse its
  `references/scrub-engine.js` (portable vanilla-JS scrub engine, framework-agnostic),
  `references/index-template.html`, `references/pipeline.md`, `references/prompts.md`,
  `references/knockout.py`. Best starting point for the engine.
- `~/.claude/skills/animation/`, `taste-skill/`, `design/`, `design-system/`
- Existing subagents: `web-designer`, `ui-designer`, `design-reviewer`, `code-reviewer`,
  `nextjs-lead`, `a11y-auditor` (in `~/.claude/agents/`)

### Install now
```bash
git clone https://github.com/zubair-trabzada/scroll-cinematic-claude.git ~/.claude/skills/scroll-cinematic
```
Reusable from it (all runnable here — ffmpeg 8.1.2 is installed):
- `scripts/extract-frames.sh <clip.mp4> frames/<name> 180`
- `scripts/compress-frames.sh frames/<name> 1600 88`
- `templates/scroll-cinematic.js` — the multi-section scrub engine + `SCRUB_SECTIONS` config
- `templates/index.html`, `templates/styles.css`, `templates/CinematicReveal.tsx`

**Do not run** steps 2, 3, 4 of that skill (hero keyframe + clip generation) — those are the
Higgsfield parts that are out of scope. Steps 0, 5, 6, 7 apply.

### Existing repo assets to drive the scrub (no generation)
```
assets/projects/louvre/frames/          # 80 frames, 8.7 MB   -> within budget, use as-is
assets/projects/warner-bros/frames/     # 80 frames, 49 MB    -> OVER BUDGET, compress first
assets/projects/emirates/frames/        # 80 frames, 55 MB    -> OVER BUDGET, compress first
assets/cinematic-source/*.mp4           # louvre-abu-dhabi, warner-bros, zayed-national-museum, emirates-palace
assets/hero-garden.mp4, hero-mist.mp4, seamless-mist-loop.mp4
```
Re-slice with the installed ffmpeg:
`ffmpeg -i <clip>.mp4 -vf "fps=10" -vsync 0 -q:v 3 frames/frame_%04d.jpg` (8s clip → 80 frames).
Then compress to the budget: `bash ~/.claude/skills/scroll-cinematic/scripts/compress-frames.sh frames/<name> 1600 88`.

**First task in the build: bring warner-bros and emirates under ~15 MB each.** 49 MB and 55 MB
of JPEGs will visibly stall the first paint. Compress into a new folder and keep the originals.

## 7. STANDING RULES

- Work one numbered prompt at a time. Never run ahead; stop and wait after each.
- **Backup before every change**: `backups/<timestamp>/` inside the project, copy the files
  you are about to modify, then edit.
- No generation, no spend, no external call without stating it first.
- **Verify by looking**: headless screenshot at 1920x1080, placed side by side with the
  approved reference, compared by you, differences fixed, *before* you report back. Never
  claim a match you have not compared.
- 1920x1080 is the screenshot size only — never the page's size. Relative units only, no
  fixed pixel page width/height, no horizontal scroll.
- After each step: what you did, what the evidence is, what you are waiting for.

## 8. SUB-AGENTS TO CREATE

Create these four in `~/.claude/agents/` before starting the build:

| Agent | Role | Must not |
|---|---|---|
| `scrub-engineer` | Owns `scroll-cinematic.js` / the scrub engine, height math, damping, preload | Touch content, copy, or other sections |
| `frame-pipeline` | ffmpeg slicing + compression, frame naming, weight budget, loading curtain | Change JS logic |
| `cinematic-reviewer` | Fresh eyes. Compares live screenshot to the approved reference. Reports only concrete diffs with locations. Issues PASS/FAIL | Fix anything itself; pass anything it has not compared |
| `perf-budget-auditor` | Measures frame weight, first paint, memory, rAF cost; fails the build over budget | Approve "close enough" |

**Reviewer gate — put this in the prompts, it is the important part:** the developer loops
against the reviewer, and the loop stops at the **first PASS** or after **5 reviewer rounds**,
whichever comes first. Without the gate a reviewer always finds something and the build never
ends. 5 rounds is the ceiling; use 2 on a tight budget.

**Prompt-polish rule:** before sending a rough instruction to a sub-agent, pass it through an
AI once to rewrite it precisely, then send the polished version. Cheap, and it measurably
improves agent accuracy.

## 9. COMPLETION GATE

All must be true with real output attached:

- [ ] Progress is hero-bound; page-level progress appears nowhere in the engine
- [ ] Frame index changes at 3 sampled scroll positions and is monotonic forward / reversible backward
- [ ] Film parks at progress 1 and restores to frame 0
- [ ] No movement after the hero section (no runaway background layer)
- [ ] Frame strip ≤ ~15MB/section, 1600px q88
- [ ] Side-by-side screenshot vs approved reference attached
- [ ] Reduced-motion and mobile behaviour demonstrated, not asserted
- [ ] Reviewer agent issued PASS (or 5 rounds and the outstanding diffs are listed)

Report failures as failures. An honest blocker beats a plausible claim.
