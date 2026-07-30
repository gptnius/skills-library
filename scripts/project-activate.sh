#!/usr/bin/env bash
# project-activate.sh — symlink named skills, packs, or whole categories into a
# project's .claude/skills (project-local; loads only when Claude Code runs there).
#
# Usage:
#   ./project-activate.sh <project-path> <skill-or-category-or-pack> [more...]
# Examples:
#   ./project-activate.sh ~/code/mygame 13-games/awesome-gamedev
#   ./project-activate.sh ~/code/site  06-3d-webgl 04-motion/gsap
#   ./project-activate.sh ~/code/app   12-mobile/expo/expo-router
set -euo pipefail

LIB="${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
usage() { echo "Usage: $0 <project-path> <skill|pack|category> [more...]"; exit 1; }
[ $# -ge 2 ] || usage

PROJ="$1"; shift
[ -d "$PROJ" ] || { echo "no such project dir: $PROJ"; exit 1; }
DEST="$PROJ/.claude/skills"
mkdir -p "$DEST"

link_one() { # $1 = absolute skill dir
  local src="$1" name
  name="$(basename "$src")"
  if [ ! -f "$src/SKILL.md" ]; then echo "skip (no SKILL.md): $src"; return; fi
  ln -sfn "$src" "$DEST/$name"
  echo "activated: $name"
}

for arg in "$@"; do
  target="$LIB/skills/$arg"
  if [ -d "$target" ] && [ -f "$target/SKILL.md" ]; then
    # a single skill given by path
    link_one "$target"
  elif [ -d "$target" ]; then
    # a category or pack folder — link every SKILL.md-bearing dir inside it
    found=0
    while IFS= read -r skdir; do
      link_one "$skdir"; found=$((found+1))
    done < <(find "$target" -name SKILL.md -not -path '*/.git/*' -exec dirname {} \; | sort)
    [ "$found" -eq 0 ] && echo "no skills found under: $arg"
  else
    # bare name — search across the library
    hit="$(find "$LIB/skills" -type d -name "$(basename "$arg")" -not -path '*/.git/*' | head -n1)"
    if [ -n "$hit" ] && [ -f "$hit/SKILL.md" ]; then link_one "$hit"; else echo "not found: $arg"; fi
  fi
done

echo "---"
echo "Project skills are in $DEST — they load automatically when Claude Code runs in $PROJ."
