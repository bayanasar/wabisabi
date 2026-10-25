# PROGRESS — wabisabi

<!-- progress -->
updated: 2026-10-25
owner: bayanasar
stage: 0.2.2 — `WabDotGrid` paints as one surface and draws what `WabInkDot` draws, pixel for pixel
<!-- /progress -->

## What this is

A Flutter design-system package: a paper-and-ink palette, a golden-section type
ladder, painted material textures and the components built on them. `example/`
is the catalogue, and it is also the kit's only visual test. The contract that
matters is enforced by scripts in `tool/`, not by prose.

## Sealed

- Forge CI runs the whole gate, release APK included, on the `linux-docker`
  runner — `main` at `96f57d4`: run 33 (push) and run 32 (pull request)
  success.
- `WabDotGrid` draws what `WabInkDot` draws — `test/dot_grid_test.dart`
  renders a one-dot grid and a `WabInkDot` of the same style at 3x for five
  styles: 0 differing pixels. Before the fix, three failed by 105, 105 and 160
  pixels: an opaque border, a hollow ring and a zero-width border.
- The painter places dots where the widget layout did — the same test file
  rebuilds the replaced Row-in-Column of `WabInkDot`s and compares it with a
  3×4 grid at dot 7.3, gap 0.9: 0 differing pixels. With every centre moved
  0.05 px, 1,402 pixels differ.
- A consuming app's 65×53 grid renders as it did on 0.2.1 — its release web
  build against 0.2.1 and against the 0.2.2 branch, in a desktop browser at
  390, 860, 1000 and 1400 px, and at 390 and 1400 px with a dot pressed:
  0 differing pixels. Against `96f57d4`, before the fix, its one bordered dot
  differed by 15 to 38 pixels: a dark halo outside the ring.
- Contract checks after 0.2.2 — `flutter analyze` no issues;
  `check_layering` 54 files, no cycles; `check_public_api` 211 names, 0
  violations; `check_house_rules` 59 files clean; `export_tokens` leaves
  `web/quarto/` unchanged.
- Tests after 0.2.2 — `flutter test` 28 green (9 for the dot grid);
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

- The reading floor on a phone or tablet — the desktop browser review covers
  web only. If hinting differs on device, 11.93 px kai may still read small.
- Any screenshot of a shadow from `flutter test` — it sets
  `debugDisableShadows`, drawing every `BoxShadow` unblurred with hard stepped
  edges. Set it to false in the test and back before it ends, or judge in a
  browser.
- The example APK on a device — built in CI, never installed or launched.
- No golden images (#13) — only `WabDotGrid` is compared pixel for pixel, with
  `WabInkDot`; a visual regression in any other painter passes every check
  above.

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

## Open

- The 0.2.1 commit reads red: run 34, started by the tag push, failed after
  the runner's host restarted ten minutes in. The same commit passed runs 26,
  27 and 30. Re-running run 34 needs a forge login.
- The formatter is not in CI: `dart format` would change 44 of 63 files under
  `lib/`, `test/` and `tool/`.
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
