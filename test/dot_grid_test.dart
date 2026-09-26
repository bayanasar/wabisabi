import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/components/dot_grid.dart';

void main() {
  testWidgets(
    'large dot grid paints as one surface instead of per-dot widgets',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const rows = 65;
      const cols = 53;
      final states = List<int>.generate(
        rows * cols,
        (index) => index.isEven ? 0 : 1,
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: WabDotGrid<int>(
              key: const Key('large-grid'),
              rows: rows,
              cols: cols,
              states: states,
              styleOf: (state) => WabInkDotStyle(
                color: state == 0
                    ? const Color(0xFF111111)
                    : const Color(0xFFEEEEEE),
              ),
              dotSize: 11,
              gap: 4,
            ),
          ),
        ),
      );

      final grid = find.byKey(const Key('large-grid'));
      expect(grid, findsOneWidget);
      expect(
        find.descendant(of: grid, matching: find.byType(WabInkDot)),
        findsNothing,
      );
      expect(
        find.descendant(of: grid, matching: find.byType(CustomPaint)),
        findsOneWidget,
      );

      final size = tester.getSize(grid);
      expect(size.width, cols * 11 + (cols - 1) * 4);
      expect(size.height, rows * 11 + (rows - 1) * 4);
    },
  );

  testWidgets(
    'tight parent does not shrink the painter below intrinsic grid geometry',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const rows = 65;
      const cols = 53;
      final states = List<int>.filled(rows * cols, 0);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 600,
            height: 400,
            child: WabDotGrid<int>(
              rows: rows,
              cols: cols,
              states: states,
              styleOf: (_) => const WabInkDotStyle(
                color: Color(0xFF111111),
              ),
              dotSize: 11,
              gap: 4,
            ),
          ),
        ),
      );

      final paint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final paintSize = tester.getSize(find.byWidget(paint));
      expect(paintSize.width, cols * 11 + (cols - 1) * 4);
      expect(paintSize.height, rows * 11 + (rows - 1) * 4);
    },
  );
}
