import 'dart:math' as math;
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

    // Styles the batched fills skip: a fill of no radius and a clear fill.
    // Only the single-dot tests use them.
    const unfilled = <String, WabInkDotStyle>{
      'opaque border as wide as the dot': WabInkDotStyle(
        color: ink,
        borderColor: rust,
        borderWidth: 11,
      ),
      'clear fill inside a ring': WabInkDotStyle(
        color: Color(0x00000000),
        borderColor: ink,
        borderWidth: 1.5,
      ),
    };

    Future<Uint8List> pixelsOf(
      WidgetTester tester,
      Widget dot, {
      TextDirection textDirection = TextDirection.ltr,
    }) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: textDirection,
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

    for (final MapEntry(key: name, value: style) in {
      ...styles,
      ...unfilled,
    }.entries) {
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

    testWidgets('the same under right-to-left text', (tester) async {
      // The grid is row-major data: column 0 stays at the left. The layout the
      // painter replaced mirrored here, and its non-directional right padding
      // then left a gap at the grid's right edge and none between the two
      // leftmost dots. The styles differ along each row, so a mirrored grid
      // cannot pass.
      const rows = 3;
      const cols = 4;
      final cells = [
        for (var i = 0; i < rows * cols; i++)
          styles.values.elementAt(i % styles.length),
      ];
      final grid = WabDotGrid<WabInkDotStyle>(
        rows: rows,
        cols: cols,
        states: cells,
        styleOf: (style) => style,
        dotSize: 7.3,
        gap: 0.9,
      );

      final ltr = await pixelsOf(tester, grid);
      final rtl = await pixelsOf(
        tester,
        grid,
        textDirection: TextDirection.rtl,
      );

      expect(rtl.length, ltr.length);
      expect(differingPixels(rtl, ltr), 0);
    });
  });

  testWidgets(
    'batched fills change only pixels on a dot edge, with or without a gap',
    (tester) async {
      // Drawn dot by dot, each fill went down before the next dot. Batched, a
      // round-capped point covers the same disc as the circle it replaced but
      // can anti-alias its edge pixels differently, and where two dots' edges
      // share a pixel (a gap under about one device pixel) that pixel
      // composites in another order. Either way, only pixels within about a
      // device pixel of a dot's edge may change, and by a bounded amount.
      const ink = Color(0xFF1A1A1A);
      const paper = Color(0xFFFAF6EC);
      const rust = Color(0xFF9A4337);
      const grey = Color(0xFFD8D8D3);
      const styles = <WabInkDotStyle>[
        WabInkDotStyle(color: grey),
        WabInkDotStyle(color: ink, borderColor: rust, borderWidth: 2),
        WabInkDotStyle(color: paper, borderColor: ink, borderWidth: 1.5),
        WabInkDotStyle(color: ink),
        WabInkDotStyle(
          color: grey,
          borderColor: Color(0x809A4337),
          borderWidth: 2,
        ),
      ];
      const rows = 3;
      const cols = 4;
      final cells = [
        for (var i = 0; i < rows * cols; i++)
          styles[(i * 3 + i ~/ cols) % styles.length],
      ];

      Future<(Uint8List, int)> pixelsOf(
        Widget grid,
        double offset,
        double pixelRatio,
      ) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: key,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(1 + offset, 1 + offset, 1, 1),
                  child: grid,
                ),
              ),
            ),
          ),
        );
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final result = await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: pixelRatio);
          final bytes = await image.toByteData();
          final width = image.width;
          image.dispose();
          return (bytes!.buffer.asUint8List(), width);
        });
        return result!;
      }

      // Measured: no changed pixel farther than 1.1 device px from an edge,
      // none changed by more than 70. Points 0.1 px wider change edge pixels
      // by more than 110.
      const edgeReach = 1.5;
      const maxChange = 80;
      final failures = <String>[];
      for (final pixelRatio in [1.0, 2.25, 3.0]) {
        for (final gap in [0.0, 0.375, 0.9, 3.0]) {
          for (final dotSize in [3.0, 7.3, 11.0]) {
            for (final offset in [0.0, 0.3, 0.7]) {
              final (batched, width) = await pixelsOf(
                WabDotGrid<WabInkDotStyle>(
                  rows: rows,
                  cols: cols,
                  states: cells,
                  styleOf: (style) => style,
                  dotSize: dotSize,
                  gap: gap,
                ),
                offset,
                pixelRatio,
              );
              final (dotByDot, _) = await pixelsOf(
                SizedBox(
                  width: cols * dotSize + (cols - 1) * gap,
                  height: rows * dotSize + (rows - 1) * gap,
                  child: CustomPaint(
                    painter: _DotByDotPainter(
                      cols: cols,
                      styles: cells,
                      dotSize: dotSize,
                      gap: gap,
                    ),
                  ),
                ),
                offset,
                pixelRatio,
              );
              expect(batched.length, dotByDot.length);

              final origin = (1 + offset) * pixelRatio;
              final radius = dotSize / 2 * pixelRatio;
              final step = (dotSize + gap) * pixelRatio;
              for (var i = 0; i < batched.length; i += 4) {
                var change = 0;
                for (var k = 0; k < 4; k++) {
                  change = math.max(
                      change, (batched[i + k] - dotByDot[i + k]).abs());
                }
                if (change == 0) {
                  continue;
                }
                final x = (i ~/ 4) % width + 0.5 - origin;
                final y = (i ~/ 4) ~/ width + 0.5 - origin;
                var nearest = double.infinity;
                for (var cell = 0; cell < cells.length; cell++) {
                  final style = cells[cell];
                  final borderColor = style.borderColor;
                  final inset = borderColor != null &&
                          (borderColor.a * 255.0).round() == 255
                      ? style.borderWidth / 2 * pixelRatio
                      : 0.0;
                  final dx = x - (radius + (cell % cols) * step);
                  final dy = y - (radius + (cell ~/ cols) * step);
                  final distance = math.sqrt(dx * dx + dy * dy);
                  for (final edge in [radius - inset, radius]) {
                    nearest = math.min(nearest, (distance - edge).abs());
                  }
                }
                if (nearest > edgeReach || change > maxChange) {
                  failures.add(
                    'ratio $pixelRatio, gap $gap, dot $dotSize, offset '
                    '$offset: pixel ($x, $y) changed by $change, '
                    '${nearest.toStringAsFixed(2)} px from a dot edge',
                  );
                }
              }
            }
          }
        }
      }

      expect(failures.take(5), isEmpty);
    },
  );

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

  testWidgets('draw calls do not grow with the number of dots', (tester) async {
    // A draw per dot cost the raster thread for every dot on every frame:
    // about 20 ms a frame for 3,390 dots on a phone, picture reused or not.
    // Fills go out in one call per colour and radius, so a 65x53 grid of
    // three colours makes as many calls as a 2x2 grid of the same three.
    Future<int> drawsFor(int rows, int cols) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: WabDotGrid<int>(
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
      final paint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final canvas = _DrawCountingCanvas();
      paint.painter!.paint(canvas, tester.getSize(find.byWidget(paint)));
      return canvas.draws;
    }

    final small = await drawsFor(2, 2);
    final large = await drawsFor(65, 53);

    expect(small, 3);
    expect(large, small);
  });
}

