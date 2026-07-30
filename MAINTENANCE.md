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

## Set up on a fresh machine

```bash
git clone https://github.com/gptnius/skills-library ~/Desktop/Skills-Library
~/Desktop/Skills-Library/scripts/bootstrap.sh     # --public to skip no-license sources
~/Desktop/Skills-Library/scripts/activate.sh      # then restart Claude Code
```

Scripts self-locate (or set `SKILLS_LIB=/path/to/library`), so the clone can live anywhere.

## Add a new skill

1. **Security-review the source first.** Check for executables/hooks and confirm the license. `18-security/skill-scanner` (Sentry) is built for exactly this — run it over the candidate before adopting.
2. Add the repo to `scripts/sources.txt`:  `<key>  <url>  [LICENSE-FLAG]`  then `bash scripts/clone-sources.sh`.
3. Add metadata for the key in `scripts/lib-install.sh` (`meta_url` / `meta_author` / `meta_license`).
4. Add a line to `scripts/manifest.txt`:  `one <key> <relpath> <category> <name>`  (or `pack …` for a whole subtree).
5. If the source ships root-level installers/hooks outside the installed subtree, add a `quarantine_repo_root <key> <subtree>` call in `scripts/install.sh`.
6. For a multi-skill pack, add a one-line description to the `PACKS` dict in `scripts/gen-docs.py` (packs have no single root `SKILL.md` to read).
7. `bash scripts/install.sh && python3 scripts/gen-docs.py`
8. Verify **0 executables** under `skills/` (command below), then commit. To make it global, add it to `scripts/always-on.txt` and re-run `activate.sh`.

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
- **Restrictive / unconfirmed licenses** (all flagged in `scripts/sources.txt` and `ATTRIBUTION.md`):
  - `Unity-Technologies/skills` — Unity Companion License, **non-OSI**: usable only for Unity-engine projects.
  - `flowful-ai/cad-skill` — PolyForm Noncommercial, **no commercial use** (installed as `cadquery-noncommercial` so the name carries the warning).
  - `K-Dense-AI/scientific-agent-skills` — top-level MIT but **per-skill licenses vary**; 13 skills are pruned at install by `scripts/kdense-exclude.txt`. Re-run that scan if upstream adds skills.
  - MIT asserted with **no LICENSE file**: `emalorenzo/three-agent-skills`, `Yakoub-ai/phaser4-gamedev`, `multica-ai/andrej-karpathy-skills`, `anthropics/skills`.
  - `indi256s/dataviz-skill` — **no license at all**; local use only, skipped by `bootstrap.sh --public`.
- **Single-maintainer / low-adoption watch:** `ra100/blender-claude-plugin`, `adevra/unity-shader-agent-skills` (one-shot snapshot), `irfad7/claude-power-skills` (adopted on hand-reviewed merit, not reputation), `Harishwarrior/flutter-claude-skills`.
- **Agent-engineering is an open gap.** Tool-design, MCP-depth, agent-evals, and voice-agent skills don't yet exist in credible SKILL.md form. Re-check vendor orgs (OpenAI, LangChain, LlamaIndex, Pipecat, LiveKit, Browserbase) on each sync — this space moves fast.
- **Also still thin:** Kubernetes/SRE depth, native mobile-game engines (Unity/Godot mobile beyond what's installed), AR/VR/WebXR (deliberately out of scope), deep email design.
- **If Anthropic ships official copywriting/typography/audio skills,** prefer them over community equivalents.
- **Caution packs** may change their hooks/installers upstream — re-read `QUARANTINE.md` entries after a sync that updates them.
- **Prune rule:** if a source goes 3+ months without commits and has unaddressed issues, consider dropping it from `manifest.txt`.

## Files you edit vs. files that are generated

| Edit by hand | Generated (don't hand-edit) |
|---|---|
| `scripts/sources.txt`, `scripts/manifest.txt`, `scripts/always-on.txt`, `scripts/kdense-exclude.txt`, `scripts/lib-install.sh`, `scripts/*.sh`, `scripts/gen-docs.py`, `README.md`, `WORKFLOW.md`, `MAINTENANCE.md` | `INDEX.md`, `manifest.json`, `ATTRIBUTION.md`, `MISSING.md`, `QUARANTINE.md` — rebuilt by `install.sh` / `gen-docs.py` |

Category titles shown in `INDEX.md` live in the `CATEGORIES` dict in `scripts/gen-docs.py`; pack descriptions live in the `PACKS` dict there. Adding a new category = add the dict entry, then use it in `manifest.txt` (the folder is created on install).
