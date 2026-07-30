#!/usr/bin/env python3
"""gen-docs.py — generate INDEX.md and manifest.json from the installed skills/ tree.
Reads each skill's real SKILL.md frontmatter + SOURCE.md. Safe to re-run (idempotent)."""
import json, os, re, datetime, sys

LIB = os.environ.get("SKILLS_LIB") or os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKILLS = os.path.join(LIB, "skills")
TODAY = datetime.date.today().isoformat()

CATEGORIES = {
 "00-direction": "Direction — aesthetic direction & structured prompting (invoked first)",
 "01-copywriting": "Copywriting — marketing, conversion & email copy (words before pixels)",
 "02-fundamentals": "Fundamentals — typography, color, UI primitives",
 "03-page-and-components": "Page & Components — page structure, Tailwind, component libraries",
 "04-motion": "Motion — animation systems, GSAP, motion taste & review",
 "05-effects": "Effects — CSS effects, generative & creative-coding",
 "06-3d-webgl": "3D / WebGL — Three.js, R3F, GLSL/TSL shaders, procedural graphics",
 "07-audio": "Audio — UI sound design & Web Audio (game audio lives in 13-games)",
 "08-design-systems": "Design Systems, Tokens & Brand — tokens, theming, brand identity",
 "09-dataviz": "Data Viz — charts, dashboards, analytics UIs",
 "10-content-ux": "Content & UX — product writing, forms, onboarding, IA, research, i18n",
 "11-quality-audit": "Quality & Audit — a11y, metadata, performance/CWV, SEO, CRO (ship gate)",
 "12-mobile": "Mobile — React Native/Expo, app stores, ASO",
 "13-games": "Games — web/native/mobile game dev, game feel, generative (packs; mostly per-project)",
 "14-style-directions": "Style Directions — reusable Meng To stylecards",
 "15-workflow-capture": "Workflow Capture — inspiration → prompt pipelines",
 "16-engineering": "Engineering — software-engineering lifecycle: code review, TDD, debugging, git, docs, architecture, CI/CD",
 "17-ai-llm-eng": "AI / LLM Engineering — prompt optimization, evals, context engineering",
 "18-security": "Security Engineering — secure coding, security review, skill & supply-chain scanning",
}

# Hand-written descriptions for multi-skill packs (which have no single root SKILL.md).
PACKS = {
 "three-agent-skills": ("Ema Lorenzo — Three.js + React Three Fiber best-practice rules incl. GLSL & TSL shaders. Markdown-only, clean.", False),
 "threejs-graphics": ("scottstts — Three.js/WebGPU graphics: GLSL/TSL shaders, PBR, procedural geometry/planets/vegetation, water, post-FX (bloom/SSAO/color-grading). NOTE: example scene code stripped to _quarantine; ships an npx installer (quarantined).", True),
 "webgl-anim": ("iart-ai — GLSL fragment shaders, Three.js animation, particle systems. Ships bash capture scripts + plugin config (quarantined).", True),
 "web-quality": ("Addy Osmani (Google) — web-quality-audit, performance, core-web-vitals (LCP/INP/CLS), accessibility (WCAG 2.2), seo, best-practices. Ships analyze.sh + marketplace tooling (quarantined).", True),
 "expo": ("Official Expo team — React Native/Expo/EAS: expo-router, expo-ui/native-ui, data-fetching, native modules, EAS app-stores/workflows. Ships build scripts + hooks + MCP dependency (quarantined).", True),
 "mengto-game-dev": ("Meng To — web/Three.js game skills incl. build-mobile-threejs-games, ship-web-games, game audio/camera/inventory/VFX, enemy AI, encounters.", True),
 "awesome-gamedev": ("gamedev-skills — markdown-only game-dev spine + router across Godot/Unity/Unreal/Phaser/PixiJS/Three.js/Bevy/pygame/LÖVE/Roblox + disciplines (shaders, procgen, game-feel, audio, UI/UX, physics, cameras, perf) + genres.", False),
 "godotprompter": ("jame581 — Godot 4.x (GDScript + C#): 2D/3D, shaders, mobile-development, multiplayer, XR, procgen, HUD/UI. Repo-root SessionStart hook + tooling (quarantined).", True),
 "phaser4": ("Yakoub-ai — Phaser 4 incl. phaser-mobile (Capacitor/PWA/touch), matter physics, audio, UI, tilemap, saveload, headless playtest. Ships PreToolUse+SessionStart hooks + shell scripts (quarantined); license unconfirmed.", True),
 "threejs-game": ("majidmanzarpour — playable browser Three.js games (director, gameplay systems, AAA graphics, game UI, audio, QA) with touch/mobile-viewport support. Ships install.sh + credential-probe + TS scaffold (quarantined).", True),
 "design-tokens": ("ilikescience (Matt Ström-Awn) — expert DTCG design-tokens guidance. Clean, MIT.", False),
 "dataviz-skill": ("indi256s — data-visualization guidance. Clean code, but NO LICENSE (unspecified — local use only, do not redistribute).", False),
 "addyosmani-agent-skills": ("Addy Osmani (Google/Chrome) — 24-skill production SWE lifecycle: code-review, TDD, debugging, git-workflow, docs+ADRs, security-hardening, CI/CD, observability, API design, performance, context-engineering, spec-driven. Ships SessionStart hook + scripts (quarantined).", True),
 "superpowers": ("Jesse Vincent (obra) — the most-starred Claude skills repo: TDD, systematic-debugging, requesting/receiving code-review, git-worktrees, plan writing/execution, subagent-driven development, verification-before-completion. Ships 38 shell scripts + SessionStart hook + per-harness plugin dirs (quarantined).", True),
 "mattpocock-engineering": ("Matt Pocock (Total TypeScript) — engineering skills: code-review, tdd, diagnosing-bugs, domain-modeling, codebase-design, improve-codebase-architecture, resolving-merge-conflicts, to-spec, to-tickets, triage. Ships shell scripts incl. a git-guardrail hook (quarantined).", True),
}

