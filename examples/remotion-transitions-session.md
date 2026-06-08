# Worked example: remotion-transitions session

Real session showing how the skill auto-loads the `TransitionPresentation` pattern and the 6-transition catalog when a user asks for a scene-to-scene cut beyond the Remotion built-in library.

## Setup

- Skill: `remotion-transitions` v1.1.0
- Project: a fresh `npx create-video@latest` scaffold with `@remotion/transitions` installed
- Trigger: user asks for a custom transition by name or by feel

## Example 1: Fade between two scenes (the built-in baseline)

```
User: Just a clean cross-fade between Scene A and Scene B over 20 frames.

Claude: For a basic cross-fade, Remotion ships one in @remotion/transitions.
You don't need this skill's custom catalog for that.

  import { TransitionSeries, linearTiming } from '@remotion/transitions';
  import { fade } from '@remotion/transitions/fade';

  <TransitionSeries>
    <TransitionSeries.Sequence durationInFrames={60}><SceneA /></TransitionSeries.Sequence>
    <TransitionSeries.Transition presentation={fade()} timing={linearTiming({ durationInFrames: 20 })} />
    <TransitionSeries.Sequence durationInFrames={60}><SceneB /></TransitionSeries.Sequence>
  </TransitionSeries>

If you want something with more energy, ask for a Striped Slam or Glitch Slam.
```

## Example 2: Striped Slam between branded chapter cards

```
User: I need a branded chapter break, six vertical bars slamming in from alternating
sides over 18 frames, accent color #FFE135.

Claude: [loads references/custom-transition-pattern.md, references/transition-catalog.md]

Striped Slam is the catalog match. Create the instance at module scope so it
doesn't re-instantiate on re-render:

  import { TransitionSeries, linearTiming } from '@remotion/transitions';
  import { stripedSlam } from './transitions/striped-slam';

  const slam = stripedSlam({ bars: 6, accent: '#FFE135' });

  <TransitionSeries>
    <TransitionSeries.Sequence durationInFrames={90}><Chapter1 /></TransitionSeries.Sequence>
    <TransitionSeries.Transition presentation={slam}
                                  timing={linearTiming({ durationInFrames: 18 })} />
    <TransitionSeries.Sequence durationInFrames={90}><Chapter2 /></TransitionSeries.Sequence>
  </TransitionSeries>

Full stripedSlam source lives in references/transition-catalog.md. Key bit: each
bar gets a stagger of `i * (1 / bars) * 0.3`, then `interpolate` from offscreen
to home with clamp on both sides.
```

## Example 3: Zoom Punch for a reveal moment

```
User: Punch from the wide hook shot into a tight headline. Should feel like a
camera zoom-in, then a hard frame stop.

Claude: [loads references/transition-catalog.md, references/animation-math.md]

Zoom Punch uses cubic ease-in-out, which gives the "wind-up, smack" feel. Pair
with linearTiming so the punch lands on an exact frame, not a spring approximation.

  import { zoomPunch } from './transitions/zoom-punch';

  const punch = zoomPunch({ retreat: 0.92, peak: 1.08 });

  <TransitionSeries.Transition presentation={punch}
                                timing={linearTiming({ durationInFrames: 15 })} />

15 frames = half a second at 30fps. The exiting scene retreats to scale 0.92,
the entering scene punches in from scale 1.08 to 1.0. Easing curve is the
cubic in references/animation-math.md.
```

## Example 4: Glitch Slam for a high-energy social cut

```
User: I want that "RGB tear" transition between two B-roll shots in my reel.
Looks broken on purpose.

Claude: [loads references/transition-catalog.md]

Glitch Slam. Decaying shake on both scenes, plus three RGB-offset horizontal
strip tears that peak mid-transition then settle.

  import { glitchSlam } from './transitions/glitch-slam';

  const glitch = glitchSlam({ shake: 8, strips: 3, rgbOffset: 6 });

  <TransitionSeries.Transition presentation={glitch}
                                timing={linearTiming({ durationInFrames: 12 })} />

12 frames = 0.4 sec, the right length for social. Longer than 15 starts to feel
sloppy. The shake amplitude decays via 1 - presentationProgress so it lands clean.
```

## Example 5: Building a brand-new transition from scratch

```
User: I want a custom "iris wipe" transition, expanding circle that reveals
the next scene from the center.

Claude: [loads references/custom-transition-pattern.md]

Follow the TransitionPresentation scaffold. Two rules to remember:
  1. Use presentationProgress only, never useCurrentFrame
  2. Return { component, props: {} } from the factory

  // transitions/iris-wipe.tsx
  import { TransitionPresentationComponentProps,
           TransitionPresentation } from '@remotion/transitions';
  import { interpolate } from 'remotion';

  const IrisWipeInner: React.FC<TransitionPresentationComponentProps> = ({
    presentationProgress, presentationDirection, children,
  }) => {
    const radius = interpolate(presentationProgress, [0, 1], [0, 150], {
      extrapolateLeft: 'clamp', extrapolateRight: 'clamp',
    });
    const clip = presentationDirection === 'entering'
      ? `circle(${radius}% at 50% 50%)`
      : `circle(${100 - radius}% at 50% 50%)`;
    return <div style={{ clipPath: clip, width: '100%', height: '100%' }}>{children}</div>;
  };

  export const irisWipe = (): TransitionPresentation<{}> => ({
    component: IrisWipeInner,
    props: {},
  });

Pair with `linearTiming({ durationInFrames: 25 })` for a clean reveal.
```

## Example 6: Pairing transitions with the right timing

```
User: When should I use linearTiming vs springTiming?

Claude: [loads references/animation-math.md]

Rule of thumb:

  linearTiming: dramatic, frame-perfect, hard cuts.
    Use for: Striped Slam, Zoom Punch, Glitch Slam, Iris Wipe, Diagonal Reveal,
             Emerald Burst, Vertical Shutter, anything that needs to land on a beat.

  springTiming: organic, physics-driven, slightly bouncy.
    Use for: scene-card entries, soft fades on calm content, anything where you
             want "settle" rather than "snap".

Spring never lands on an exact frame, so don't pair it with anything that needs
to sync to a music beat. For all 6 transitions in the catalog, the answer is
linearTiming.
```

## What kit-doctor sees after the cook

```
== remotion-transitions ==
Verdict: Promising (avg 4.0+)  [was Needs work 2.8]

Scores:
  clarity            [####.] 4
  install_story      [####.] 4   [was 2, SETUP-PROMPT added, git-clone yellow flag dispositioned]
  trigger_fidelity   [#####] 5   [was 4, description tightened with concrete trigger phrases]
  differentiation    [###..] 3
  evidence           [####.] 4   [was 1, smoke + worked session added]
```

Note: the git-clone yellow flag kit-doctor surfaced in SKILL.md is in a tutorial code block
pointing at the Remotion SST starter — it is not an install command for this skill itself.
SETUP-PROMPT.md is the canonical install path.
