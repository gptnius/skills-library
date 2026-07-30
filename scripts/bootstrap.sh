#!/usr/bin/env bash
# bootstrap.sh — set up the whole library on a fresh machine from just this repo.
#   git clone <this-repo> ~/Desktop/Skills-Library
#   ~/Desktop/Skills-Library/scripts/bootstrap.sh          # full build
#   ~/Desktop/Skills-Library/scripts/bootstrap.sh --public # skip NO-LICENSE sources
set -uo pipefail

LIB="${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
MODE="${1:-all}"
cd "$LIB"

echo "== 1/4  Cloning sources =="
bash scripts/clone-sources.sh "$MODE"

echo "== 2/4  Installing skills (markdown-only; executables quarantined) =="
bash scripts/install.sh | tail -3

echo "== 3/4  Generating docs =="
python3 scripts/gen-docs.py

echo "== 4/4  Verifying no executables leaked into skills/ =="
n=$(find skills -type f \( -name '*.sh' -o -name '*.mjs' -o -name '*.cjs' -o -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.cmd' \) | wc -l | tr -d ' ')
echo "  executables under skills/: $n  (must be 0)"
echo
echo "Done. Next:  scripts/activate.sh   then restart Claude Code and run /skills."
