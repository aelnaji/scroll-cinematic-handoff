#!/usr/bin/env bash
# Installs the scroll-scrub skills used by DIRECTIVE.md. Additive only, no overwrites.
set -euo pipefail

SKILLS="$HOME/.claude/skills"
mkdir -p "$SKILLS"

echo "ffmpeg: $(ffmpeg -version 2>/dev/null | head -1 || echo MISSING)"

if [ -d "$SKILLS/scroll-cinematic/.git" ]; then
  echo "scroll-cinematic already installed - updating"
  git -C "$SKILLS/scroll-cinematic" pull --ff-only
elif [ -f "$SKILLS/scroll-cinematic/SKILL.md" ]; then
  echo "scroll-cinematic present (not a git checkout) - leaving it alone"
else
  git clone --depth 1 https://github.com/zubair-trabzada/scroll-cinematic-claude.git "$SKILLS/scroll-cinematic"
  echo "installed scroll-cinematic"
fi

if [ -f "$SKILLS/scroll-world/SKILL.md" ]; then
  echo "scroll-world already installed"
  ls "$SKILLS/scroll-world/references"
else
  echo "scroll-world MISSING - installing"
  tmp="$(mktemp -d)"
  git clone --depth 1 https://github.com/oso95/scroll-world.git "$tmp/scroll-world"
  cp -R "$tmp/scroll-world/skills/scroll-world" "$SKILLS/"
  rm -rf "$tmp"
  echo "installed scroll-world"
fi

echo
echo "--- installed ---"
ls -d "$SKILLS"/scroll-world "$SKILLS"/scroll-cinematic
