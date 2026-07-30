# Workflow — which skill at which stage

A stage-by-stage map for a typical **website / landing-page / app** build, then **game** and **mobile** flows. Names are `category/skill`. ★ = in the always-on core (already global); everything else you activate per project with `scripts/project-activate.sh`.

## Website / landing page / product UI

| Stage | Reach for | Output |
|---|---|---|
| **1. Direction** | ★`00-direction/frontend-design`, ★`00-direction/design-first-ui-prompting`, a card from `14-style-directions/*` | A committed aesthetic + a structured, spec-driven build prompt |
| **2. Copy** | ★`01-copywriting/copywriting`, ★`01-copywriting/landing-page-copy`, `01-copywriting/ogilvy`, `01-copywriting/marketing-psychology`, then ★`01-copywriting/copy-editing` | Hero, value prop, social proof, objections, CTAs — written before layout |
| **3. Structure** | ★`03-page-and-components/landing-page` / `pricing-page`, ★`tailwindcss`, ★`baseline-ui`, `create-design-md`, `pick-ui-library`, + shadcn (per project) | Sections laid out on accessible primitives |
| **4. Fundamentals** | ★`02-fundamentals/better-typography`, ★`better-colors`, ★`better-ui`, `better-layout` | Type scale, OKLCH palette, radius/shadow/spacing system |
| **5. Design system** | ★`08-design-systems/design-tokens`, `08-design-systems/design-system`, `theme-factory`, `brand-identity` | DTCG tokens, theming, brand identity |
| **6. Content & UX** | `10-content-ux/information-architecture`, `form-strategy`, `multi-step-form-design`, `onboarding-wizard-design`, `internationalization` | IA, forms, onboarding, localization |
| **7. Motion** | ★`04-motion/animation-systems` → ★`gsap` / `animation-on-scroll` → `staggered-word-reveal`, `masked-reveal` | A coherent motion language, then specific reveals |
| **8. Effects / 3D** | CSS first: `05-effects/progressive-blur`, `css-border-gradient`, `beautiful-shadows`. 3D only if the hero demands it: `06-3d-webgl/*`, `three-agent-skills` | Visual depth without perf debt |
| **9. Review (taste + motion)** | ★`04-motion/emil-design-eng`, `04-motion/review-animations`, `03-page-and-components/improve-ui` | Motion correctness + taste pass |
| **10. Ship gate** | ★`11-quality-audit/fixing-accessibility`, ★`fixing-metadata`, `11-quality-audit/web-quality/*` (perf, CWV, SEO, a11y), `cro`, `schema` | WCAG, OG/JSON-LD, 60fps, Core Web Vitals, conversion check |

## Games

Game skills live in `13-games/` as **packs** (mostly per-project). Start with the clean spine, layer engine depth as needed:

1. **Spine (clean, any engine):** `13-games/awesome-gamedev` — pick the engine folder (`godot/`, `unity/`, `unreal/`, `web-engines/`) + disciplines (`game-feel`, `procedural-gen`, `shader-programming`, `audio-design`, `game-ui-ux`).
2. **Web / Three.js games:** `13-games/mengto-game-dev` (incl. `build-mobile-threejs-games`, `ship-web-games`) and `13-games/threejs-game` ⚠️ (playable browser games with touch/mobile).
3. **Phaser:** `13-games/phaser4` ⚠️ (incl. `phaser-mobile` = Capacitor/PWA/touch).
4. **Godot depth:** `13-games/godotprompter` ⚠️ (55 skills incl. `mobile-development`, `xr-development`, `shader-basics`, `multiplayer-sync`).
5. **Graphics/shaders for game visuals:** `06-3d-webgl/threejs-graphics` ⚠️, `06-3d-webgl/webgl-anim` ⚠️.

> ⚠️ packs shipped executables/hooks — the markdown is safe and installed; their scripts are in `_quarantine/`. Keep these **per-project**.

## Mobile apps

Pick the lane that matches the stack:

