# PROGRESS — wabisabi

<!-- progress -->
updated: 2026-10-25
owner: bayanasar
stage: 0.2.1 — the forge runs the gate and the example builds an APK again; 0.2.0 is tagged
<!-- /progress -->

## What this is

A Flutter design-system package: a paper-and-ink palette, a golden-section type
ladder, painted material textures and the components built on them. `example/`
is the catalogue, and it is also the kit's only visual test. The contract that
matters is enforced by scripts in `tool/`, not by prose.

## Sealed

- Forge CI on the 0.2.1 fix — run 25 on `d501f37`, the `linux-docker` runner:
  success, the only check queued. The same job replayed in the runner image:
  analyze no issues, 19 package and 45 example tests, token export unchanged,
  the three contract checks clean, web, Linux and a 67.9 MB release APK built.
- 0.2.0 failed only at the APK — run 24 on `fc6b194` (the 0.2.0 tree plus the
  workflow) failed; replayed in the runner image, every step passed until
  `flutter build apk`: Gradle 8.10.2 is below Flutter 3.47.2's 8.14 minimum.
- Contract checks on the lift branch tip — `flutter analyze` no issues;
  `check_layering` 54 files, no cycles; `check_public_api` 211 names, 0
  violations; `check_house_rules` 59 files clean; `export_tokens` leaves
  `web/quarto/` unchanged.
- Tests on the lift branch tip — `flutter test` 13 green (3 for the lift);
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
- No golden images (#13) — a visual regression in a painter passes every check
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

## Open

- 0.2.1 is tagged once this release is on main.
- `main` is not protected, so a merge does not wait for the forge check (#31).
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
