# EXECUTION — run these phases in order, without stopping

This replaces a step-by-step prompt script. **Nobody is going to feed you these one at a time.**
You run all of it, in order, and produce the report in `DIRECTIVE.md` §12 at the end.

Rules for every phase:
- Run the phase's **exit check** before moving to the next one. If the check fails, fix it or
  record it — do not carry it forward silently.
- Keep a running evidence file (`EVIDENCE.md` in the project root is fine) as you go. Filling it
  at the end from memory is how reports turn into fiction.
- The only reasons to contact the owner mid-run are in `DIRECTIVE.md` §0.

---

## PHASE 0 — Ground work

**Do**
1. Read `DIRECTIVE.md` completely, then `SKILLS.md`, then `skills/NOTICE.md`.
2. Read `skills/scroll-world/references/scrub-engine.js` end to end. You may not write an engine
   before you have read one.
3. Install Tier A from `SKILLS.md`. Capture the raw command output of each install. If one fails,
   follow the recovery notes at the bottom of `SKILLS.md`; if it still fails, record it and carry
   on with what you have — do not stop the job for a skill.
4. Take a backup snapshot of the files you are going to touch into `backups/<timestamp>/`.

**Exit check** — you can name, from memory, the exact progress formula in C1, the three banned
patterns in §5, and which skill you are using for the engine and why.

## PHASE 1 — Inventory and budget

**Do**
1. Locate every frame strip and source clip in the repo. Report the real path, frame count,
   resolution and `du -sh` size of each — measured, not assumed.
2. Compare against C8 (≤15 MB per section). Anything over budget goes on the compress list.
3. Verify the source motion is continuous. If a strip has a hard cut in it, say which one and
   which source it came from — a cut will look broken scrubbed backwards (C14).

**Exit check** — a table of real measured numbers, and a named compress list.

**Do next (same phase)** — for every strip on the compress list:
```
mkdir -p <strip>/../frames-opt
ffmpeg -i <source or existing frames> -vf "scale=1600:-2" -q:v 3 frames-opt/frame_%04d.jpg
```
or `scripts/compress-frames.sh <frames-dir> 1600 88` from the scroll-cinematic skill. Verify the
output is under 15 MB and the frame count is unchanged. **Keep the originals.**

**Exit check** — every strip ≤15 MB, frame counts unchanged, `du -sh` shown for each.

## PHASE 2 — Draft scrub (cheap, low resolution)

**Do**
1. Create the sub-agents in `DIRECTIVE.md` §9.
2. Build the scrub on **one** strip first, at draft fidelity — downscaled draw, smallest strip.
   You will iterate on the motion several times and you do not want to pay for that in re-encodes.
3. Implement C1–C7 and C9–C10 exactly. Not the surrounding content — only the hero scrub.
4. Run the reviewer loop against it, with the gate: stop at first PASS or five rounds.

**Exit check** — canvas pixel samples at three scroll positions differ, and the sampled progress
is driven by the hero rect. Both shown with raw values. Do not proceed on "it looks right".

## PHASE 3 — Second pass, then the remaining sections

**Do**
1. Fix what the reviewer flagged, re-check, and only then extend.
2. Apply the same engine to the remaining cinematic sections. **Reuse the same engine instance
   pattern** — do not paste a second copy of the code. Each section gets its own entry in the
   scrub config: element selector, frame count, frame path, background colour.
3. The engine must skip any section whose element is missing rather than throwing.
4. Each section stays hero-bound and finite: it plays its own film inside itself, parks at the
   end, and does not consume the next section's scroll.

**Exit check** — per section: pixel samples at three progress points, weight, and confirmation it
parks.

## PHASE 4 — Full quality

**Do** — re-slice or re-encode at the target fidelity, compress to C8, keep frame count ≤180, and
re-run the reviewer against the approved hero.

**Exit check** — the real numbers: frame count, MB per section, first paint time, sampled frame
indices. If a section is over budget, fix the budget before calling it good.

## PHASE 5 — Loading, motion, mobile, accessibility

**Do**
1. Loading curtain (C11): ~2–3s, visible progress, every frame in the first section ready before
   it lifts. It must not read as a stuck page.
2. Reduced motion (C12): a single static hero frame, no scrub.
3. Narrow viewports (C13): shrink the stage, do not re-crop the footage.
4. Off-screen cost (C10): verify no rAF work while a section is out of view.
5. Stability: scroll the full page down and back five times — no memory growth, no layout thrash.
6. Accessibility: the canvas is decorative; the hero headline stays real selectable HTML text and
   stays in the accessibility tree.

**Exit check** — screenshots for reduced motion and a narrow viewport, plus the measured numbers
for paint time and memory.

## PHASE 6 — Prove it and report

**Do**
1. Run every line of `DIRECTIVE.md` §11. Attach the real output per line.
2. Produce the side-by-side visual: live page screenshot beside the approved hero, at 1920x1080
   comparison size, three scroll positions. Compare them yourself and fix what differs before
   declaring the visual match.
3. Ask `perf-budget-auditor` to sign off. If it flags something, either fix it or list it as not
   done — do not bury it.
4. Send the report in the `DIRECTIVE.md` §12 shape, once, complete.

**Exit check** — every D-line has output, every deviation is named, and everything unfinished is
listed with its next step.

---

## WHEN A PHASE STALLS

The author's own recovery move, and it works:

- **Stop, clear the goal, restate.** A long-running goal re-asserts itself and drags you back
  onto the abandoned path. If you are heading the wrong way, clear the standing goal before
  restating the new direction.
- **Be specific about location when you report a defect.** "Element sits top-right, passing
  behind the headline's second word" produces a fix; "the layout looks off" does not.
- **Past five reviewer rounds you are in diminishing returns.** Stop, accept "as close as it
  needs to be", and list the remaining diffs as a deliberate deviation. One-to-one pixel
  perfection is not the target — a convincing, correct, reversible scrub is.
- **Three attempts on the same failure means change approach, not retry.** Escalate per §0 or
  switch strategy and record that you did.
