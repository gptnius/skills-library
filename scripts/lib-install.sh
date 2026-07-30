#!/usr/bin/env bash
# lib-install.sh — install engine for the Skills-Library.
# Sourced by install.sh (build + sync). Bash 3.2 compatible (no associative arrays).
#
# Public functions:
#   install_one  KEY  RELPATH  CATEGORY  NAME     # one skill dir -> skills/CATEGORY/NAME/
#   install_pack KEY  RELPATH  CATEGORY  PACKNAME # a whole multi-skill subtree -> skills/CATEGORY/PACKNAME/
#
# Both copy MARKDOWN + reference material only (no .sh/.mjs/.cjs/.js/.ts/.py/.cmd, no hook/plugin dirs),
# and route any executable/hook files found to _quarantine/, logging QUARANTINE.md.
# Missing skills are logged to MISSING.md.

LIB="${LIB:-${SKILLS_LIB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}}"
TODAY="${TODAY:-$(date +%Y-%m-%d)}"

MISSING="$LIB/MISSING.md"
QUARANTINE="$LIB/QUARANTINE.md"

# ---- per-source metadata (case-based; bash 3.2 safe) ----
meta_url() { case "$1" in
  mengto) echo "https://github.com/MengTo/Skills";;
  anthropic) echo "https://github.com/anthropics/skills";;
  haines) echo "https://github.com/coreyhaines31/marketingskills";;
  rampstack) echo "https://github.com/rampstackco/claude-skills";;
  krehel) echo "https://github.com/jakubkrehel/skills";;
  emil) echo "https://github.com/emilkowalski/skills";;
  ibelick) echo "https://github.com/ibelick/ui-skills";;
  salaja) echo "https://github.com/raphaelsalaja/userinterface-wiki";;
  bora) echo "https://github.com/boraoztunc/skills";;
  lottie) echo "https://github.com/lottiefiles/motion-design-skill";;
  awesome-gamedev) echo "https://github.com/gamedev-skills/awesome-gamedev-agent-skills";;
  design-tokens) echo "https://github.com/ilikescience/design-tokens-skill";;
  three-agent) echo "https://github.com/emalorenzo/three-agent-skills";;
  expo) echo "https://github.com/expo/skills";;
  web-quality) echo "https://github.com/addyosmani/web-quality-skills";;
  callstack) echo "https://github.com/callstackincubator/agent-skills";;
  threejs-graphics) echo "https://github.com/scottstts/Threejs-Awesome-Graphics-Agent-Skills";;
  godotprompter) echo "https://github.com/jame581/GodotPrompter";;
  phaser4) echo "https://github.com/Yakoub-ai/phaser4-gamedev";;
  threejs-game) echo "https://github.com/majidmanzarpour/threejs-game-skills";;
  webgl-anim) echo "https://github.com/iart-ai/webgl-animation-skills";;
  ui-sound) echo "https://github.com/dannyjpwilliams/ui-sound-design-skill";;
  dataviz-skill) echo "https://github.com/indi256s/dataviz-skill";;
  karpathy) echo "https://github.com/multica-ai/andrej-karpathy-skills";;
  addyosmani-eng) echo "https://github.com/addyosmani/agent-skills";;
  superpowers) echo "https://github.com/obra/superpowers";;
  getsentry) echo "https://github.com/getsentry/skills";;
  mattpocock) echo "https://github.com/mattpocock/skills";;
  swiftui-hudson) echo "https://github.com/twostraws/SwiftUI-Agent-Skill";;
  swiftui-avdlee) echo "https://github.com/AvdLee/SwiftUI-Agent-Skill";;
  compose-perf) echo "https://github.com/skydoves/compose-performance-skills";;
  dart-official) echo "https://github.com/dart-lang/skills";;
  flutter-official) echo "https://github.com/flutter/agent-plugins";;
  flutter-harish) echo "https://github.com/Harishwarrior/flutter-claude-skills";;
  unity-official) echo "https://github.com/Unity-Technologies/skills";;
  unity-shaders) echo "https://github.com/adevra/unity-shader-agent-skills";;
  godot-dojo) echo "https://github.com/Randroids-Dojo/skills";;
  blender-ra100) echo "https://github.com/ra100/blender-claude-plugin";;
  agent-stuff) echo "https://github.com/mitsuhiko/agent-stuff";;
  cad-skill) echo "https://github.com/flowful-ai/cad-skill";;
  kdense) echo "https://github.com/K-Dense-AI/scientific-agent-skills";;
  lean4) echo "https://github.com/cameronfreer/lean4-skills";;
  terraform-skill) echo "https://github.com/antonbabenko/terraform-skill";;
  golang-skills) echo "https://github.com/samber/cc-skills-golang";;
  rust-skills) echo "https://github.com/leonardomso/rust-skills";;
  power-skills) echo "https://github.com/irfad7/claude-power-skills";;
  *) echo "unknown";; esac; }

