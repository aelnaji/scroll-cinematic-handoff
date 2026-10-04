# Scroll-driven hero — implementation handoff

A self-contained brief for an AI coding agent (Claude Code, Codex, Cursor) working on an
already-built site that needs its **scroll-driven cinematic hero** finished.

No generation, no Higgsfield, no paid model calls, no build step. The effect is a canvas
image-sequence scrub driving frame strips that already exist in the target repo.

## Read in this order

| File | What it is |
|---|---|
| `DIRECTIVE.md` | The mission, hard exclusions, the engine contract, the known failure to fix, installed skills, the sub-agents to create, the completion gate |
| `PROMPTS.md` | The numbered prompt pack — paste one at a time, in order, and wait for the report after each |
| `skills/` | Both supporting skills vendored, so nothing needs installing to read them. `skills/scroll-world/references/scrub-engine.js` is the engine to start from. See `skills/NOTICE.md` for origin and license. |
| `SKILLS.md` | The ranked scroll / 3D-scroll skill landscape with verified star counts, install commands, and the tiering: **install Tier A, read Tier B, never install Tier C.** |
| `install-skills.sh` | Optional: installs the two vendored skills into `~/.claude/skills/`. Additive only, skips what is already present. |

## Start

```
Read DIRECTIVE.md and PROMPTS.md in this repo, then wait for prompt 0.
```

Then paste **PROMPT 0** from `PROMPTS.md`. The agent repeats the mission and the standing
rules back, and waits. Do not send prompt 1 until it has.

## The one thing to get right

The "3D scroll" effect is not Three.js. It is a canvas frame-sequence scrub whose progress is
bound to the **hero's own bounding rect**:

```js
progress = clamp((-rect.top) / (rect.height - innerHeight), 0, 1)
```

Page-level progress (`scrollY / documentHeight`) and a fixed `z-index: 0` full-page background
layer are the two bugs that turn the effect into "an extra layer, not a wire". They are banned
in `DIRECTIVE.md` §5.

## Credit

Prompt structure and pipeline technique adapted from Komputer Mechanic's
[Build a Scroll Animation Website with AI](https://www.youtube.com/watch?v=mFgRGSOGNPM).
The generation-dependent steps of that tutorial are replaced here with "use the existing
asset" — this handoff never calls an image or video model.
