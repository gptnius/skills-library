# Skills-Library

A curated, documented, locally-accessible library of **AI agent skills** (`SKILL.md` packages) for building **websites, apps, and games** — UI, UX, copywriting, motion, 3D/WebGL, effects, design systems, data viz, mobile, game development, and the **software-engineering lifecycle** (code review, TDD, debugging, CI/CD, security, AI/LLM).

**Built 2026-07-30 · 413 skills · 144 top-level entries · 19 categories · 28 vetted source repos.**

Every skill was pulled from a named source repo, security-reviewed, and stripped of executable code before install. See [`INDEX.md`](INDEX.md) for the full catalog and [`WORKFLOW.md`](WORKFLOW.md) for which skill to reach for at each stage.

---

## The two-layer model

```
LIBRARY (source of truth)          ACTIVATION (what agents load)
~/Desktop/Skills-Library/    ──►    ~/.claude/skills/         (global always-on set)
                             ──►    <project>/.claude/skills/ (per-project, situational)
```

Claude Code only discovers skills as **immediate** subdirectories of `~/.claude/skills/` or `<project>/.claude/skills/` (each containing a `SKILL.md`). This library keeps everything organized in **numbered category folders** for browsing, then *activates* a chosen subset by symlinking it **flat** into those locations. Edit a skill once here; every project that links it sees the change.

- **Library = categorized** (`skills/00-direction/…` → `skills/15-workflow-capture/…`) for navigation.
- **Activation = flat** because the loader doesn't scan nested folders.

---

## Quick start

> **This repo is a curation layer, not a mirror.** It ships the scripts, manifest, and docs — *not* the skills. `bootstrap.sh` pulls each skill from its author's upstream repo and builds `skills/` locally. Nothing here redistributes anyone's work; see [`ATTRIBUTION.md`](ATTRIBUTION.md).

```bash
LIB="$HOME/Desktop/Skills-Library"   # or wherever you cloned this repo (scripts self-locate)

# FIRST TIME / fresh machine: build the library locally (clones sources, extracts markdown,
# quarantines executables). Takes a few minutes; needs git + python3.
"$LIB/scripts/bootstrap.sh"           # or: bootstrap.sh --public   (skip no-license sources)

# activate the always-on core set globally (symlinks ~18 skills into ~/.claude/skills)
"$LIB/scripts/activate.sh"            # or: activate.sh --copy   (if symlinks misbehave)

# then RESTART your Claude Code session and run /skills to verify they load

# add situational skills to a specific project (does not bloat your global context)
"$LIB/scripts/project-activate.sh" ~/code/mygame 13-games/awesome-gamedev
"$LIB/scripts/project-activate.sh" ~/code/site  06-3d-webgl 04-motion/gsap

# remove this library's global skills (leaves unrelated skills alone)
"$LIB/scripts/deactivate.sh"

# refresh sources + rebuild + regenerate docs (run monthly)
"$LIB/scripts/sync.sh"
```

> **Activation requires a Claude Code session restart to take effect.** The `name` + `description` of every activated skill loads into context at session start, which is why the always-on set is deliberately small (~18); everything else stays in the library and is activated per project.

---

## Docs in this library

| File | What it is |
|---|---|
| [`INDEX.md`](INDEX.md) | Every installed skill, grouped by category, one line each. ★ = always-on, ⚠️ = had quarantined code. **The file to skim when deciding what to use.** |
| [`WORKFLOW.md`](WORKFLOW.md) | Stage-by-stage map: which skills at direction → copy → structure → motion → 3D → review → ship, plus game & mobile flows. |
| [`MAINTENANCE.md`](MAINTENANCE.md) | How to update, add, remove skills; watch-items. |
| [`QUARANTINE.md`](QUARANTINE.md) | Every executable/hook file that shipped with a source, why it's quarantined, and where it lives. Nothing here runs unless you run it. |
| [`MISSING.md`](MISSING.md) | Brief-listed skills that no longer exist upstream (source drift). |
| [`manifest.json`](manifest.json) | Machine-readable mirror of the index for future sessions. |

---

## Source repositories

**Security posture:** only markdown + reference material was installed. Every `.sh/.mjs/.cjs/.js/.ts/.py/.cmd` file, and every agent hook / plugin / installer, was excluded from `skills/` and copied to `_quarantine/` for review. **Zero executables live under `skills/`.**