meta_author() { case "$1" in
  mengto) echo "Meng To (Design+Code)";;
  anthropic) echo "Anthropic";;
  haines) echo "Corey Haines";;
  rampstack) echo "RampStack";;
  krehel) echo "Jakub Krehel";;
  emil) echo "Emil Kowalski";;
  ibelick) echo "Julien Thibeaut (ibelick)";;
  salaja) echo "Raphael Salaja";;
  bora) echo "Bora Oztunc";;
  lottie) echo "LottieFiles";;
  awesome-gamedev) echo "gamedev-skills";;
  design-tokens) echo "Matt Strom-Awn (ilikescience)";;
  three-agent) echo "Ema Lorenzo (emalorenzo)";;
  expo) echo "Expo / 650 Industries";;
  web-quality) echo "Addy Osmani (Google)";;
  callstack) echo "Callstack";;
  threejs-graphics) echo "scottstts";;
  godotprompter) echo "jame581";;
  phaser4) echo "Yakoub-ai";;
  threejs-game) echo "majidmanzarpour";;
  webgl-anim) echo "iart-ai";;
  ui-sound) echo "Danny Williams (dannyjpwilliams)";;
  dataviz-skill) echo "indi256s";;
  karpathy) echo "Forrest Chang / Multica (packaging Andrej Karpathy's coding-pitfalls notes)";;
  addyosmani-eng) echo "Addy Osmani (Google)";;
  superpowers) echo "Jesse Vincent (obra)";;
  getsentry) echo "Sentry (getsentry, official)";;
  mattpocock) echo "Matt Pocock (Total TypeScript)";;
  swiftui-hudson) echo "Paul Hudson (Hacking with Swift)";;
  swiftui-avdlee) echo "Antoine van der Lee (SwiftLee) & Omar Elsayed";;
  compose-perf) echo "Jaewoong Eum (skydoves, GDE Android/Kotlin)";;
  dart-official) echo "Dart team (dart-lang, official)";;
  flutter-official) echo "Flutter team (official)";;
  flutter-harish) echo "Harishwarrior";;
  unity-official) echo "Unity Technologies (official)";;
  unity-shaders) echo "Anil Devran (adevra)";;
  godot-dojo) echo "Randroids Dojo";;
  blender-ra100) echo "ra100";;
  agent-stuff) echo "Armin Ronacher (mitsuhiko, creator of Flask/Jinja2)";;
  cad-skill) echo "Nicolas Chourrout (Flowful.ai)";;
  kdense) echo "K-Dense Inc.";;
  lean4) echo "Cameron Freer (cfreer.org)";;
  terraform-skill) echo "Anton Babenko (AWS Community Hero, terraform-aws-modules)";;
  golang-skills) echo "Samuel Berthe (samber, author of lo/mo/do)";;
  rust-skills) echo "Leonardo Maldonado (leonardomso, 33-js-concepts)";;
  power-skills) echo "irfad7 (low-profile; content hand-reviewed before adoption)";;
  *) echo "unknown";; esac; }