/// Counts the draw calls a painter makes, and records nothing.
class _DrawCountingCanvas implements Canvas {
  int draws = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('"draw')) {
      draws++;
    }
    return null;
  }
}

/// The grid as it was drawn before its fills were batched: each dot's fill,
/// then its border, dot by dot in row-major order.
class _DotByDotPainter extends CustomPainter {
  const _DotByDotPainter({
    required this.cols,
    required this.styles,
    required this.dotSize,
    required this.gap,
  });

  final int cols;
  final List<WabInkDotStyle> styles;
  final double dotSize;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = dotSize / 2;
    final step = dotSize + gap;
    for (var index = 0; index < styles.length; index++) {
      final style = styles[index];
      final center = Offset(
        radius + (index % cols) * step,
        radius + (index ~/ cols) * step,
      );
      final borderColor = style.borderColor;
      final fillInset =
          borderColor != null && (borderColor.a * 255.0).round() == 255
              ? style.borderWidth / 2
              : 0.0;
      canvas.drawCircle(
        center,
        radius - fillInset,
        Paint()..color = style.color,
      );
      if (borderColor != null) {
        canvas.drawCircle(
          center,
          (radius - style.borderWidth / 2).clamp(0, radius),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = borderColor
            ..strokeWidth = style.borderWidth,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotByDotPainter oldDelegate) => true;
}
