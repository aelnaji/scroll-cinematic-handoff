# PROMPTS — paste one at a time, wait for the report, then send the next

Adapted from Komputer Mechanic's scroll-animation tutorial for **this** situation:
the site is already built, the assets already exist, and there is **no Higgsfield /
no generation** anywhere in the pipeline.

Prompts 0, 1 and 2 are the author's wording. Prompts 3A–5 are rebuilt to the same spec
from the video walkthrough (his exact wording for 3A/3B/4A/4C/5 sits behind a free
email gate on komputermechanic.com) and are adapted so every generation step becomes
"use the existing asset".

Send as: `@DIRECTIVE.md @PROMPTS.md` already read → then paste each block below verbatim.

---

## PROMPT 0 — The briefing (send first, before anything else)

```
We are about to finish ONE thing together: the scroll-driven cinematic hero on this
site. The site itself is already built and approved, so nothing gets redesigned, no
section gets rebuilt, and no new visual asset gets generated. Here is the arc so you
know where we are going: first you check the environment and confirm you understand
the engine contract I have given you in DIRECTIVE.md; then you study the approved
reference screenshot and the existing frame strips in the repo as our single source of
truth; then you rebuild nothing and instead wire the existing hero and frame strips into
a scroll-scrubbed film, first as a cheap low-resolution draft and only after my approval
at full quality; then you extend the same treatment to the remaining cinematic sections;
and finally you prove it works with measurements, not claims.

Standing rules for the whole project: work step by step and never run ahead of the prompt
we are on; before every change take a backup by copying the files you are about to modify
into a timestamped folder under backups/ in this project, so we can always go back if
something screws up; there is no image or video generation in this build and no external
model calls, so if any prompt names a generation model, use the existing asset in the repo
instead; verify your own work by looking at real screenshots before telling me anything is
done; and when you finish a step, tell me clearly what you did, what the evidence is and
what you are waiting for.

Repeat this mission back to me in your own words, list the standing rules as you
understand them, and then wait for my first numbered prompt. Do not build or change
anything yet.
```

## PROMPT 1 — Environment check and the engine contract

```
Confirm the environment before we build. Report: which skills are available to you
(scroll-world under ~/.claude/skills, and scroll-cinematic once it is installed), what
ffmpeg reports for its version, and which frame strips already exist in this repo with
their frame counts and total size on disk. Tool outputs may include machine paths; never
repeat anything that looks like a credential, key or token in your replies.

Then read the engine contract in DIRECTIVE.md section 4 and section 5 and repeat back, in
your own words, the exact progress formula you are going to use and the three things that
must never appear in the engine. If you have a different approach in mind, say so now with
the reason before writing any code.

From here on: before any change, check the current file you are about to touch and show me
the diff you intend to make. Never introduce a build step, a package manager, a Python
process or a framework — the site stays plain HTML, CSS and JS served as static files.
```

## PROMPT 2 — The source of truth

```
These are our single source of truth from now on: the approved screenshot of the hero as it
currently stands, and the existing frame strips under assets/projects/*/frames.
Study them now and tell me what you see: how many frames per strip, the resolution, whether
the motion in each strip is continuous or has cuts, and whether the subject is framed large
enough to fill the viewport once scaled.

Whenever you build or change anything, take a screenshot of the page with a headless browser
at 1920x1080, place it side by side with the approved screenshot, look at both, and fix the
differences before you report back to me. Never tell me something matches without having
compared the two images yourself.

One rule for the whole project: 1920x1080 is ONLY the screenshot size for comparing, never
the page's size. Build every page with relative units so it fills any browser window, with no
fixed pixel page width or height and no horizontal scrolling.
```

## PROMPT 3A — Wire the scrub (draft quality)

