# SETUP-PROMPT.md

Paste into Claude Code to install + verify the remotion-transitions skill.

```
Install + verify the remotion-transitions skill on this machine.

1. Confirm the skill exists at ~/.claude/skills/remotion-transitions/.
2. Confirm Node 18+ and npm are on PATH. If missing, install via `brew install node` (Mac) before continuing.
3. Run smoke: bash ~/.claude/skills/remotion-transitions/scripts/smoke.sh. Expect SMOKE PASS.
4. Once verified, the skill auto-loads when I ask for a custom Remotion scene transition. Trigger phrases include "Remotion transition", "TransitionPresentation", "scene transition", "striped slam", "zoom punch", "diagonal reveal", "emerald burst", "vertical shutter", "glitch slam".
```

## What this skill provides

The TransitionPresentation API pattern plus 6 battle-tested custom transitions with full source, the easing math behind them, and the rules for pairing with `linearTiming` vs `springTiming`.

| Transition | What it does | Best for |
|---|---|---|
| Striped Slam | N-bar alternating panel slam from both sides | Branded chapter changes |
| Zoom Punch | Retreat + cubic ease-in-out punch | Emphasis / reveal moment |
| Diagonal Reveal | Skewed dark panel sweep with accent line | Section-to-section in long-form |
| Emerald Burst | Sharp radial flash with fast dissolve | Logo reveal, drop, brand stinger |
| Vertical Shutter | Venetian blind close/open across N panels | Multi-pane comparison cuts |
| Glitch Slam | Decaying shake + RGB horizontal strip tears | High-energy social cut |

## Reference files (load on-demand)

- `references/custom-transition-pattern.md`: the full `TransitionPresentation` API scaffold, component shape, timing semantics
- `references/transition-catalog.md`: complete source for all 6 transitions
- `references/animation-math.md`: easing functions, stagger formulas, spring configs, `clamp` extrapolation patterns

## Golden rules

1. **Never use CSS transitions or animations** inside a transition component. All motion goes through `interpolate()` / `spring()` driven by `presentationProgress`.
2. **Never call `useCurrentFrame()`** inside a transition component. Use `presentationProgress` only.
3. Always return `{ component, props: {} }` from your transition factory. The `props` object must exist even if empty.
4. **Create transition instances outside components** at module level so they stay stable across re-renders.
5. Pair with `linearTiming` for dramatic frame-perfect motion, `springTiming` for springy physics.

## Failure modes

| Symptom | Fix |
|---|---|
| Transition stutters | You used `useCurrentFrame()` inside the transition. Replace with `presentationProgress`. |
| Transition runs twice / re-creates | Transition instance defined inside a component. Move it to module level. |
| Transition jumps at end | Forgot `clamp` on interpolate. Always clamp both sides for transition components. |
| Easing feels wrong | Linear feels mechanical for organic motion, spring overshoots for hard cuts. Match the curve to the energy. See references/animation-math.md. |
| `props is undefined` error | Returned `{ component }` without `{ props: {} }`. The empty props object is required. |
| Both scenes show during transition | Wrong direction handling. Old scene = `"exiting"`, new scene = `"entering"`. Animate different things in each branch. |

## Pairs with

- `/remotion-best-practices` — broader Remotion patterns (animation, timing, sequencing, audio) loaded on-demand
- `/remotion-template-library` — pre-built composition catalog (captions, audiograms, 3D, social)
- `/motion-graphic-reels` — Selr AI's motion-graphic reel pipeline that uses these transitions between scenes
- `/notebook-reels` — cinematic AI reel pipeline (uses `xfade` style transitions for B-roll)
