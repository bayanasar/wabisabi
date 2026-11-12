# PROGRESS — wabisabi

<!-- progress -->
updated: 2026-11-07
owner: bayanasar
stage: 0.2.3 — `WabDotGrid` batches its fills, one draw per colour and radius; a phone's tap frame rasters in 6.5 ms, not 26
<!-- /progress -->

## What this is

A Flutter design-system package: a paper-and-ink palette, a golden-section type
ladder, painted material textures and the components built on them. `example/`
is the catalogue, and it is also the kit's only visual test. The contract that
matters is enforced by scripts in `tool/`, not by prose.

## Sealed

- Forge CI runs the whole gate, release APK included, on the `linux-docker`
  runner — `3c83474`, tagged `0.2.3`: run 58 (pull request), run 60 (`main`
  push) and run 61 (tag push) success.
- Batching the fills cut a phone's raster to the floor — a consuming app's
  release build on a Pixel 9 Pro XL (Impeller, Vulkan), its 3,390-dot grid
  against `main` and against the batched painter, alternating over 6 runs of
  10 taps at three densities: tap-frame raster p50 25.9 / 26.5 / 19.9 ms
  before, 6.6 / 6.4 / 6.5 ms after; with the grid hidden, 5.7 to 5.9 ms. On a
  frame that re-records every dot — fey `4a86c23`, before its pin mark, at
  100% density only — UI-thread build fell from 16.4 to 12.6 ms and raster
  from 25.5 to 5.9 ms.
- Draw calls do not grow with the number of dots — `test/dot_grid_test.dart`:
  a 65×53 grid and a 2×2 grid of the same three colours both make 3 calls.
  The per-dot painter fails it.
- Batching changes only pixels on a dot's edge — the same file draws the grid
  batched and dot by dot at gaps 0 to 3, pixel ratios 1, 2.25 and 3, three
  sub-pixel offsets: every change within 1.5 device px of an edge and at most
  80 (measured 1.1 px and 70). Points 0.1 px wider, a missing border, or a
  fill not held back under an opaque border each fail it. On the phone, the
  app's grid at its default density differed from `main` only on edge pixels,
  by at most 12/255.
- The batched grid on web changes only a few pixels inside it — a consuming
  app's release web build against 0.2.3 and against 0.2.2, screenshots at 390,
  860, 1000 and 1400 px at pixel ratio 1: 6, 13, 45 and 11 pixels differ, by
  at most 16/255, all inside the grid.
- `WabDotGrid` draws what `WabInkDot` draws, at the tested positions — the
  same file renders a one-dot grid and a `WabInkDot` of the same style at 3x
  for seven styles: 0 differing pixels. Before the 0.2.2 fix, three failed by
  105, 105 and 160 pixels. At other sub-pixel positions the per-dot painter
  already differed: a scratch sweep of 2,160 single dots found 120 differing,
  on edge pixels only, by up to 95/255.
- The painter places dots where the widget layout did — the same test file
  rebuilds the replaced Row-in-Column of `WabInkDot`s and compares it with a
  3×4 grid at dot 7.3, gap 0.9: 0 differing pixels. With every centre moved
  0.05 px, 1,402 pixels differ.
- The grid does not mirror under right-to-left text — the same test file renders
  that 3×4 grid under `rtl` and under `ltr` at 3x: 0 differing pixels. With the
  painter flipped under RTL, the test fails.
- Contract checks on the 0.2.3 branch — `flutter analyze` no issues;
  `check_layering` 54 files, no cycles; `check_public_api` 211 names, 0
  violations; `check_house_rules` 59 files clean; `export_tokens` leaves
  `web/quarto/` unchanged.
- Tests on the 0.2.3 branch — `flutter test` 33 green (14 for the dot grid);
  `cd example && flutter test` 45 green (38 catalogue sweeps over 13 widths and
  5 text scales, 7 reading-floor widths).
- The light theme was pixel-identical before and after the first lamplight pass
  (1600 px screenshot diff, no changed pixels); later passes changed it on
  purpose.
- The release web build of the catalogue was reviewed by eye in a desktop
  browser while the lift was tuned.
- Small text was real, not taste — on `ee522b6d`, measuring every text run as
  drawn (transforms included) at a 1024 px viewport: 116 runs under 7 px, from
  8.65 px type in cells shrunk to 0.59x.
- The reading-floor test catches it — `example/test/reading_floor_test.dart`
  fails at 6 of 7 widths with the board fix reverted (7.1 px text at 1024 px),
  passes with it.
- #9 (bare `CupertinoApp` gets iOS blue and pure white) reproduces on
  `ee522b6d`: `WabTheme.of` returns `0xFF007AFF` / `0xFFFFFFFF`.
- #21 (masthead overflows at 390 px with 2.5x text) predates the fix: same 25 px
  overflow on `ee522b6d`.

## Not sealed

- Batched fills on Impeller where dots touch — the phone was measured only at
  the app's default density, where gaps are over a device pixel. Below that,
  touching points in one draw may composite differently from the test
  rasterizer; if so, dense grids could show darker seams.
