# wabisabi — architecture

A Flutter widget kit with **no third-party runtime dependencies**. The package's
`dependencies:` section contains only the Flutter SDK; `flutter_lints` is a dev
dependency. Nothing here is a wrapper around someone else's design system — the
materials are painted from scratch, the fonts are bundled, and the only thing
that can break the layering is us.

This file is for judgement calls: what the layers mean, why the kit is shaped
this way, what is deliberately left undone. **Mechanical rules are not written
down here.** They live in `tool/check_layering.dart`, `tool/check_public_api.dart`
and `tool/check_house_rules.dart` and run in CI, because a rule in prose drifts
and a rule in a CI job does not. If you want to know what is enforced, run them.

## Layers

```
tokens/*_raw.dart    pure Dart, no Flutter. The source tool/export_tokens.dart
                     reads to generate web/quarto/ SCSS. Sealed: nothing outside
                     tokens/ imports these.
tokens/*.dart        the same values wrapped in Flutter types (Color, EdgeInsets).
theme/               ThemeData / CupertinoThemeData, the font fallback chains,
                     and text primitives (WabTypographyScope, WabSealText).
materials/           procedural painters — 宣紙, 拓片, 木, 布, 玉, 硃砂, 毛邊,
                     欄界, 紙摺. No image assets anywhere; every surface is drawn.
components/          widgets. The top layer, not the bottom one.
wabisabi.dart        the barrel. The only thing consumers import.
```

Imports point **down or sideways, never up**. Sideways is normal and expected:
`materials/surface.dart` composes ten of its siblings, `components/card.dart`
uses `components/button.dart`, and both are correct — a card contains a button.
The invariants that matter are direction, acyclicity, and the sealed raw layer.
There is no rule against a file importing its neighbour.

### materials/ is the centre of gravity

The kit's identity is not its component list — every design system has buttons.
It is that a button is made of a *material*: paper that has a deckle edge and
pulp clouds, wood with a grain and a bevel, cinnabar that reads as a carved
seal. `WabMaterialKind` is part of a control's meaning, not its decoration, and
the hover/pressed/disabled states are physical (rises and catches light,
compresses into the sheet) rather than a colour ramp.

That is why `materials/` sits below `components/` and why the layer has the
strictest painters in the repo: const constructors, `math.Random(seed)` so an
irregular edge is stable across rebuilds, real `shouldRepaint`.

### Why the raw/wrapped token split

`tokens/*_raw.dart` are plain `int`/`double` constants with no Flutter import so
`tool/export_tokens.dart` can run under bare `dart` and generate the Quarto SCSS
that keeps the web side in visual sync. That is the entire reason the split
exists. `palette_raw` and `spacing_raw` are read by the web exporter today;
`material_raw` and `texture_raw` remain the pure-Dart sources for their Flutter
wrappers even though the exporter does not currently consume them.

## House rules

These rules hold across the kit and `tool/check_house_rules.dart` keeps the
mechanical parts honest in CI.

**No pure black, no pure white.** A shadow is ink, not the absence of light:
everything that would have been `Colors.black` is `WAB_TEXTURE_INK` (0xFF24231F),
the rubbing ink lifted off zero so it reads warm against paper. Everything that
would have been `Colors.white` is a paper tone — `WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT`
for a lit edge, `paperWhite` (0xFFFAF6EC, 宣紙淡黃白) for a sheet. Reach for a
colour already in the palette before adding one. `lib/` contains no
`Colors.black`, no `Colors.white`, and no Material accent colour.

**Text scaling.** Nothing in `lib/` boxes text at a height it cannot give back:
the catalogue is clean from a scale factor of 1 through 2.5, and the sweep is in
`example/test/catalogue_smoke_test.dart`. A board cell is the exception and says
so — it is a printed specimen at exact geometry, and the viewer's text
preference magnifies the whole cell rather than growing type inside a fixed box.

**The numbers are golden.** `WabType` is a φ^⅓ ladder off a base of 14, so every
third rung is exactly φ apart. The catalogue's cell is a golden rectangle and
its index rail is one more golden section in from the cell width. When a size or
a proportion needs choosing, derive it from φ rather than picking a round
number. The checker rejects a font size written as a number, so a new size
means adding a rung and justifying it.

**Nothing is read below `WabType.gloss`** (11.93). A brush face at 8–10 px
thins out on a screen, and muted ink makes it worse, so the two rungs under
`gloss` are deprecated and the checker rejects them in `lib/` and the catalogue.

## Deliberate non-goals

- **No texture image assets in the kit.** Every material texture is painted. It
  costs CPU on large surfaces and buys resolution independence and themeability.
  The example may use ordinary content imagery to demonstrate image widgets.
- **No external runtime packages.** A design system that pulls in dependencies
  exports them to every consuming app.
- **Fonts bundled at full charset.** `assets/fonts/WabKai-*.ttf` is LXGW WenKai
  TC uncut, ~15 MB each, so 繁/簡 coverage never falls back to a system face.
  `tool/build_fonts.sh` regenerates them. This is ~30 MB in git and in every app
  bundle — a real cost, accepted knowingly, worth revisiting for web targets.

## Release

Dev work on `dev`, merge to `main`, tag, consuming apps bump their `ref:` pin.
The tag is the contract with consumers: **an untagged `main` is invisible to
them.** Tags currently stop at `0.0.4`, which predates the entire golden1
material rebuild.

## Known debts

Recorded so they are not rediscovered as news. The mechanical architecture,
public-surface and house-style rules are enforced in CI; the debts below are
deliberately not.

- **`WabTheme`'s palette statics are a compatibility shim.** The palette lives
  on `ThemeData` as `WabColors` and is read with `WabTheme.of(context)`; the
  seventeen `static late Color`s are still assigned so consumers pinned to an
  older tag keep working. Nothing in `lib/` reads them any more except places
  that cannot obtain a build context directly. Removing the statics is a
  breaking change waiting on a major version.
- **`WabPaymentRow` is app domain in a general kit.** A payment row is not a
  design-system primitive; it belongs to whichever app needed it. It remains as
  a deprecated migration alias until the next major version.
- **`WAB_*` SCREAMING_SNAKE token names** are house style and violate
  `constant_identifier_names`, which is the one lint the kit opts out of.
  Renaming every token breaks every consumer, so it waits for a major version.
- **Migration aliases remain on the public surface.** The formerly unprefixed
  names (`DeckleBorder`, `DotGrid`, `InkDot`, `InkDotStyle`, `TexturePainter`,
  `isIos`) are deprecated aliases for their `Wab*` replacements. The public API
  baseline is empty; deprecated aliases are intentionally exempt until the next
  major version removes them. Other deprecated compatibility names follow the
  same policy and are not advertised as new catalogue primitives.
