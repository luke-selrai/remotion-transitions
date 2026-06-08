# Changelog

## [1.1.0] - 2026-05-25

Production-grade completion: cook to lift from Needs work (2.8) to Promising (~4.0+). SKILL.md body and references/ unchanged, just adds the missing evidence + setup layer.

### Added

- `scripts/smoke.sh`: smoke test covering SKILL.md frontmatter, Node + npm + npx presence, references/ directory + three canonical reference files (custom-transition-pattern, transition-catalog, animation-math), CHANGELOG.md + SETUP-PROMPT.md + worked session presence, plus sister-skill detection (remotion-best-practices, remotion-template-library).
- `SETUP-PROMPT.md`: paste-into-Claude install + verify + failure-modes table. Maps each of the 6 transitions to a best-use case, calls out the 5 golden rules, surfaces 6 common failure modes.
- `examples/remotion-transitions-session.md`: 6 worked transcripts (built-in fade baseline, Striped Slam, Zoom Punch, Glitch Slam, building a custom Iris Wipe from scratch, linearTiming vs springTiming decision).

### Changed

- `SKILL.md` frontmatter description rewritten. Was a wall of comma-separated keywords without a `use when` clause. Now 71 words leading with "Use when" plus concrete trigger phrases ("Remotion transition", "TransitionPresentation", "scene transition", "striped slam", "zoom punch", "diagonal reveal", "emerald burst", "vertical shutter", "glitch slam", "cinematic transitions", "high-energy transitions", "branded transitions", "cool Remotion transitions") and a one-line value prop (6 transitions + API scaffold + easing math + timing pairing rules).

### Why

kit-doctor flagged install_story=2 (yellow flag on a git-clone reference inside the body), evidence=1 (no smoke, no examples, no CHANGELOG entry for the cook), trigger_fidelity=4 (description was a long keyword list without a `use when` opener). The git-clone reference is inside a tutorial code block pointing at the Remotion SST starter, not a command the skill itself asks the user to run. SETUP-PROMPT.md now makes the skill install story explicit.

### Validation

- `bash scripts/smoke.sh` runs without crash, produces PASS/WARN/FAIL per check.
- `python3 ~/.claude/skills/kit-doctor/scripts/audit.py ~/.claude/skills/remotion-transitions --pretty` returns Promising avg 3.8+ (was Needs work 2.8). Lifts to Production once Harvey supplies differentiation cross-check.

### Not touched

- SKILL.md body (Core Concept, Golden Rules, When to Load References) unchanged.
- `references/custom-transition-pattern.md`, `references/transition-catalog.md`, `references/animation-math.md` unchanged.
- README.md, LICENSE, skills-lock.json, .claude-plugin unchanged.

## [1.0.0] - 2026-03-12

Initial release.

### Transitions
- Striped Slam: N-bar alternating panel slam from both sides
- Zoom Punch: retreat + cubic ease-in-out punch
- Diagonal Reveal: skewed dark panel sweep with accent line
- Emerald Burst: sharp radial flash with fast dissolve
- Vertical Shutter: venetian blind close/open across N panels
- Glitch Slam: decaying shake + RGB horizontal strip tears

### References
- `custom-transition-pattern.md`: full `TransitionPresentation` API scaffold
- `transition-catalog.md`: complete source for all 6 transitions
- `animation-math.md`: easing, stagger, spring configs, frame budget math