### Foundation (UI / UX / copy / motion / effects)

| Repo | Author | License | Notes |
|---|---|---|---|
| [MengTo/Skills](https://github.com/MengTo/Skills) | Meng To (Design+Code) | MIT | Landing/motion/effects/style/game/workflow. Some demo JS quarantined. `web-design` skills are upstream-draft. |
| [anthropics/skills](https://github.com/anthropics/skills) | Anthropic (official) | per-repo (no root LICENSE) | `frontend-design`, `brand-guidelines`, `theme-factory`, `canvas-design`, `algorithmic-art`, `webapp-testing`. Ships Python by design → quarantined. |
| [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | Corey Haines | MIT | Conversion copy, CRO, SEO, email, onboarding, ASO. Repo-root tool CLIs not copied. |
| [rampstackco/claude-skills](https://github.com/rampstackco/claude-skills) | RampStack | MIT | Broad lifecycle catalog (~102 unique). Source of brand/i18n/forms/research/design-system gap-fillers. Catalog-quality — verify specifics. |
| [jakubkrehel/skills](https://github.com/jakubkrehel/skills) | Jakub Krehel | MIT | `better-*` design-engineering primitives. Clean. |
| [emilkowalski/skills](https://github.com/emilkowalski/skills) | Emil Kowalski | MIT | Motion judgment + Apple design + review/improve. Clean. |
| [ibelick/ui-skills](https://github.com/ibelick/ui-skills) | Julien Thibeaut | MIT | `baseline-ui`, `improve-ui`, `fixing-*`. Site tooling not copied. |
| [lottiefiles/motion-design-skill](https://github.com/lottiefiles/motion-design-skill) | LottieFiles (official) | MIT | Implementation-agnostic motion direction. Clean. |
| [boraoztunc/skills](https://github.com/boraoztunc/skills) | Bora Öztunç | MIT/Apache — inconsistent | **Only `ogilvy/` installed** (headline/big-idea craft). Rest of repo not copied. |
| [raphaelsalaja/userinterface-wiki](https://github.com/raphaelsalaja/userinterface-wiki) | Raphael Salaja | see license.md | Cloned but **not installed** — motion-review lane covered by Emil (per brief §6). |

### Additions from deep-research (games / 3D / tokens / mobile / web-quality)

| Repo | Author | License | Security |
|---|---|---|---|
| [gamedev-skills/awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) | gamedev-skills | Apache-2.0 | ✅ clean — the game-dev spine (66 skills) |
| [ilikescience/design-tokens-skill](https://github.com/ilikescience/design-tokens-skill) | Matt Ström-Awn | MIT | ✅ clean — DTCG tokens |
| [emalorenzo/three-agent-skills](https://github.com/emalorenzo/three-agent-skills) | Ema Lorenzo | MIT per README (unconfirmed) | ✅ markdown-only |
| [expo/skills](https://github.com/expo/skills) | Expo / 650 Industries (official) | MIT | ⚠️ build scripts + hooks + MCP dep quarantined |
| [addyosmani/web-quality-skills](https://github.com/addyosmani/web-quality-skills) | Addy Osmani (Google) | MIT | ⚠️ analyze.sh + marketplace tooling quarantined |
| [callstackincubator/agent-skills](https://github.com/callstackincubator/agent-skills) | Callstack | MIT | ⚠️ only RN skills installed; vendored tooling not copied |
| [scottstts/Threejs-Awesome-Graphics-Agent-Skills](https://github.com/scottstts/Threejs-Awesome-Graphics-Agent-Skills) | scottstts | MIT | ⚠️ npx installer + example code quarantined |
| [jame581/GodotPrompter](https://github.com/jame581/GodotPrompter) | jame581 | MIT | ⚠️ SessionStart hook + tooling quarantined |
| [Yakoub-ai/phaser4-gamedev](https://github.com/Yakoub-ai/phaser4-gamedev) | Yakoub-ai | MIT per README (unconfirmed) | ⚠️ PreToolUse+SessionStart hooks + shell scripts quarantined |
| [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) | majidmanzarpour | MIT | ⚠️ install.sh + credential-probe + TS scaffold quarantined |
| [iart-ai/webgl-animation-skills](https://github.com/iart-ai/webgl-animation-skills) | iart-ai | MIT | ⚠️ bash capture scripts + plugin config quarantined |

### Gap-fill candidates (vetted during build)

| Repo | Author | License | Result |
|---|---|---|---|
| [dannyjpwilliams/ui-sound-design-skill](https://github.com/dannyjpwilliams/ui-sound-design-skill) | Danny Williams | MIT | Installed (`07-audio`). ⚠️ one `.mjs` quarantined. |
| [indi256s/dataviz-skill](https://github.com/indi256s/dataviz-skill) | indi256s | **UNSPECIFIED (no LICENSE)** | Installed (`09-dataviz`). Code clean, but **treat as all-rights-reserved — local use only, do not redistribute.** |

---

### Software-engineering additions (2nd research pass)

| Repo | Author | License | Security |
|---|---|---|---|
| [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | Forrest Chang / Multica (packaging Karpathy's coding-pitfalls notes) | MIT asserted, no LICENSE file | ✅ clean markdown |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Addy Osmani (Google) | MIT | ⚠️ SessionStart hook + scripts quarantined |
| [obra/superpowers](https://github.com/obra/superpowers) | Jesse Vincent | MIT | ⚠️ 38 shell scripts + hook + plugin dirs quarantined |
| [getsentry/skills](https://github.com/getsentry/skills) | Sentry (official) | Apache-2.0 | ⚠️ Python scripts quarantined; cherry-picked 7 cross-domain skills |
| [mattpocock/skills](https://github.com/mattpocock/skills) | Matt Pocock (Total TypeScript) | MIT | ⚠️ shell scripts incl. git-guardrail hook quarantined; only `skills/engineering/` installed |

> **Handy for this library itself:** `18-security/skill-scanner` (from Sentry) statically scans agent skills for prompt-injection, malicious code, and excessive permissions — a good tool to run against any *future* skill before you add it.
>
> **Deliberately avoided:** `swarmclawai/andrej-karpathy-skills` (npm-installer fork of the Karpathy skill) and `muratcankoylan/agent-skills-for-context-engineering` (hype-spike repo shipping macOS launchd daemons that run HTTP-fetch loops).

## Special cases & known gaps

- **shadcn/ui** is *not* vendored. Install it per-project with the official tooling: `npx shadcn@latest mcp init` (see <https://ui.shadcn.com/docs/skills>). Pairs with `03-page-and-components/baseline-ui`.
- **Data viz:** a first-party Anthropic `dataviz` skill also ships with Claude Code independently of this library; `09-dataviz/dataviz-skill` is a community complement (license caveat above).
- **Still thin / unfilled** (documented in `MISSING.md`): dedicated **native mobile-game** engines (Unity/Godot mobile beyond GodotPrompter's one skill), standalone **AR/VR/WebXR** (partial via GodotPrompter `xr-development`), deep **email design** systems, deep **DevOps/SRE** (Kubernetes, Terraform/IaC, incident response — partial via `addyosmani-agent-skills` CI/CD + observability), and **Rust/Go** language best-practices. Game **audio**, **shaders**, **procedural generation**, **i18n**, **brand identity**, **forms/onboarding**, and **user research** are covered via the packs and gap-fillers noted in `INDEX.md`.
- **Caution packs** (`⚠️` in the index) are best kept **per-project**, not global — activate only what a project needs with `project-activate.sh`.

## License & attribution

The original work here — `scripts/`, `manifest.txt`, and the generated docs — is [MIT licensed](LICENSE). **The skills themselves are not vendored in this repo** and remain the property of their authors under their own licenses; `bootstrap.sh` pulls each from its upstream source. Full credits, per-source licenses, and redistribution notes are in [`ATTRIBUTION.md`](ATTRIBUTION.md). If you author skills and want your work removed from the manifest, open an issue.

## Provenance

Built by Claude Code from the brief `UI-UX-Skills-Build-Brief.md` (foundation manifest) plus a deep-research pass (`deep-research` workflow) that found the games/3D/tokens/mobile/web-quality additions. Every skill folder carries a `SOURCE.md` (repo, path, author, license, pull date). This repo tracks only the curation layer (scripts + manifest + docs); `skills/`, `_quarantine/`, and `.sources/` are gitignored build artifacts, rebuilt locally by `bootstrap.sh` / `sync.sh`.
