#!/usr/bin/env bash
# activate.sh — symlink (or copy) the always-on skill set flat into ~/.claude/skills
# Usage: ./activate.sh            # symlink mode (default)
#        ./activate.sh --copy     # copy mode (fallback if symlinks misbehave)
set -euo pipefail

LIB="${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
ACTIVE="$HOME/.claude/skills"
MODE="${1:-symlink}"
LIST="$LIB/scripts/always-on.txt"

mkdir -p "$ACTIVE"
[ -f "$LIST" ] || { echo "missing $LIST"; exit 1; }

count=0
while IFS= read -r line; do
  # strip trailing comments and surrounding whitespace
  line="${line%%#*}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [ -z "$line" ] && continue

  src="$LIB/skills/$line"
  name="$(basename "$line")"
  if [ ! -f "$src/SKILL.md" ]; then
    echo "skip (no SKILL.md): $line"
    continue
  fi

  # never clobber something we didn't create
  if [ -e "$ACTIVE/$name" ] || [ -L "$ACTIVE/$name" ]; then
    if [ -L "$ACTIVE/$name" ]; then
      tgt="$(readlink "$ACTIVE/$name")"
      case "$tgt" in
        "$LIB"/*) : ;;   # our own symlink — safe to refresh
        *) echo "skip (exists, not ours): $name -> $tgt"; continue;;
      esac
    elif [ -d "$ACTIVE/$name" ] && [ -f "$ACTIVE/$name/.skills-library-source" ]; then
      : # our own --copy — safe to refresh
    else
      echo "skip (exists, not ours): $name  [your existing skill left untouched]"
      continue
    fi
  fi

  if [ "$MODE" = "--copy" ]; then
    rm -rf "$ACTIVE/$name"
    cp -R "$src" "$ACTIVE/$name"
    printf '%s\n' "$src" > "$ACTIVE/$name/.skills-library-source"
  else
    ln -sfn "$src" "$ACTIVE/$name"
  fi
  echo "activated: $name"
  count=$((count + 1))
done < "$LIST"

echo "---"
echo "Activated $count skill(s) into $ACTIVE"
echo "Restart your Claude Code session, then run /skills to verify they load."
