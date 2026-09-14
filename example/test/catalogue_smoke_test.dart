// The catalogue is the kit's only visual test, so it must at least lay out
// cleanly — at every width, in both themes. A Flutter layout overflow throws in
// a test but only paints a stripe in debug and silently clips in release, which
// is how the board came to fit at exactly one viewport width.
//
// tool/check_public_api.dart guarantees every exported type appears in the
// catalogue; this guarantees the page it appears on actually renders.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/wabisabi.dart';
import 'package:example/golden1_showcase.dart';

/// Phones, tablets, the compact/wide breakpoint either side, and laptops up to
/// a large desktop.
const _widths = <double>[
  320, 360, 390, 420, 600, 820, 899, 900, 1000, 1200, 1400, 1600, 1920,
];

/// Text-size settings a viewer can actually pick.
const _textScales = <double>[1.15, 1.3, 1.5, 2.0, 2.5];

void main() {
  for (final dark in [false, true]) {
    final theme = dark ? 'dark' : 'light';

    for (final width in _widths) {
      testWidgets('lays out with no overflow at ${width.toInt()}px ($theme)',
          (tester) async {
        tester.view.physicalSize = Size(width, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(MaterialApp(
          theme: WabTheme.materialTheme(lightTheme: true),
          darkTheme: WabTheme.materialTheme(lightTheme: false),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: Golden1Showcase(onToggleTheme: () {}),
        ));
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(Golden1Showcase), findsOneWidget);
      });
    }

    for (final scale in _textScales) {
      testWidgets('survives a text scale of ${scale}x ($theme)',
          (tester) async {
        tester.view.physicalSize = const Size(1600, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(MaterialApp(
          theme: WabTheme.materialTheme(lightTheme: true),
          darkTheme: WabTheme.materialTheme(lightTheme: false),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: Golden1Showcase(onToggleTheme: () {}),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(Golden1Showcase), findsOneWidget);
      });
    }

    testWidgets('draws every section ($theme)', (tester) async {
      tester.view.physicalSize = const Size(1600, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        theme: WabTheme.materialTheme(lightTheme: true),
        darkTheme: WabTheme.materialTheme(lightTheme: false),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        home: Golden1Showcase(onToggleTheme: () {}),
      ));
      await tester.pump(const Duration(milliseconds: 200));

      for (final title in const [
        '01  色 | PALETTE',
        '02  材 | MATERIALS',
        '10  容器 | CONTAINERS',
        '12  明暗 | LIGHT & DARK',
        '13  骨架 | SCAFFOLD & CHROME',
        '14  零件 | ODDS & ENDS',
      ]) {
        expect(find.text(title), findsOneWidget, reason: 'missing $title');
      }
    });
  }
}
