# Changelog

## 0.2.0

### Changed

- `WabType.gloss` (11.93) is now the smallest size text is set in. `WabCollectionCard`'s
  description, `WabNotice`, `WabVerticalTag` and `WabEditorialBanner`'s kit
  label, subtitle and motto move up to it; `WabNotice`'s title moves to `body`.
  Components that used them grow slightly.
- `tool/check_house_rules.dart` rejects the two rungs below `gloss`.
- Every lift in the kit is one soft stacked shadow falling to the lower right —
  the one `WabContainer` already cast — deeper than before. `WabPaperLift`,
  `WabCollectionCard`, `WabPanel`, `WabWoodSlab` and buttons now use it instead
  of painted contact lines.
- The dark theme casts that same shape in warm lamplight rather than an ink
  shadow nobody can see on a dark ground.
- Wood casts darker than paper; jade casts further and fainter.

### Added

- `wabLift`, `WabColors.lift` and `WabLift`: the kit's lift, on any decoration
  or around any widget, with `strength` and `reach` to tune it, and
  `WabLift.wood`, `WabLift.jade` and `WabLift.forSurface` presets.
- `WAB_TEXTURE_LAMP_GLOW`.

### Deprecated

- `WabType.annotation` and `WabType.caption` — below the reading floor. Use
  `WabType.gloss`.
- `WabPaperLift.seed` — the lift no longer varies by seed.

### Fixed

- `WabSealMark` set its text at the top-left of the face instead of in the
  middle. Text wider than tall, such as two characters or a Latin word, left
  the lower part of the seal empty.
- `WabEditorialBanner` overflowed horizontally when the viewer's text size was
  raised: the widths at which it drops its motto, kit label and subtitle did not
  account for text scale.

## 0.1.0

Breaking. Consumers pinning a tag are unaffected until they move the pin.

### Breaking

- `wabInputDecoration` takes a `BuildContext` as its first argument.
- `WabContainer`, `WabLiteContainer` and `WabContentContainer` no longer extend
  `Container`; `WabImage` and `WabIcon` no longer extend `ClipRRect`;
  `WabPaymentRow` no longer extends `GestureDetector`; `WabWarningText` no
  longer extends `Text`. All of them compose instead, and all take a `key`.
- `WabPaymentRow.image` widens from `ClipRRect` to `Widget`.
- `WabIconButton`, `WabTextButton`, `WabElevatedButton`, `WabToggleButton` and
  `WabFloatingActionButton` are plain `StatelessWidget`s; their
  `createMaterialWidget` / `createCupertinoWidget` methods are gone. Both
  branches always returned the same thing.
- `WabWidget` loses its two type parameters and gains a const constructor and a
  key. Subclasses may still narrow their return type.
- 57 constants from the pre-golden1 material palette are deleted from
  `tokens/material.dart`. `WAB_WOOD_TEXT_LIGHT` survives as a deprecated alias
  for `WAB_TEXTURE_WOOD_TEXT_LIGHT`.
- `WAB_SEAL_SHADOW_OPACITY` is gone with the shadow it described.
- `WabSealText` moves from `components/` to `theme/`. The barrel is unchanged.
- Six unprefixed names are renamed, because the barrel lands in the consumer's
  namespace: `DeckleBorder`, `DotGrid`, `InkDot`, `InkDotStyle`,
  `TexturePainter` and `isIos` become `WabDeckleBorder`, `WabDotGrid`,
  `WabInkDot`, `WabInkDotStyle`, `WabTexturePainter` and `wabIsIos`. Each old
  name stays as a `@Deprecated` alias, so nothing breaks today and the analyzer
  points at the replacement.

### Deprecated

- `WabPaymentRow` — app domain, not a design-system primitive. Compose a row of
  `WabIcon` and `Text`.
- `WabNavItem` — the kit navigates with `WabTextButton` and its ruled-text
  language; the outlined box predates it and matches nothing else.
- `WAB_WOOD_TEXT_LIGHT` — use `WAB_TEXTURE_WOOD_TEXT_LIGHT`.
- The six renamed aliases above.

All of these go at the next major version.

### Added

- `WabColors`, a `ThemeExtension` carrying the palette, read via
  `WabTheme.of(context)`. An app can now hold a light and a dark theme at once
  and use `themeMode: system`; widgets rebuild when the theme changes.
- `WabType`, the type ladder — every font size the kit draws, in one file.
- `tool/check_layering.dart` and `tool/check_public_api.dart`, run in CI.
- `ARCHITECTURE.md`.
- A BSD 3-Clause licence, which the package did not have.

### Fixed

- `WabNumberFormField` built a `TextEditingController` in `build`: a new one
  every rebuild, never disposed, resetting text and caret. A null `value` also
  rendered the string "null".
- `WabScaffold` silently dropped `floatingActionButton` on iOS and macOS.
- `TexturePainter.shouldRepaint` returned a flat `false`, so the scaffold
  ground kept the old palette across a theme change. `WabInkWash` and the
  fish-tail track painter read the theme where `shouldRepaint` could not see it.
- `WabSlider` mapped taps through a 10 px inset while painting a 9 px one.
- `WabEditorialBanner` overflowed below ~800 px wide, the subtitle wrapping into
  a column of single characters. It now sheds motto, kit label and subtitle as
  it narrows.
- `WabCollectionCard` and `WabPaymentRow` overflowed in tight cells.
- Hardcoded colours in `WabButton` and `WabWarningText` come from tokens and
  the theme.
- 87 `withOpacity` calls become `withValues`, `dialogBackgroundColor` becomes
  `DialogThemeData`, `WabRadio` moves onto `RadioGroup`.
- `web/quarto/*.scss` regenerated; `--wab-rust` had been stale since the golden1
  rebuild.

### Changed

- `WabFloatingActionButton` is a pressed seal: a deckle-edged cinnabar face with
  no drop shadow and a larger mark.

## 0.0.4

Dashboard widget set, xuan paper v2, two-tier rule frames, seal buttons.
