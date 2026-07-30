#!/usr/bin/env bash
# install.sh — (re)build the curated library from .sources/ using manifest.txt.
# Safe to re-run: it refreshes MISSING.md / QUARANTINE.md and re-copies skills.
set -uo pipefail

LIB="${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export LIB
export TODAY="$(date +%Y-%m-%d)"

. "$LIB/scripts/lib-install.sh"
MAN="$LIB/scripts/manifest.txt"
[ -f "$MAN" ] || { echo "missing manifest: $MAN"; exit 1; }

# reset generated logs
{
  echo "# Missing skills"
  echo
  echo "_Generated $TODAY. Entries listed in the manifest that were not found in their source repo — usually upstream drift (the repo renamed or removed the skill since the build brief was written). Not errors in your library; just a record of what the brief expected but the source no longer provides._"
  echo
} > "$LIB/MISSING.md"

{
  echo "# Quarantine"
  echo
  echo "_Generated $TODAY. Skills whose source directory shipped executable code or agent hooks. Only the **markdown + reference material** was installed into \`skills/\`; every executable/hook file below was copied to \`_quarantine/\` and is **never symlinked or activated**._"
  echo
  echo "> To use a quarantined script, read it yourself first, then run it manually. Agent hooks in particular can modify \`.claude/\`, \`.cursor/\`, and \`.codex/\` settings. Nothing here runs unless you run it."
  echo
} > "$LIB/QUARANTINE.md"

echo "Installing skills from manifest…"
while read -r mode key rel cat name; do
  case "$mode" in
    ''|\#*) continue;;
    one)  install_one  "$key" "$rel" "$cat" "$name";;
    pack) install_pack "$key" "$rel" "$cat" "$name";;
    *) echo "  ??    unknown mode: $mode";;
  esac
done < "$MAN"

# repo-root installers/hooks for caution packs installed as a subtree (outside that subtree)
{
  echo
  echo "## Repo-root installers & hooks (caution packs)"
  echo
  echo "_These files live at the top level of a caution repo, outside the \`skills/\` subtree that was installed. They are the installers/validators/session hooks flagged by the security research. Copied here for review; **never installed, never run**._"
  echo
} >> "$LIB/QUARANTINE.md"
quarantine_repo_root threejs-graphics skills
quarantine_repo_root godotprompter    skills
quarantine_repo_root phaser4          skills
quarantine_repo_root threejs-game     skills
quarantine_repo_root webgl-anim       skills
quarantine_repo_root expo             plugins/expo/skills
quarantine_repo_root addyosmani-eng   skills
quarantine_repo_root superpowers      skills
quarantine_repo_root mattpocock       skills/engineering

# tidy: if MISSING.md has no entries, say so
if ! grep -q '^- ' "$LIB/MISSING.md"; then
  echo "_None — every manifest entry was found._" >> "$LIB/MISSING.md"
fi

echo "Install pass complete."