def parse_frontmatter(path):
    """Return dict of top-level scalar keys from YAML frontmatter (handles > and | folding)."""
    try:
        text = open(path, encoding="utf-8", errors="replace").read()
    except OSError:
        return {}
    m = re.match(r"^---\s*\n(.*?)\n---", text, re.S)
    if not m:
        return {}
    body = m.group(1)
    out, key, buf, folding = {}, None, [], False
    for line in body.split("\n"):
        km = re.match(r"^([A-Za-z0-9_-]+):\s?(.*)$", line)
        if km and (not folding or not line.startswith((" ", "\t"))):
            if key is not None:
                out[key] = " ".join(x.strip() for x in buf).strip()
            key = km.group(1)
            val = km.group(2)
            if val in (">", "|", ">-", "|-", ">+", "|+"):
                buf, folding = [], True
            else:
                buf, folding = [val], False
        else:
            if key is not None:
                buf.append(line.strip())
    if key is not None:
        out[key] = " ".join(x.strip() for x in buf).strip()
    for k in out:
        out[k] = out[k].strip().strip('"').strip("'").strip()
    return out

def source_meta(d):
    """Read SOURCE.md at dir d -> (repo_key_url, license, author)."""
    p = os.path.join(d, "SOURCE.md")
    repo = lic = author = ""
    if os.path.isfile(p):
        for line in open(p, encoding="utf-8", errors="replace"):
            if line.startswith("- Repo:"): repo = line.split(":",1)[1].strip()
            elif line.startswith("- License:"): lic = line.split(":",1)[1].strip()
            elif line.startswith("- Author:"): author = line.split(":",1)[1].strip()
    return repo, lic, author

def count_skills(d):
    n = 0
    for _, _, files in os.walk(d):
        if "SKILL.md" in files: n += 1
    return n

# always-on set
always = set()
alist = os.path.join(LIB, "scripts", "always-on.txt")
if os.path.isfile(alist):
    for line in open(alist):
        line = line.split("#",1)[0].strip()
        if line: always.add(line)

def is_always(catname):
    return any(a == catname or a.startswith(catname + "/") for a in always)

entries = []          # for manifest
index_lines = []
totals = {}

