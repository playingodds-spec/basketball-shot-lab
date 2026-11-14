# Basketball Shot Lab — v0.1

**Current status:** the initial Android prototype was tested and rejected for character/animation quality. Next priority is a properly skinned character and an authored whole-body shot in Blender. Start with [BLENDER_HANDOFF.md](BLENDER_HANDOFF.md).


Open project.godot in Godot 4.6 and press F6 on main.tscn or F5.
This is editable Godot source, not an APK. No plugins or downloads are required to run in the editor.
Android export requires Godot's Android export templates, SDK/JDK and signing setup.

## Controls
Portrait 540 × 960. Mouse and touchscreen supported.
Press in the lower control region (between the feedback text and timing-guide button), drag downward at least 18 logical pixels to start the animation, then release near the jump peak. Holding beyond the shot automatically releases late. The bar fills toward the desired release and flashes green near it. Timing guide can be toggled.

## Implemented
- Fixed three-quarter 3D camera.
- Procedural child-sized articulated placeholder, segmented arms/legs, beginner shoes.
- Gather, crouch, rise, release, follow-through and reset using interpolated poses.
- Ball follows the hands until release, then follows a deterministic ballistic flight.
- Early/on-time/late feedback, geometric hoop-plane scoring and simple floor bounce.
- Mouse/touch pointer ownership; score and immediate retries.

## Limits of this first pass
Character is geometric blocking, not the final textured/rigged art. Hands, wrist articulation and exact anatomical animation still need work. Hoop/backboard are visual only; rim/backboard rebounds, net animation, sound and haptics are not implemented. One shooting distance only; distance-based forgiveness is a later step. No dribbling, challenge completion, years, customization menu, unlock saving or automatic camera travel yet. Timing cue is manual; progression-based fading comes later. No Android device testing or visual rendering QA performed in this environment.

The first milestone is validating motion and responsiveness on a real device, before final art or world building. A green bar is a timing aid, not final UI design.

## Tuning
shot_lab.gd: PEAK is the ideal release time in seconds. pose() defines the gather/jump/follow-through. release_shot() defines flight duration and the timing-error offset. _physics_process() performs ball flight and hoop crossing detection. These are intentionally exposed together for early iteration; separate animation, ball simulation and input once feel is approved.

## Agreed design
- Godot for now; portrait, one-handed.
- Consistent retro 32-bit-inspired low-poly look across character and world.
- Customizable player starts around age 9 at an elementary school indoor gym.
- Drag back starts the shot animation; release decides early/on-time/late ball release.
- Camera follows location changes, then remains stationary during shooting.
- Distance and timing error determine forgiveness. Deterministic outcomes are a prototype recommendation, not a final locked decision.
- Timing cue fades as skill progresses.
- Automatic movement between drill spots.
- Dribble taps match bounce rhythm; missed taps briefly fumble then recover.
- Challenges require every shooting/dribbling action; completed skill sets advance school years.
- Locations change infrequently. Shoes unlock through play time; active-time accounting and cosmetic-only shoes are recommendations pending approval.
- Prioritize shot animation and feel before expanding the world.

## Validation
Godot 4.6.3 headless import and startup passed.
Run: godot --headless --path . --script res://tests/shot_checks.gd
Checks drag triggering, ball attachment, launch/reset, on-time score, early/late misses and attempt counting.

## Included visual references
Concept PNGs establish intended art direction only; they are not imported 3D models or textures.
