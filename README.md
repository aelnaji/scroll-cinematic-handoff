# Scroll-driven hero — implementation handoff

A self-contained brief for an AI coding agent (Claude Code, Codex, Cursor) working on an
already-built site whose **scroll-driven cinematic hero** needs finishing.

No generation, no Higgsfield, no paid model calls, no build step. The effect is a canvas
image-sequence scrub driving frame strips that already exist in the target repository.

**The agent owns the job end to end.** Nobody feeds it steps, and nobody has to approve phases.
It reads these files, installs what `SKILLS.md` says, runs `EXECUTION.md` straight through, and
sends one complete report at the end.

## Read in this order

| File | What it is |
|---|---|
| `DIRECTIVE.md` | The requirements. Autonomy rules, exclusions, the engine contract, the failure being fixed, assets, where to get help, the sub-agents, the 13 acceptance criteria, the report format |
| `EXECUTION.md` | The phases to run, in order, with an exit check per phase. Self-driving — no prompt relay |
| `SKILLS.md` | The ranked scroll / 3D-scroll skill landscape with verified star counts and install commands. **Install Tier A, read Tier B, never install Tier C** |
| `skills/` | `scroll-world` vendored (MIT) — `skills/scroll-world/references/scrub-engine.js` is the engine to start from. See `skills/NOTICE.md` |
| `install-skills.sh` | Installs the skills into `~/.claude/skills/`. Additive; skips what is present; fast-forwards an existing checkout |

## The one line to start it

```
Read the handoff at https://github.com/aelnaji/scroll-cinematic-handoff — start with README.md, then follow the read order. Own it end to end: install what SKILLS.md says, run every phase in EXECUTION.md without asking me, and send me the final report.
```

Nothing else is needed from a human until that report lands.

## The one thing to get right

The "3D scroll" effect is not Three.js. It is a canvas frame-sequence scrub whose progress is
bound to the **hero's own bounding rect**:

```js
progress = clamp((-rect.top) / (rect.height - innerHeight), 0, 1)
```

Page-level progress (`scrollY / documentHeight`) and a fixed `z-index: 0` full-page background
layer are the two bugs that turn the effect into "an extra layer, not a wire". Both are banned in
`DIRECTIVE.md` §5, and the 13 acceptance criteria in §11 exist to catch them.

## Credit

Technique and prompt structure adapted from Komputer Mechanic's
[Build a Scroll Animation Website with AI](https://www.youtube.com/watch?v=mFgRGSOGNPM).
Its generation-dependent steps are replaced throughout with "use the existing asset" — this
handoff never calls an image or video model.
