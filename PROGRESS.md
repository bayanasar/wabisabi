# PROGRESS — wabisabi

<!-- progress -->
updated: 2026-09-13
owner: bayanasar
stage: 0.1.0 merged to main but untagged; reading-floor fix (small text) on `fix/legible-small-type`, awaiting review
<!-- /progress -->

## What this is

A Flutter design-system package: a paper-and-ink palette, a golden-section type
ladder, painted material textures and the components built on them. `example/`
is the catalogue, and it is also the kit's only visual test. The contract that
matters is enforced by scripts in `tool/`, not by prose.

## Sealed

- Contract checks on `09fa2235` — `flutter analyze` no issues;
  `check_layering` 52 files, no cycles; `check_public_api` 208 names, 0
  violations; `check_house_rules` 57 files clean; `export_tokens` leaves
  `web/quarto/` unchanged.
- Tests on `09fa2235` — `flutter test` 10 green; `cd example && flutter test`
  45 green (38 catalogue sweeps over 13 widths and 5 text scales, 7 reading-floor
  widths).
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

- The fix in a real browser or device — screenshots so far come from
  `flutter test` with the bundled fonts loaded, not from a rasteriser a viewer
  uses. Headless Chrome 153 was obtained, but the release web build stalled
  after `flutter_bootstrap.js` (CDN and `--no-web-resources-cdn` builds alike).
  If hinting differs on device, 11.93 px kai may still read small.
- CI on the fix branch — the workflow steps were run locally only.
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

## Open

- 0.1.0 is not tagged; consumers pinned to a tag still see 0.0.4.
- #9 bare `CupertinoApp` palette falls back to system colours.
- #10 `WabBanner` fixed height overflows at raised text size.
- #21 `WabEditorialBanner` overflows at phone width with 2.5x text.
- #1 material parameters not yet on the theme extension.
- #3 bundled fonts are uncut (~30 MB in every app bundle).
- #11 pubspec has no homepage or repository.
- #12 thin kit tests; #13 no golden images; #15 two base files misfiled under
  `components/`; #16 unused raw/wrapper token layer; #17 deprecations due at
  the next major.
