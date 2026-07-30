#!/usr/bin/env bash
# sync.sh — refresh source clones, rebuild the curated library, regenerate docs.
# Run monthly. Review `git diff` afterwards to see what upstream changed vs. your edits.
set -uo pipefail

LIB="${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
cd "$LIB"

echo "== 1/4  Pulling source repos (fast-forward only) =="
for d in "$LIB"/.sources/*/; do
  [ -d "$d/.git" ] || continue
  key="$(basename "$d")"
  before="$(git -C "$d" rev-parse --short HEAD 2>/dev/null || echo '?')"
  if git -C "$d" pull --ff-only --quiet 2>/dev/null; then
    after="$(git -C "$d" rev-parse --short HEAD 2>/dev/null || echo '?')"
    if [ "$before" != "$after" ]; then echo "  updated  $key  $before -> $after"; else echo "  current  $key"; fi
  else
    echo "  SKIP     $key (no ff / detached / offline)"
  fi
done

echo "== 2/4  Reinstalling skills from manifest =="
bash "$LIB/scripts/install.sh" | tail -3

echo "== 3/4  Regenerating INDEX.md + manifest.json =="
python3 "$LIB/scripts/gen-docs.py"

echo "== 4/4  Change summary =="
if git -C "$LIB" diff --quiet && git -C "$LIB" diff --cached --quiet; then
  echo "  no changes in the library since last commit."
else
  git -C "$LIB" status --short | sed 's/^/  /'
  echo
  echo "  Review with:  git -C \"$LIB\" diff"
  echo "  Commit with:  git -C \"$LIB\" add -A && git -C \"$LIB\" commit -m 'sync $(date +%Y-%m-%d)'"
fi
echo "Done. If new skills were added to the always-on set, run scripts/activate.sh and restart Claude Code."