```
Now the main task. I want the hero brought to life as a scroll-driven film, using the frame
strips already in this repo. No new assets, no generation, no build step — plain HTML, CSS
and JS only.

Before you start, decide for yourself how many helper sub-agents you need and create them:
at minimum a scrub-engineer to own the engine, a frame-pipeline agent for the ffmpeg work
and frame budget, and a cinematic-reviewer with fresh eyes that compares what you built
against the approved screenshot and reports concrete differences. The reviewer gives the
developer feedback and the developer keeps iterating until the reviewer passes — but I want
a gate on that loop: stop at the FIRST reviewer PASS, or after FIVE reviewer rounds, whichever
comes first. Do not let the reviewer reopen a closed loop.

How the animation must work: as the visitor scrolls down through the hero, the film plays
forward through the frame sequence; scrolling back up reverses it frame by frame and lands
exactly on frame 0. The film must be bound to the hero section only — its progress comes from
the hero's own bounding rect, never from the document scroll position — and past the end of
the hero it parks on the last frame and stops. Nothing on the page keeps moving after the
hero. No fixed full-page background layer.

Use the engine rules in DIRECTIVE.md section 4 exactly: scene height equals the scrub distance
plus 100vh, sticky inner stage at 100vh, cover-fit canvas draw with devicePixelRatio capped
at 2, damped follow at 0.14 with the rAF re-kick from the scroll handler, redraw only when the
frame index changes, preload all frames and paint frame 0 immediately, and a short loading
curtain so frame 0 never pops in.

Work at DRAFT quality first: use the smallest strip you have and downscale the canvas draw,
because there will be several iterations before I am happy with the motion and I do not want
to pay for that in load time or re-encoding. Do not do the full-quality pass until I approve
the motion.

Rebuild nothing else on the site. When you are done, tell me what changed and show me the
side-by-side screenshot at three scroll positions.
```

## PROMPT 3B — Full-quality pass (only after I approve the motion)

```
The motion is approved. Now do the full-quality pass, same behaviour, higher fidelity:
re-slice or re-encode the strip at the target resolution, compress it to 1600px wide at JPEG
quality 88, and keep each section under about 15MB total. Keep frame count at roughly 180 —
more frames or bigger frames only buys load time, not smoothness.

Then re-run the reviewer against the approved reference and re-check the frame-index
behaviour at three scroll positions. Report the real numbers: frame count, strip size in MB,
first paint time, and the sampled frame indices. If a section is over budget, fix the budget
before telling me it looks good.
```

## PROMPT 4A — Exploded / cinematic motion direction

```
Now refine the motion itself, still with the existing assets. What I want to read on screen
is a single continuous camera move or object transformation — the subject rotating,
disassembling, or the camera flying through the scene — not a slideshow of unrelated shots.
The transformation must be continuous and reversible: scrolling down plays it forward,
scrolling up plays it backwards, and there must be no hard cut anywhere in the strip, because
a cut looks broken the moment it is scrubbed backwards.

Overlay copy fades over per-line progress windows and disappears before the transformation
completes, so the footage is unobstructed at the end of the scrub.

If a strip's motion is not continuous enough to read well when scrubbed, say so and tell me
which source clip needs re-slicing or re-shooting — do not paper over it with cross-fades
between two different takes.
```

## PROMPT 4C — Additional cinematic sections, same treatment

```
Apply the same treatment to the remaining cinematic sections, one at a time, reusing the same
engine instance pattern rather than a second copy of the code. Each section gets its own entry
in the scrub configuration: its own element selector, its own frame count and frame path, its
own background colour. The engine must skip any section whose element is missing instead of
throwing.

Each section is still hero-bound and finite: it plays its own film inside itself, parks at the
end, and does not consume scroll belonging to the next section. Give me the same evidence for
each section as for the hero: side-by-side screenshot, sampled frame indices, weight.
```

## PROMPT 5 — The rest of the page and the final audit

```
Now finish the surrounding work in the same art direction, without touching anything already
approved:

1. Loading behaviour — preload gate of about 2 to 3 seconds so every frame in the first
   section is ready before the curtain lifts. It must not look like a stuck page; show
   progress, not a spinner that hangs.
2. Reduced motion and mobile — under prefers-reduced-motion show a single static hero frame
   and no scrub. On narrow viewports shrink the stage so the subject still fits the frame
   instead of re-cropping the footage.
3. Performance — no rAF work while a section is off-screen, no layout thrash on scroll, no
   memory growth after scrolling the full page up and down five times.
4. Accessibility — the canvas is decorative; the hero headline stays real selectable HTML text
   and remains in the accessibility tree.

Then run the completion gate in DIRECTIVE.md section 9 and give me the result as a checklist
with the real output attached for each line, PASS or FAIL. Do not mark anything PASS that you
have not measured, and list anything still failing with its next step. Finally, ask the
perf-budget-auditor agent to sign off, or tell me exactly what it flagged.
```

---

## If a step stalls

The author's own recovery move, and it works: **stop the agent, clear the goal, restate.**

- Claude Code runs long tasks as a goal ("forward/go" mode). When it is heading the wrong way,
  press stop, clear the standing goal, then restate the direction — otherwise the old goal
  re-asserts itself and drags the agent back onto the abandoned path.
- Be specific about location when reporting a visual defect ("the stray element sits top-right,
  behind the headline's second word") — vague feedback produces vague fixes.
- If the reviewer keeps finding new faults, you are past the point of diminishing returns.
  Cap it at five rounds and accept "as close as it needs to be". One-to-one perfection is not
  the target.
