#!/usr/bin/env bash
# remotion-transitions smoke test.
# Verifies the skill has all required files, Node/npm are present (Remotion is React-based),
# and the reference files referenced by SKILL.md are intact.
set -u

FAILS=0
ok()   { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; FAILS=$((FAILS+1)); }
warn() { echo "WARN: $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$SCRIPT_DIR/.."

echo "== remotion-transitions smoke =="
echo ""

# 1. SKILL.md present + valid frontmatter
if [[ -s "$SKILL_DIR/SKILL.md" ]]; then
  if head -8 "$SKILL_DIR/SKILL.md" | grep -q "^name: remotion-transitions"; then
    ok "SKILL.md present with valid frontmatter"
  else
    fail "SKILL.md missing or malformed frontmatter (expected name: remotion-transitions)"
  fi
else
  fail "SKILL.md missing"
fi

# 2. Node present (Remotion is a Node/React project)
if command -v node >/dev/null 2>&1; then
  NODE_V=$(node --version 2>/dev/null)
  ok "node present ($NODE_V)"
else
  warn "node not on PATH. Install Node 18+ before using transitions in a real project."
fi

# 3. npm present
if command -v npm >/dev/null 2>&1; then
  NPM_V=$(npm --version 2>/dev/null)
  ok "npm present ($NPM_V)"
else
  warn "npm not on PATH. Install npm before using this skill."
fi

# 4. npx available
if command -v npx >/dev/null 2>&1; then
  ok "npx available (used for 'npx remotion render')"
else
  warn "npx not on PATH. Comes with npm, check Node install."
fi

# 5. References directory + canonical files
REF_DIR="$SKILL_DIR/references"
if [[ -d "$REF_DIR" ]]; then
  ok "references/ directory present"
else
  fail "references/ directory missing"
fi

for ref in custom-transition-pattern.md transition-catalog.md animation-math.md; do
  if [[ -s "$REF_DIR/$ref" ]]; then
    ok "references/$ref present"
  else
    fail "references/$ref missing (SKILL.md cites this)"
  fi
done

# 6. CHANGELOG + SETUP-PROMPT + worked session present (evidence layer)
for f in CHANGELOG.md SETUP-PROMPT.md examples/remotion-transitions-session.md; do
  if [[ -e "$SKILL_DIR/$f" ]]; then
    ok "$f present"
  else
    fail "$f missing"
  fi
done

# 7. Sister skills detection (pairs-with)
if [[ -d "$HOME/.claude/skills/remotion-best-practices" ]]; then
  ok "sister skill remotion-best-practices present"
else
  warn "sister skill remotion-best-practices not installed"
fi

if [[ -d "$HOME/.claude/skills/remotion-template-library" ]]; then
  ok "sister skill remotion-template-library present"
else
  warn "sister skill remotion-template-library not installed"
fi

echo ""
if [[ $FAILS -eq 0 ]]; then
  echo "SMOKE PASS"
  exit 0
fi
echo "SMOKE FAIL ($FAILS check(s) failed)"
exit 1
