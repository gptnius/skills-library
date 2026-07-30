# Maintenance

## Update everything (monthly)

```bash
~/Desktop/Skills-Library/scripts/sync.sh
```

This fast-forward-pulls every repo in `.sources/`, re-runs the install from `scripts/manifest.txt`, regenerates `INDEX.md` + `manifest.json`, and prints a change summary. Then:

```bash
LIB="$HOME/Desktop/Skills-Library"
git -C "$LIB" diff                 # review upstream changes vs. your local edits
git -C "$LIB" add -A && git -C "$LIB" commit -m "sync $(date +%Y-%m-%d)"
```

If a synced skill is in the always-on set, run `scripts/activate.sh` and **restart Claude Code**.

## Add a new skill

1. Clone the source into `.sources/<key>` (add it to `scripts/sync.sh`'s implicit loop by cloning there).
2. Add metadata for the key in `scripts/lib-install.sh` (`meta_url` / `meta_author` / `meta_license`).
3. Add a line to `scripts/manifest.txt`:  `one <key> <relpath> <category> <name>`  (or `pack …`).
4. `bash scripts/install.sh && python3 scripts/gen-docs.py`
5. Commit. To make it global, add it to `scripts/always-on.txt` and re-run `activate.sh`.

## Remove a skill

1. Delete its line from `scripts/manifest.txt` (and its dir under `skills/`).
2. If it was activated, remove it from `scripts/always-on.txt` and run `scripts/deactivate.sh` then `activate.sh`.
3. Regenerate docs: `python3 scripts/gen-docs.py`. Commit.

## How the security model works

- `scripts/lib-install.sh` copies **markdown + reference material only** — it excludes `*.sh/*.mjs/*.cjs/*.js/*.ts/*.py/*.cmd` and hook/plugin dirs, then routes any executable/hook it finds to `_quarantine/` and logs `QUARANTINE.md`.
- `quarantine_repo_root` additionally captures installers/hooks that sit at a repo's top level (outside the installed `skills/` subtree) — e.g. npx installers, `install.sh`, `SessionStart` hooks.
- Re-verify after any change:  `find skills -type f \( -name '*.sh' -o -name '*.mjs' -o -name '*.js' -o -name '*.ts' -o -name '*.py' \) | wc -l`  → **must be 0.**
- In this **curation-layer** repo, `skills/`, `_quarantine/`, and `.sources/` are all gitignored build artifacts — they exist on your machine but are never published. `_quarantine/` (others' scripts) stays local for your review; it is rebuilt by `install.sh` and deliberately kept out of the public repo.

## Watch items

- **Meng To `web-design`** is upstream-labeled *draft*; skills drift in and out (see `MISSING.md` — `image-to-code`, `design-taste-frontend`, `high-end-visual-design`, `redesign-existing-projects`, `seo-audit` were dropped upstream by build time). Re-check on each sync.
- **License-unconfirmed:** `emalorenzo/three-agent-skills` and `Yakoub-ai/phaser4-gamedev` say MIT in README but have no detectable LICENSE file. `indi256s/dataviz-skill` has **no license at all** — local use only. Resolve before redistributing any of these.
- **If Anthropic ships official copywriting/typography/audio skills,** prefer them over community equivalents.
- **Caution packs** may change their hooks/installers upstream — re-read `QUARANTINE.md` entries after a sync that updates them.
- **Prune rule:** if a source goes 3+ months without commits and has unaddressed issues, consider dropping it from `manifest.txt`.

## Files you edit vs. files that are generated

| Edit by hand | Generated (don't hand-edit) |
|---|---|
| `scripts/manifest.txt`, `scripts/always-on.txt`, `scripts/lib-install.sh`, `scripts/*.sh`, `scripts/gen-docs.py` | `INDEX.md`, `manifest.json`, `MISSING.md`, `QUARANTINE.md` (rebuilt by `install.sh` / `gen-docs.py`) |
