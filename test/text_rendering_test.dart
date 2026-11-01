import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/wabisabi.dart';

void main() {
  group('WabiSabi text style boundary tests', () {
    for (final isDark in [false, true]) {
      final themeName = isDark ? 'dark' : 'light';

      testWidgets(
          'WabScaffold (Material builder) in $themeName theme establishes clean text styles',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: WabTheme.materialTheme(lightTheme: !isDark),
            home: Builder(
              builder: (context) {
                final scaffold = WabScaffold(
                  body: const WabPanel(
                    title: 'Panel Title',
                    child: Text('normal body text'),
                  ),
                );
                return scaffold.createMaterialWidget(context);
              },
            ),
          ),
        );

        final textFinder = find.text('normal body text');
        expect(textFinder, findsOneWidget);
        final element = tester.element(textFinder);
        final style = DefaultTextStyle.of(element).style;

        // Verify body text is not fallback
        expect(style.fontSize, isNotNull);
        expect(style.fontSize!, lessThan(30.0));
        expect(style.color, isNot(const Color(0xD0FF0000)));
        expect(style.decoration, isNot(TextDecoration.underline));
        expect(style.decorationStyle, isNot(TextDecorationStyle.double));
      });

      testWidgets(
          'WabScaffold (Cupertino builder / macOS target) in $themeName theme establishes clean text styles',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: WabTheme.materialTheme(lightTheme: !isDark),
            home: Builder(
              builder: (context) {
                final scaffold = WabScaffold(
                  body: const WabPanel(
                    title: 'Panel Title',
                    child: Text('normal body text'),
                  ),
                );
                return scaffold.createCupertinoWidget(context);
              },
            ),
          ),
        );

        final textFinder = find.text('normal body text');
        expect(textFinder, findsOneWidget);
        final element = tester.element(textFinder);
        final style = DefaultTextStyle.of(element).style;

        // Verify body text is not fallback
        expect(style.fontSize, isNotNull);
        expect(style.fontSize!, lessThan(30.0));
        expect(style.color, isNot(const Color(0xD0FF0000)));
        expect(style.decoration, isNot(TextDecoration.underline));
        expect(style.decorationStyle, isNot(TextDecorationStyle.double));
      });

      testWidgets(
          'WabButton in $themeName theme establishes complete text style',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: WabTheme.materialTheme(lightTheme: !isDark),
            home: Builder(
              builder: (context) {
                final scaffold = WabScaffold(
                  body: WabButton(
                    kind: WabMaterialKind.zhuwen,
                    onPressed: () {},
                    child: const Text('Button'),
                  ),
                );
                return scaffold.createCupertinoWidget(context);
              },
            ),
          ),
        );

        final buttonFinder = find.text('Button');
        expect(buttonFinder, findsOneWidget);
        final element = tester.element(buttonFinder);
        final style = DefaultTextStyle.of(element).style;

        // Verify button text style is complete and free of fallback artifacts
        expect(style.fontSize, isNotNull);
        expect(style.fontSize!, lessThan(30.0));
        expect(style.decoration, isNot(TextDecoration.underline));
        expect(style.decorationStyle, isNot(TextDecorationStyle.double));
        expect(style.color, equals(WabTheme.sealColor));
        expect(style.letterSpacing, equals(3.0));
      });
    }
  });
}
