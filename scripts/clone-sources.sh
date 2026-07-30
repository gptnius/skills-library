#!/usr/bin/env bash
# clone-sources.sh — shallow-clone every source in sources.txt into .sources/ (skips existing).
# Makes the library reproducible on a fresh machine. Idempotent.
#   ./clone-sources.sh            # clone missing
#   ./clone-sources.sh --public   # skip sources flagged NO-LICENSE (for a public build)
set -uo pipefail

LIB="${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SRC="$LIB/scripts/sources.txt"
MODE="${1:-all}"
[ -f "$SRC" ] || { echo "missing $SRC"; exit 1; }
mkdir -p "$LIB/.sources"

ok=0; skip=0; fail=0
while read -r key url flag; do
  case "$key" in ''|\#*) continue;; esac
  if [ "$MODE" = "--public" ] && [ "${flag:-}" = "NO-LICENSE" ]; then
    echo "skip (NO-LICENSE, --public): $key"; skip=$((skip+1)); continue
  fi
  if [ -d "$LIB/.sources/$key/.git" ]; then
    echo "have   $key"; ok=$((ok+1)); continue
  fi
  if git clone --depth 1 --quiet "$url" "$LIB/.sources/$key"; then
    echo "cloned $key"; ok=$((ok+1))
  else
    echo "FAIL   $key <- $url"; fail=$((fail+1))
  fi
done < "$SRC"

echo "---"
echo "present/cloned: $ok | skipped: $skip | failed: $fail"
[ "$fail" -eq 0 ] || exit 1