1. **iOS native:** `12-mobile/swiftui-pro` (Paul Hudson — navigation, layout, animation, state, a11y, deprecated-API detection) + `12-mobile/swiftui-expert` ⚠️ (Antoine van der Lee — performance incl. Instruments workflows, iOS 26 Liquid Glass). Discovery pipeline for more Apple-ecosystem skills: [twostraws/Swift-Agent-Skills](https://github.com/twostraws/Swift-Agent-Skills) (directory, per-repo review required).
2. **Android native:** `12-mobile/compose-performance` ⚠️ (skydoves — 26 Jetpack Compose perf skills; start with the `audit` orchestrator, which sequences the rest).
3. **Flutter:** `12-mobile/flutter-*` (official Flutter team — architecture, responsive layout, routing, localization, testing) + `12-mobile/dart-official` (official Dart team) + `flutter-tester` / `owasp-mobile-security-checker` ⚠️ (supplementary).
4. **React Native / Expo:** `12-mobile/expo` ⚠️ (`expo-router`, `expo-ui`, data-fetching, EAS app-stores/workflows) + `12-mobile/react-native-best-practices`, `react-navigation`, `upgrading-react-native`.
5. **Ship to stores:** `12-mobile/aso` (app-store optimization) + `expo/eas-app-stores`.
6. **UX:** reuse `10-content-ux/*` (onboarding, forms) and `02-fundamentals/*`.

## Mobile games

1. **Unity:** `13-games/awesome-gamedev/skills/unity/*` (fundamentals) + `13-games/unity-official` (official Unity — **IAP + LevelPlay ad mediation**, project setup, CLI; ⚠ Unity Companion License: Unity-engine projects only) + `13-games/unity-shaders` (mobile-GPU shader optimization — TBDR, Mali/Adreno, URP).
2. **Godot mobile:** `13-games/godotprompter` ⚠️ (`mobile-development`, `responsive-ui`, `export-pipeline`) + `13-games/godot-dojo` ⚠️ (testing/export workflow).
3. **Web-to-mobile:** `13-games/phaser4` ⚠️ (`phaser-mobile`: Capacitor, PWA, touch) + `13-games/mengto-game-dev` (`build-mobile-threejs-games`, `ship-web-games`).
4. **Monetization/UX design:** `13-games/awesome-gamedev/skills/disciplines/game-feel` + `game-ui-ux`; `unity-official/implement-in-app-purchases` for IAP flow.

## Software engineering (any coding task)

These are the `16-engineering` / `17-ai-llm-eng` / `18-security` categories — usable by any agent (Claude Code, Codex, Cursor). Mostly per-project; pull the pack you need.

1. **Code discipline (universal):** ★`16-engineering/karpathy-guidelines` — Think Before Coding · Simplicity First · Surgical Changes · Goal-Driven Execution. Small, always-on.
2. **Full lifecycle (anchor):** `16-engineering/addyosmani-agent-skills` — code-review, TDD, debugging, git-workflow, docs+ADRs, security-hardening, CI/CD, observability, API design, performance.
3. **Workflow depth:** `16-engineering/superpowers` (obra) — systematic-debugging, git-worktrees, plan writing/execution, subagent-driven development, verification-before-completion.
4. **TypeScript / domain modeling:** `16-engineering/mattpocock-engineering` — domain-modeling, codebase-design, to-spec, resolving-merge-conflicts.
5. **AI/LLM work:** `17-ai-llm-eng/prompt-optimizer` (Sentry) — optimize prompts with evals + model-family adapters. (More context-engineering patterns live inside `addyosmani-agent-skills`.)
6. **Security pass:** `18-security/security-review`, `gha-security-review` (GitHub Actions), and `skill-scanner` — the last also vets *new skills* before you add them to this library.

**One primary per lane (engineering):** TDD/debugging/code-review appear in `addyosmani`, `superpowers`, and `mattpocock`. Default primary: **`superpowers`** for debugging/TDD workflow rigor, **`addyosmani`** for breadth. Pick one per project to avoid conflicting guidance.

## 3D modeling & CAD

1. **Blender:** `19-3d-cad/blender` — geometry nodes, shader nodes, compositing, `bpy` Python scripting, rigging, physics, rendering.
2. **Code-CAD / 3D printing:** `19-3d-cad/openscad` ⚠️ (Armin Ronacher — model → render → STL export; its helper scripts are quarantined, and it expects a local OpenSCAD install) and `19-3d-cad/cadquery-noncommercial` ⚠️ (**PolyForm Noncommercial license — no commercial use**; CadQuery → STL/3MF workflow).
3. **Game-adjacent 3D assets:** reuse `06-3d-webgl/threejs-graphics` (procedural geometry/materials) and `13-games/awesome-gamedev` shader/procgen disciplines.

## Research, science & math

The verified pattern: prose-only "research guidance" is mostly LLM-native; these earn their place by shipping **toolchain workflows** (their scripts are quarantined — re-enable per project after reading them).

1. **Scientific computing & analysis:** `20-research-science/scientific-skills` ⚠️ — 145 skills (license-pruned): sympy (math), matplotlib/polars (analysis), astropy, biopython, deepchem, clinical research, scientific writing. Per-skill licenses vary — check the skill's frontmatter before redistribution.
2. **Formal math / proofs:** `20-research-science/lean4` ⚠️ — Lean 4 workflows (draft → formalize → prove → disprove → review). Full value needs its quarantined toolchain hooks reviewed + a local Lean install.
3. **Data viz:** `09-dataviz` + the built-in `dataviz` skill.

## DevOps & languages

1. **Terraform/IaC:** `16-engineering/terraform` (Anton Babenko — native tests, module structure, state management, CI/CD, trivy/checkov).
2. **Go:** `16-engineering/golang` ⚠️ (samber — 46 skills: style, testing, concurrency, DB, DI, observability, security).
3. **Rust:** `16-engineering/rust-skills` ⚠️ (leonardomso — 265 rules, Rust 1.96/2024 edition).
4. **General CI/CD & observability:** `16-engineering/addyosmani-agent-skills` (ci-cd-and-automation, observability-and-instrumentation).

## Marketing & growth (organic-first)

1. **Strategy:** `21-marketing/marketing-plan`, `marketing-ideas`, `marketing-loops` (compounding growth loops), `content-strategy`.
2. **Organic / social:** `21-marketing/social` (social-media marketing), `community-marketing`, `influencer-marketing`, `public-relations`, `co-marketing`, `referrals`.
3. **SEO:** haines `21-marketing/programmatic-seo` + `ai-seo` (AI-search/answer-engine era) + `site-architecture`; rampstack depth per task — `seo-keyword`/`seo-keyword-gap-audit` (research), `seo-onpage`/`seo-technical`/`seo-site-health-audit` (fix), `seo-backlink-audit`/`seo-offpage` (authority), `seo-rank-tracking`/`seo-traffic-diagnosis` (monitor), `seo-aeo-geo` (AI answer engines), `seo-audit-orchestration` (runs the others). Ship-gate basics stay in `11-quality-audit` (`seo-audit`, `schema`, `fixing-metadata`).
4. **Content ops:** `21-marketing/pillar-content-architecture`, `content-distribution`, `content-repurposing`, `content-refresh-system`.
5. **Conversion & monetization:** `21-marketing/offers`, `pricing`, `lead-magnets`, `popups`, `signup`, `free-tools`, `launch`; measure with `analytics` + `attribution`. (CRO itself: `11-quality-audit/cro` + `ab-testing`.)
6. **Copy for all of it:** `01-copywriting/*` (see stage 2 of the website flow).

## AI / LLM & agent engineering

1. **Build agent tools:** `17-ai-llm-eng/mcp-builder` (Anthropic — MCP servers) + the env's `claude-api` skill.
2. **Author skills:** `17-ai-llm-eng/skill-creator` (Anthropic) + `skill-writer` (Sentry) + `16-engineering/superpowers/writing-skills`.
3. **Prompts & context:** `17-ai-llm-eng/prompt-optimizer` (Sentry, evals-driven) + `16-engineering/addyosmani-agent-skills/context-engineering`.
4. **Multi-agent:** `17-ai-llm-eng/coordinator-mode` (wave planning, dependency ordering, dispatch/merge protocol) + `16-engineering/superpowers` — `subagent-driven-development`, `dispatching-parallel-agents`.
5. **Memory & context:** `17-ai-llm-eng/context-compression` (3-layer pipeline), `kairos-session` / `session-review` (session lifecycle + handoffs), `autodream` (cross-session memory synthesis).
6. **Safety:** `18-security/skill-scanner` before adopting any third-party skill.

## One primary per lane (avoid conflicting guidance)

Several skills overlap. Pick one primary; the others are benched alternatives:

- **UI polish / review:** primary ★`03-page-and-components/improve-ui` (ibelick). Alt: `02-fundamentals/better-ui` (krehel).
- **Motion review:** primary ★`04-motion/emil-design-eng` + `review-animations` (Emil). `raphaelsalaja/userinterface-wiki` (12-principles) was **not installed** — Emil covers this lane.
- **Accessibility:** primary ★`11-quality-audit/fixing-accessibility` (ibelick). Alts: `11-quality-audit/accessibility-audit` (rampstack), `11-quality-audit/web-quality/accessibility` (Addy Osmani), `02-fundamentals/better-accessibility` (krehel).
- **Performance/CWV:** primary `11-quality-audit/web-quality/*` (Addy Osmani/Google). Alts: `11-quality-audit/fixing-motion-performance`, `optimize-web-animations`, `performance-profiling`.
- **SEO:** primary `11-quality-audit/seo-audit` (Haines) + `schema`. (Meng To's `seo-audit` no longer exists upstream — see `MISSING.md`.)
- **Design system:** primary ★`08-design-systems/design-tokens` (DTCG). Companion: `08-design-systems/design-system` (rampstack, process-level).
