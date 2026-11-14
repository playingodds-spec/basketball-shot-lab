# Next milestone: convincing skeletal basketball shot

## Status
The v0.1 Android APK exported and passed package/signature checks. The user tested it and rejected the geometric character and animation as inadequate. Treat shot_lab.gd as an input/trajectory experiment, not an approved animation or final character implementation. No Blender character, skinning or finished shot animation exists yet.

## Immediate work
1. Model a unified, child-proportioned low-poly character matching concepts/youth-player.png. Preserve the retro textured style and believable anatomy.
2. Rig and skin the mesh, including shoulders, elbows, knees, wrists, hands and fingers. Check deformation under bending before animation.
3. Author a basketball-specific whole-body shot in Blender: gather, knee/hip load, rise, guide-hand separation, elbow extension, wrist/finger release, follow-through, landing and recovery.
4. Produce normal-speed and slow-motion rendered previews for user review before another gameplay APK.
5. Export baked deformation animation and mesh via GLB into Godot 4.6. Blend imported clips with AnimationTree; keep input responsive.
6. Keep the ball attached to a hand socket until release, preserve its global transform on detachment, and avoid pose snapping for early/late release.
7. Fit interchangeable shoe meshes to the same feet/rig. Postpone detailed world building and broad progression implementation until the shot is approved.

## Input requirements
Portrait, one-handed. Press and hold, drag back to begin the shot animation; lifting the finger determines release timing. Slight error can still score depending on distance. Visible timing guide fades with progress. Camera remains stationary during shooting, follows movement between locations, then settles. Movement between challenge spots is automatic.

## Broader direction
Customizable player begins around age 8–10 in an elementary school gym and progresses through years by completing skill challenges. Every shot and dribble action must succeed to complete a challenge. Locations should not change often. Dribbling is rhythmic tapping on each bounce with a brief fumble/recovery on error. Shoe options unlock through play time. Active-time-only unlocks and cosmetic-only shoes remain recommendations, not confirmed rules.

## Verified research links
- Godot 4.6 GLB import: https://docs.godotengine.org/en/4.6/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html
- AnimationTree: https://docs.godotengine.org/en/4.6/tutorials/animation/animation_tree.html
- Humanoid retargeting: https://docs.godotengine.org/en/4.6/tutorials/assets_pipeline/retargeting_3d_skeletons.html
- Bone attachments: https://docs.godotengine.org/en/4.6/classes/class_boneattachment3d.html
- SkeletonModifier3D: https://docs.godotengine.org/en/4.6/classes/class_skeletonmodifier3d.html

Avoid basing a new rig workflow on SkeletonIK3D; it is deprecated in Godot 4.6. Blender Rigify creates controls/bones, but skinning still needs work. Retargeted adult motion requires adjustment for a child's proportions. Mixamo may help with supporting clips, but no suitable basketball clip has been verified.
