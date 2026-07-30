#!/usr/bin/env bash
# deactivate.sh — remove ONLY the skills this library activated from ~/.claude/skills.
# Never touches unrelated skills: symlinks are checked to point into this library,
# copies are checked for a .skills-library-source marker.
set -euo pipefail

LIB="${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
ACTIVE="$HOME/.claude/skills"
[ -d "$ACTIVE" ] || { echo "nothing to do: $ACTIVE does not exist"; exit 0; }

removed=0
for entry in "$ACTIVE"/*; do
  [ -e "$entry" ] || [ -L "$entry" ] || continue
  name="$(basename "$entry")"
  if [ -L "$entry" ]; then
    target="$(readlink "$entry")"
    case "$target" in
      "$LIB"/*) rm -f "$entry"; echo "removed symlink: $name"; removed=$((removed+1));;
    esac
  elif [ -d "$entry" ] && [ -f "$entry/.skills-library-source" ]; then
    rm -rf "$entry"; echo "removed copy: $name"; removed=$((removed+1))
  fi
done

echo "---"
echo "Deactivated $removed skill(s) from this library. Anything else in $ACTIVE was left untouched."
echo "Restart your Claude Code session for the change to take effect."