meta_license() { case "$1" in
  mengto|haines|rampstack|krehel|emil|ibelick|lottie) echo "MIT";;
  design-tokens|expo|web-quality|callstack|threejs-graphics|godotprompter|threejs-game|webgl-anim|ui-sound) echo "MIT";;
  addyosmani-eng|superpowers|mattpocock) echo "MIT";;
  swiftui-hudson|swiftui-avdlee|flutter-harish|unity-shaders|godot-dojo) echo "MIT";;
  compose-perf) echo "Apache-2.0";;
  dart-official|flutter-official) echo "BSD-3-Clause";;
  unity-official) echo "Unity Companion License (UCL) — NON-OSI: use restricted to Unity-engine projects; no competitive analysis";;
  blender-ra100|lean4|golang-skills|rust-skills|power-skills) echo "MIT";;
  agent-stuff|terraform-skill) echo "Apache-2.0";;
  cad-skill) echo "PolyForm Noncommercial 1.0.0 — NON-OSI: COMMERCIAL USE PROHIBITED";;
  kdense) echo "MIT (top-level) — PER-SKILL licenses vary (see each SKILL.md license: field)";;
  getsentry) echo "Apache-2.0";;
  karpathy) echo "MIT asserted (frontmatter/README/plugin.json) — NO LICENSE file (unconfirmed)";;
  awesome-gamedev) echo "Apache-2.0";;
  anthropic) echo "Anthropic (see repo; no root LICENSE file — per-skill terms)";;
  bora) echo "MIT (LICENSE-mengto-skills) / README+GitHub inconsistent — verify";;
  three-agent) echo "MIT per README — NO root LICENSE file detected (unconfirmed)";;
  phaser4) echo "MIT per README — NO root LICENSE file detected (unconfirmed)";;
  salaja) echo "see license.md";;
  dataviz-skill) echo "UNSPECIFIED — no LICENSE file (treat as all-rights-reserved; do not redistribute)";;
  *) echo "unknown — verify before redistributing";; esac; }

# ---- executable/hook detection ----
_has_exec() { # $1 = dir ; prints matching files (relative), empty if none
  find "$1" -type f \( -name '*.sh' -o -name '*.mjs' -o -name '*.cjs' -o -name '*.js' \
       -o -name '*.ts' -o -name '*.py' -o -name '*.cmd' -o -name 'hooks*.json' \
       -o -name 'plugin.json' -o -name 'marketplace.json' \) \
       -not -path '*/.git/*' 2>/dev/null
}

_quarantine_execs() { # $1=src dir  $2=quarantine label  -> returns 0 if any quarantined
  local src="$1" label="$2" qdir="$LIB/_quarantine/$2" f rel found=""
  found="$(_has_exec "$src")"
  [ -z "$found" ] && return 1
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    rel="${f#"$src"/}"
    mkdir -p "$qdir/$(dirname "$rel")"
    cp "$f" "$qdir/$rel" 2>/dev/null || true
  done <<EOF
$found
EOF
  # count + summarise for QUARANTINE.md
  local n; n="$(printf '%s\n' "$found" | grep -c . )"
  {
    echo "- **$label** — from \`$(meta_url "${label%%--*}")\`: $n executable/hook file(s) quarantined (not installed, not activated). Types:"
    printf '%s\n' "$found" | sed "s|$src/|    - |" | head -40
  } >> "$QUARANTINE"
  return 0
}

# ---- markdown-only copy ----
_copy_md() { # $1=src dir  $2=dest dir
  local src="$1" dest="$2"
  mkdir -p "$dest"
  rsync -a \
    --exclude='.git' --exclude='node_modules' --exclude='.DS_Store' \
    --exclude='*.sh' --exclude='*.mjs' --exclude='*.cjs' --exclude='*.js' \
    --exclude='*.ts' --exclude='*.py' --exclude='*.cmd' \
    --exclude='.claude-plugin' --exclude='.cursor-plugin' --exclude='.codex-plugin' \
    --exclude='.opencode' --exclude='.claude' --exclude='.agents' \
    --exclude='.github' --exclude='.vscode' --exclude='hooks' \
    "$src"/ "$dest"/ 2>/dev/null || return 1
  # drop any dirs left empty after stripping code
  find "$dest" -type d -empty -delete 2>/dev/null || true
  return 0
}

# ---- frontmatter name rewrite (first name: in top frontmatter) ----
_set_name() { # $1=SKILL.md path  $2=name
  local f="$1" n="$2" tmp
  [ -f "$f" ] || return 0
  tmp="$(mktemp)"
  awk -v n="$n" 'BEGIN{done=0} /^name:[[:space:]]/ && !done {print "name: " n; done=1; next} {print}' "$f" > "$tmp" && mv "$tmp" "$f"
}

