# wabisabi

侘寂 — a Flutter widget kit with an East Asian document grammar. Paper with a
deckle edge, wood with a grain, cinnabar that reads as a pressed seal. Every
surface is painted procedurally; there is not one image asset in the package.

No third-party dependencies. The Flutter SDK and nothing else.

```yaml
dependencies:
  wabisabi:
    git:
      url: <your remote>
      ref: v0.0.4
```

```dart
import 'package:wabisabi/wabisabi.dart';

MaterialApp(
  theme: WabTheme.materialTheme(lightTheme: true),
  darkTheme: WabTheme.materialTheme(lightTheme: false),
  themeMode: ThemeMode.system,
  home: const MyPage(),
);
```

Read the palette with `WabTheme.of(context)`; it travels on `ThemeData`, so a
widget that reads it rebuilds when the theme changes.

```dart
final wab = WabTheme.of(context);
WabButton(
  kind: WabMaterialKind.wood,
  onPressed: () {},
  child: Text('取 茶', style: TextStyle(color: wab.textColor)),
);
```

## The catalogue

`example/` is the specimen board: every type the package exports is drawn
there, and CI fails if one is not. Run it with `flutter run` from `example/`,
or build it for the web.

## Layout

`tokens/ → theme/ → materials/ → components/`, one barrel at
`lib/wabisabi.dart`. What the layers mean and what is deliberately left undone
is in [ARCHITECTURE.md](ARCHITECTURE.md). The rules that can be checked are
checked, by `tool/check_layering.dart` and `tool/check_public_api.dart` in CI.

## Fonts

The package bundles its own faces so consumers never depend on a system font:

- **WabKai** — [LXGW WenKai TC](https://github.com/lxgw/LxgwWenKaiTC) (霞鶩文楷 TC),
  繁簡全覆蓋, Regular and Medium.
- **WabMono** — [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono),
  static 400/500 instances. It has no CJK; `kWabMonoFallback` puts WabKai
  next, so Chinese in a monospace label is drawn in WabKai too.

Both are licensed **SIL Open Font License 1.1**, not under this package's
licence. The full OFL texts ship in `assets/fonts/`. The files are renamed
because OFL reserves the original names; if you rebuild them, keep the renaming
(`tool/build_fonts.sh` does).

This is roughly 30 MB of font data in the package and in every app that bundles
it — a deliberate trade for never falling back to a system face. See
ARCHITECTURE.md.

## Licence

BSD 3-Clause. See [LICENSE](LICENSE).
