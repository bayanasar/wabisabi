import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/components/dot_grid.dart';

void main() {
  group('a grid dot paints the pixels a WabInkDot of its style paints', () {
    // The painter replaced one WabInkDot per dot, so a style must still draw
    // the same dot. Under an opaque border BoxDecoration stops the fill at the
    // border's centre line; a fill drawn to the full radius tints the border's
    // anti-aliased outer edge. A zero border width draws a hairline.
    const ink = Color(0xFF1A1A1A);
    const paper = Color(0xFFFAF6EC);
    const rust = Color(0xFF9A4337);
    const styles = <String, WabInkDotStyle>{
      'fill only': WabInkDotStyle(color: ink),
      'opaque border': WabInkDotStyle(
        color: ink,
        borderColor: rust,
        borderWidth: 2,
      ),
      'hollow ring with a fractional border': WabInkDotStyle(
        color: paper,
        borderColor: ink,
        borderWidth: 1.5,
      ),
      'translucent border': WabInkDotStyle(
        color: ink,
        borderColor: Color(0x809A4337),
        borderWidth: 2,
      ),
      'zero-width border': WabInkDotStyle(color: paper, borderColor: ink),
    };

    Future<Uint8List> pixelsOf(WidgetTester tester, Widget dot) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RepaintBoundary(key: key, child: dot),
          ),
        ),
      );
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      final pixels = await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 3);
        final bytes = await image.toByteData();
        image.dispose();
        return bytes!.buffer.asUint8List();
      });
      return pixels!;
    }

    int differingPixels(Uint8List a, Uint8List b) {
      var count = 0;
      for (var i = 0; i < a.length; i += 4) {
        if (a[i] != b[i] ||
            a[i + 1] != b[i + 1] ||
            a[i + 2] != b[i + 2] ||
            a[i + 3] != b[i + 3]) {
          count++;
        }
      }
      return count;
    }

    for (final MapEntry(key: name, value: style) in styles.entries) {
      testWidgets(name, (tester) async {
        final dot = await pixelsOf(
          tester,
          WabInkDot(style: style, size: 11),
        );
        final grid = await pixelsOf(
          tester,
          WabDotGrid<WabInkDotStyle>(
            rows: 1,
            cols: 1,
            states: [style],
            styleOf: (style) => style,
            dotSize: 11,
          ),
        );

        expect(grid.length, dot.length);
        expect(differingPixels(grid, dot), 0);
      });
    }

    testWidgets('across a 3x4 grid at a fractional pitch', (tester) async {
      // The grid before the painter laid its dots out as a Row per grid row
      // inside a Column, each gap a Padding. Rebuilt here, it pins the
      // painter's `radius + col * step` against the old layout's summed
      // paddings, at the fractional sizes consumers fit a grid to.
      const rows = 3;
      const cols = 4;
      const dotSize = 7.3;
      const gap = 0.9;
      final cells = [
        for (var i = 0; i < rows * cols; i++)
          styles.values.elementAt(i % styles.length),
      ];

      final dots = await pixelsOf(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var r = 0; r < rows; r++)
              Padding(
                padding: EdgeInsets.only(bottom: r == rows - 1 ? 0 : gap),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var c = 0; c < cols; c++)
                      Padding(
                        padding: EdgeInsets.only(
                          right: c == cols - 1 ? 0 : gap,
                        ),
                        child: WabInkDot(
                          style: cells[r * cols + c],
                          size: dotSize,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
      final grid = await pixelsOf(
        tester,
        WabDotGrid<WabInkDotStyle>(
          rows: rows,
          cols: cols,
          states: cells,
          styleOf: (style) => style,
          dotSize: dotSize,
          gap: gap,
        ),
      );

      expect(grid.length, dots.length);
      expect(differingPixels(grid, dots), 0);
    });
  });

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

      // A grid larger than its parent reports the overflow in debug builds,
      // exactly as the widget-per-dot Column did before the painter. That
      // report is the contract under test, so consume that one error and
      // assert what it is instead of swallowing whatever was thrown.
      final overflow = tester.takeException();
      expect(overflow, isFlutterError);
      expect(overflow.toString(), contains('overflowed'));

      final paint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final paintSize = tester.getSize(find.byWidget(paint));
      expect(paintSize.width, cols * 11 + (cols - 1) * 4);
      expect(paintSize.height, rows * 11 + (rows - 1) * 4);
      expect(paintSize.height, 971);

      // The 600x400 parent did not shrink the painter.
      expect(paintSize.width, greaterThan(600));
      expect(paintSize.height, greaterThan(400));
    },
  );

  testWidgets(
    'render and element counts do not grow with the number of dots',
    (tester) async {
      // The widget-per-dot grid this painter replaced built one Container per
      // dot: 13911 render objects and 20802 elements for a 65x53 grid. Layout
      // and rebuild work scale with those counts, so pin that a 3445-dot grid
      // now builds exactly the same subtree as a 2x2 one.
      int renderObjectsUnder(Finder finder) {
        var count = 0;
        void visit(RenderObject object) {
          count++;
          object.visitChildren(visit);
        }

        visit(tester.renderObject(finder));
        return count;
      }

      int elementsUnder(Finder finder) {
        var count = 0;
        void visit(Element element) {
          count++;
          element.visitChildElements(visit);
        }

        visit(tester.element(finder));
        return count;
      }

      Future<(int, int)> countsFor(int rows, int cols) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: WabDotGrid<int>(
                key: ValueKey<String>('grid-$rows-$cols'),
                rows: rows,
                cols: cols,
                states: List<int>.generate(rows * cols, (index) => index % 3),
                styleOf: (state) => WabInkDotStyle(
                  color: Color(0xFF000000 + state * 0x333333),
                ),
                dotSize: 4,
                gap: 1,
              ),
            ),
          ),
        );
        final grid = find.byKey(ValueKey<String>('grid-$rows-$cols'));
        return (renderObjectsUnder(grid), elementsUnder(grid));
      }

      final (smallRenderObjects, smallElements) = await countsFor(2, 2);
      final (largeRenderObjects, largeElements) = await countsFor(65, 53);

      expect(largeRenderObjects, smallRenderObjects);
      expect(largeElements, smallElements);
      expect(largeRenderObjects, lessThan(10));
      expect(largeElements, lessThan(10));
    },
  );
}
