import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/components/dot_grid.dart';

void main() {
  testWidgets('large dot grid paints as one surface instead of per-dot widgets',
      (tester) async {
    const rows = 65;
    const cols = 53;
    final states = List<int>.generate(rows * cols, (index) => index.isEven ? 0 : 1);

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
              color: state == 0 ? const Color(0xFF111111) : const Color(0xFFEEEEEE),
            ),
            dotSize: 11,
            gap: 4,
          ),
        ),
      ),
    );

    final grid = find.byKey(const Key('large-grid'));
    expect(grid, findsOneWidget);
    expect(find.descendant(of: grid, matching: find.byType(WabInkDot)), findsNothing);
    expect(find.descendant(of: grid, matching: find.byType(CustomPaint)), findsOneWidget);

    final size = tester.getSize(grid);
    expect(size.width, cols * 11 + (cols - 1) * 4);
    expect(size.height, rows * 11 + (rows - 1) * 4);
  });
}