_write_source() { # $1=dest dir  $2=key  $3=relpath-in-repo  $4=orig-name  $5=install-name
  local dest="$1" key="$2" rel="$3" orig="$4" name="$5"
  {
    echo "# Source"
    echo "- Repo: $(meta_url "$key")"
    echo "- Path in repo: $rel"
    echo "- Author: $(meta_author "$key")"
    echo "- License: $(meta_license "$key")"
    echo "- Pulled: $TODAY"
    [ "$orig" != "$name" ] && echo "- Renamed from: $orig"
  } > "$dest/SOURCE.md"
}

# ================= public: install one skill =================
install_one() { # KEY RELPATH CATEGORY NAME
  local key="$1" rel="$2" cat="$3" name="$4"
  local src="$LIB/.sources/$key/$rel"
  local orig; orig="$(basename "$rel")"
  if [ ! -f "$src/SKILL.md" ]; then
    echo "- \`$name\` — expected at \`$key/$rel\` — NOT FOUND" >> "$MISSING"
    echo "  MISS  $key/$rel"
    return 1
  fi
  local dest="$LIB/skills/$cat/$name"
  _copy_md "$src" "$dest" || { echo "  ERR   copy $key/$rel"; return 1; }
  _set_name "$dest/SKILL.md" "$name"
  _write_source "$dest" "$key" "$rel" "$orig" "$name"
  _quarantine_execs "$src" "$key--$name" && echo "  OK*   $cat/$name  (execs quarantined)" || echo "  OK    $cat/$name"
  return 0
}

# ===== public: quarantine repo-root installers/hooks outside an installed subtree =====
quarantine_repo_root() { # KEY  PACKED-SUBTREE
  local key="$1" sub="$2"
  local root="$LIB/.sources/$key" qdir="$LIB/_quarantine/$key--repo-root"
  local f rel found n
  [ -n "$key" ] || return 1
  [ -d "$root" ] || return 1
  found="$(find "$root" -type f \( -name '*.sh' -o -name '*.mjs' -o -name '*.cjs' -o -name '*.js' \
       -o -name '*.ts' -o -name '*.py' -o -name '*.cmd' -o -name 'hooks*.json' \
       -o -name 'plugin.json' -o -name 'marketplace.json' -o -name 'settings.json' \) \
       -not -path '*/.git/*' -not -path "*/$sub/*" 2>/dev/null)"
  [ -z "$found" ] && return 1
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    rel="${f#"$root"/}"
    mkdir -p "$qdir/$(dirname "$rel")"
    cp "$f" "$qdir/$rel" 2>/dev/null || true
  done <<EOF
$found
EOF
  n="$(printf '%s\n' "$found" | grep -c .)"
  {
    echo "- **$key (repo-root installers/hooks)** — $(meta_url "$key"): $n file(s) OUTSIDE the installed \`$sub/\` subtree, copied to \`_quarantine/$key--repo-root/\`. Present in the \`.sources\` clone only; never installed into \`skills/\`:"
    printf '%s\n' "$found" | sed "s|$root/|    - |" | head -60
  } >> "$QUARANTINE"
  return 0
}

# ================= public: install a whole pack =================
install_pack() { # KEY RELPATH CATEGORY PACKNAME
  local key="$1" rel="$2" cat="$3" pack="$4"
  local src="$LIB/.sources/$key/$rel"
  if [ ! -d "$src" ]; then
    echo "- pack \`$pack\` — expected subtree \`$key/$rel\` — NOT FOUND" >> "$MISSING"
    echo "  MISS  pack $key/$rel"
    return 1
  fi
  local n; n="$(find "$src" -name SKILL.md -not -path '*/.git/*' | grep -c .)"
  if [ "$n" -eq 0 ]; then
    echo "- pack \`$pack\` — no SKILL.md under \`$key/$rel\`" >> "$MISSING"
    echo "  MISS  pack(empty) $key/$rel"
    return 1
  fi
  local dest="$LIB/skills/$cat/$pack"
  _copy_md "$src" "$dest" || { echo "  ERR   copy pack $key/$rel"; return 1; }
  _write_source "$dest" "$key" "$rel" "$pack" "$pack"
  echo "PACK: $pack ($n skills) from $key" >> "$dest/SOURCE.md"
  _quarantine_execs "$src" "$key--$pack" && echo "  OK*   $cat/$pack/  ($n skills, execs quarantined)" || echo "  OK    $cat/$pack/  ($n skills)"
  return 0
}