for cat in sorted(CATEGORIES):
    cdir = os.path.join(SKILLS, cat)
    if not os.path.isdir(cdir): continue
    names = sorted(n for n in os.listdir(cdir) if os.path.isdir(os.path.join(cdir, n)))
    if not names: continue
    index_lines.append(f"\n## {CATEGORIES[cat]}\n")
    totals[cat] = 0
    for name in names:
        d = os.path.join(cdir, name)
        catname = f"{cat}/{name}"
        repo, lic, author = source_meta(d)
        star = "★ " if is_always(catname) else ""
        if os.path.isfile(os.path.join(d, "SKILL.md")):
            fm = parse_frontmatter(os.path.join(d, "SKILL.md"))
            desc = fm.get("description", "").replace("\n", " ").strip()
            kind, sc, caution = "skill", 1, False
        else:
            pdesc, caution = PACKS.get(name, ("(multi-skill pack)", False))
            desc = pdesc
            sc = count_skills(d)
            kind = "pack"
        totals[cat] += sc
        short = (desc[:200] + "…") if len(desc) > 200 else desc
        tag = ""
        if kind == "pack": tag += f" _(pack: {sc} skills)_"
        if caution: tag += " ⚠️"
        src = re.sub(r"^https?://github.com/", "", repo).rstrip("/") if repo else "—"
        index_lines.append(f"- {star}**{name}** — `{src}`{tag} — {short}")
        entries.append({
            "name": name, "category": cat, "kind": kind,
            "path": f"skills/{catname}", "skill_count": sc,
            "source_url": repo, "license": lic, "author": author,
            "always_on": is_always(catname), "caution": caution,
            "purpose": desc,
        })

total_units = len(entries)
total_skills = sum(totals.values())

# ---- INDEX.md ----
with open(os.path.join(LIB, "INDEX.md"), "w", encoding="utf-8") as f:
    f.write("# Skills-Library — Index\n\n")
    f.write(f"_Generated {TODAY}. {total_units} top-level entries · {total_skills} total skills across {len(totals)} categories._\n\n")
    f.write("★ = part of the always-on core set (symlinked into `~/.claude/skills`). ")
    f.write("⚠️ = source shipped executables/hooks (quarantined; see `QUARANTINE.md`). ")
    f.write("_(pack: N skills)_ = a multi-skill folder — browse it or activate individual skills per-project.\n")
    f.write("\n> Packs are installed as one folder holding many skills; they are mostly **per-project** (see `WORKFLOW.md`). ")
    f.write("Game packs especially: activate only what a project needs via `scripts/project-activate.sh`.\n")
    counts = " · ".join(f"{c.split('-',1)[1]} {totals[c]}" for c in sorted(totals))
    f.write(f"\n**Per-category counts:** {counts}\n")
    f.write("\n".join(index_lines))
    f.write("\n")

# ---- manifest.json ----
manifest = {
    "generated": TODAY,
    "library_path": "~/Desktop/Skills-Library",
    "total_top_level_entries": total_units,
    "total_skills": total_skills,
    "categories": [{"key": c, "title": CATEGORIES[c], "skill_count": totals[c]} for c in sorted(totals)],
    "always_on": sorted(always),
    "skills": entries,
}
with open(os.path.join(LIB, "manifest.json"), "w", encoding="utf-8") as f:
    json.dump(manifest, f, indent=2, ensure_ascii=False)

# ---- ATTRIBUTION.md ----
seen = {}
for e in entries:
    url = e["source_url"]
    if url and url not in seen:
        seen[url] = (e["author"] or "—", e["license"] or "—")
with open(os.path.join(LIB, "ATTRIBUTION.md"), "w", encoding="utf-8") as f:
    f.write("# Attribution & Credits\n\n")
    f.write(f"_Generated {TODAY}. Every skill in this library is the work of its original author, used under the license shown below and in each skill's `SOURCE.md`._\n\n")
    f.write("**This library is a curated index + installer. It claims no ownership of the skills themselves.** ")
    f.write("The original contributions here are the `scripts/`, `manifest.txt`, and the generated documentation — everything under `skills/` belongs to the authors credited below.\n\n")
    f.write(f"## Sources ({len(seen)})\n\n| Source repo | Author | License |\n|---|---|---|\n")
    for url in sorted(seen, key=lambda u: seen[u][0].lower()):
        author, lic = seen[url]
        short = re.sub(r"^https?://github.com/", "", url).rstrip("/")
        f.write(f"| [{short}]({url}) | {author} | {lic} |\n")
    f.write("\n## Redistribution notes\n\n")
    f.write("- Skills retain their original licenses — see each skill's `SOURCE.md` and the upstream repo's `LICENSE`.\n")
    f.write("- Sources flagged `NO-LICENSE`, `LICENSE-UNCONFIRMED`, or `LICENSE-INCONSISTENT` in `scripts/sources.txt` must be resolved before any public redistribution of their content.\n")
    f.write("- The recommended way to share this publicly is as a **curation layer** (gitignore `skills/`; users run `scripts/bootstrap.sh` to pull each skill from its upstream) — this avoids redistributing others' work entirely.\n")

print(f"INDEX.md + manifest.json + ATTRIBUTION.md generated: {total_units} entries, {total_skills} skills, {len(totals)} categories.")