- The reading floor on a phone or tablet — the desktop browser review covers
  web only. If hinting differs on device, 11.93 px kai may still read small.
- Any screenshot of a shadow from `flutter test` — it sets
  `debugDisableShadows`, drawing every `BoxShadow` unblurred with hard stepped
  edges. Set it to false in the test and back before it ends, or judge in a
  browser.
- The example APK on a device — built in CI, never installed or launched.
- No golden images (#13) — only `WabDotGrid` is compared pixel for pixel, with
  `WabInkDot` and with dot-by-dot drawing; a visual regression in any other
  painter passes every check above.

## Decisions

- 2026-09-12 Contract lives in `tool/` scripts run in CI — because the previous
  prose rules drifted from the code unnoticed.
- 2026-09-13 `WabType.gloss` (11.93) is the reading floor; `annotation` and
  `caption` deprecated, not removed — a brush face in muted ink is illegible
  below ~12 px on screen, and removal would break consumers before a major.
- 2026-09-13 Catalogue cells are never drawn smaller than designed; the board
  drops columns, phones reflow cells down to 292 px — shrinking a cell shrinks
  its type below the floor; below 292 px the sections overflow.
- 2026-09-13 Icons and seal faces are exempt from the floor test — they are
  fitted to their box as marks, not set as text.
- 2026-09-13 One lift for the whole kit, `wabLift` — soft stacked shadows, no
  drawn edge — because painted contact lines and lamp hairlines read as hard
  black and white lines on review; the stacked shadow `WabContainer` already
  cast was the one that looked natural.
- 2026-09-13 The dark theme casts the lift's exact shape in
  `WAB_TEXTURE_LAMP_GLOW` — an ink shadow on a dark ground is invisible, and
  light on only some of the edges a shadow covers looked wrong.
- 2026-09-13 Wood: paper's reach, 1.5x strength; jade: 1.6x reach, 0.8x
  strength — dense wood shades darker; jade lets light through. At 0.6x jade's
  wider lift nearly vanished.
- 2026-10-16 Forge CI is `.forgejo/workflows` on `linux-docker`, installing its
  own Flutter, JDK and Android SDK; `.github/workflows` stays for the public
  mirror — no forge runner serves `ubuntu-latest`, and the GitHub workflow
  relies on hosted-runner actions and `sudo`.
- 2026-10-25 `main` requires the forge check and takes fast-forward merges
  only — #30 was merged and 0.2.0 tagged while every check was still waiting.
- 2026-10-25 A painter that replaces widgets is tested against those widgets,
  pixel for pixel — the dot-grid painter passed review, the render-count test
  and every check, and still drew a halo that only a screenshot diff in a
  consuming app found.
- 2026-11-01 `WabDotGrid` does not mirror under RTL — a grid is row-major data,
  and a consumer's axes and hit test assume column 0 at the left. 0.2.2 changed
  this without recording it.
- 2026-11-01 CI checks `dart format` over `lib`, `test`, `tool`, `example/lib`
  and `example/test` — it had changed 50 of 70 files, so every edit dragged
  unrelated reflow into its diff. The style is the pre-3.7 one because the SDK
  floor is 3.0; raising the floor to 3.7 or above reformats the tree.

- 2026-11-07 `WabDotGrid` batches its fills into `drawRawPoints`, one call
  per colour and radius, rather than caching the grid as an image — Impeller
  keeps no raster cache and replays every draw each frame; batching brought
  raster within 1 ms of no grid at all, with no extra memory and no blur under
  a scaled parent, where an image would cost about 10 MB for a phone-sized
  grid and need a fallback when too large.
- 2026-11-07 Pixel claims about the dot painter are bounded, not exact: a
  change is allowed within 1.5 device px of a dot's edge, by at most 80 —
  because a round point and a circle anti-alias differently at some sub-pixel
  positions and touching dots composite in another order. Exact equality held
  only at the positions the old tests happened to use.
- 2026-11-12 A release tag waits for an explicit yes, given on the release MR
  or its issue; an approval or a merge is not that yes. An MR's "After merge"
  steps wait until its reviews have been read — 0.2.3 was tagged 52 seconds
  after #43 merged, though review 531 on it said the merge was not the
  go-ahead (#45).

## Open

- #23 one lift, dark theme as lamplight; #24 containers catalogue cell — on
  main; the issues are still open.
- #9 bare `CupertinoApp` palette falls back to system colours.
- #10 `WabBanner` fixed height overflows at raised text size.
- #21 `WabEditorialBanner` overflows at phone width with 2.5x text.
- #1 material parameters not yet on the theme extension.
- #3 bundled fonts are uncut (~30 MB in every app bundle).
- #11 pubspec has no homepage or repository.
- #12 thin kit tests; #13 no golden images; #15 two base files misfiled under
  `components/`; #16 unused raw/wrapper token layer; #17 deprecations due at
  the next major.
