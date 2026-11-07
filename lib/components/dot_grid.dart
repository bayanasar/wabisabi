import 'dart:ui' show PointMode;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Visual style for a single [WabInkDot]. Pure data — no semantics.
class WabInkDotStyle {
  const WabInkDotStyle({
    required this.color,
    this.borderColor,
    this.borderWidth = 0,
  });

  final Color color;
  final Color? borderColor;

  /// Width of the border, drawn inside the dot's edge. With a [borderColor],
  /// zero draws a hairline, as a zero-width [BorderSide] does.
  final double borderWidth;

  @override
  bool operator ==(Object other) =>
      other is WabInkDotStyle &&
      other.color == color &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth;

  @override
  int get hashCode => Object.hash(color, borderColor, borderWidth);
}

/// A single round ink dot rendered from a passed [WabInkDotStyle].
/// Dumb widget: it renders what it is told, nothing more.
class WabInkDot extends StatelessWidget {
  const WabInkDot({super.key, required this.style, this.size = 10});

  final WabInkDotStyle style;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: style.color,
        border: style.borderColor == null
            ? null
            : Border.all(color: style.borderColor!, width: style.borderWidth),
      ),
    );
  }
}

/// A generic `rows × cols` matrix of round dots.
///
/// Dumb widget: it takes a flat, row-major array of cell [states] and a
/// [styleOf] mapping from a state to an [WabInkDotStyle]. It carries no domain
/// semantics (no "week", "life", etc.) — consumers own that meaning.
///
/// Column 0 is always at the left: the grid does not mirror under right-to-left
/// text.
///
/// The grid keeps its intrinsic dot geometry under a tighter parent. Consumers
/// that need it to fit a smaller viewport should scale or scroll it explicitly,
/// matching the pre-painter overflow contract rather than silently shrinking
/// or clipping the dot field.
class WabDotGrid<S> extends StatelessWidget {
  const WabDotGrid({
    super.key,
    required this.rows,
    required this.cols,
    required this.states,
    required this.styleOf,
    this.dotSize = 10,
    this.gap = 3,
  }) : assert(
          states.length == rows * cols,
          'states.length must equal rows * cols',
        );

  final int rows;
  final int cols;

  /// Row-major cell states, length == rows * cols.
  final List<S> states;

  /// Maps a cell state to its dot style.
  final WabInkDotStyle Function(S state) styleOf;

  final double dotSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final styles = List<WabInkDotStyle>.unmodifiable(states.map(styleOf));
    final width = cols == 0 ? 0.0 : cols * dotSize + (cols - 1) * gap;
    final height = rows == 0 ? 0.0 : rows * dotSize + (rows - 1) * gap;
    return UnconstrainedBox(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _WabDotGridPainter(
            rows: rows,
            cols: cols,
            styles: styles,
            dotSize: dotSize,
            gap: gap,
          ),
        ),
      ),
    );
  }
}

class _WabDotGridPainter extends CustomPainter {
  const _WabDotGridPainter({
    required this.rows,
    required this.cols,
    required this.styles,
    required this.dotSize,
    required this.gap,
  });

  final int rows;
  final int cols;
  final List<WabInkDotStyle> styles;
  final double dotSize;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = dotSize / 2;
    final step = dotSize + gap;

    // Fills are drawn in batches, one call per colour and radius: a point
    // stroked with a round cap as wide as the dot is that dot. A call per dot
    // costs the raster thread for every dot on every frame: Impeller keeps no
    // raster cache, so it replays the picture even when it is reused.
    final fills = <(Color, double), List<double>>{};
    final bordered = <int>[];
    for (var row = 0; row < rows; row++) {
      final y = radius + row * step;
      for (var col = 0; col < cols; col++) {
        final index = row * cols + col;
        final style = styles[index];
        final borderColor = style.borderColor;
        if (borderColor != null) {
          bordered.add(index);
        }

        // As in BoxDecoration, an opaque border (8-bit alpha 255) holds the
        // fill back to the border's centre line, out of its anti-aliased
        // outer edge; a translucent one lets the fill show through.
        final fillInset =
            borderColor != null && (borderColor.a * 255.0).round() == 255
                ? style.borderWidth / 2
                : 0.0;
        final fillRadius = radius - fillInset;
        // A zero-width point would still draw a hairline dot; a circle of no
        // radius draws nothing, and neither does a clear colour.
        if (fillRadius <= 0 || style.color.a == 0) {
          continue;
        }
        (fills[(style.color, fillRadius)] ??= <double>[])
          ..add(radius + col * step)
          ..add(y);
      }
    }

    final fill = Paint()..strokeCap = StrokeCap.round;
    for (final MapEntry(key: (color, fillRadius), value: points)
        in fills.entries) {
      fill
        ..color = color
        ..strokeWidth = fillRadius * 2;
      canvas.drawRawPoints(
        PointMode.points,
        Float32List.fromList(points),
        fill,
      );
    }

    // Borders are few, and drawn one by one over the fills. Dots do not
    // overlap, so drawing every fill first changes no pixel.
    final stroke = Paint()..style = PaintingStyle.stroke;
    for (final index in bordered) {
      final style = styles[index];
      final center = Offset(
        radius + (index % cols) * step,
        radius + (index ~/ cols) * step,
      );
      // A zero width draws a hairline, as a zero-width BorderSide does.
      stroke
        ..color = style.borderColor!
        ..strokeWidth = style.borderWidth;
      canvas.drawCircle(
        center,
        (radius - style.borderWidth / 2).clamp(0, radius),
        stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WabDotGridPainter oldDelegate) {
    return rows != oldDelegate.rows ||
        cols != oldDelegate.cols ||
        dotSize != oldDelegate.dotSize ||
        gap != oldDelegate.gap ||
        !listEquals(styles, oldDelegate.styles);
  }
}

/// Old names, kept so consumers can migrate without a broken build.
@Deprecated('Renamed to WabDotGrid. This alias goes at the next major version.')
typedef DotGrid<S> = WabDotGrid<S>;

@Deprecated('Renamed to WabInkDot. This alias goes at the next major version.')
typedef InkDot = WabInkDot;

@Deprecated(
  'Renamed to WabInkDotStyle. This alias goes at the next major version.',
)
typedef InkDotStyle = WabInkDotStyle;
