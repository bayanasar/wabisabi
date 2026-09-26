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
    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()..style = PaintingStyle.stroke;

    for (var row = 0; row < rows; row++) {
      final y = radius + row * step;
      for (var col = 0; col < cols; col++) {
        final style = styles[row * cols + col];
        final center = Offset(radius + col * step, y);

        fill.color = style.color;
        canvas.drawCircle(center, radius, fill);

        final borderColor = style.borderColor;
        if (borderColor != null && style.borderWidth > 0) {
          stroke
            ..color = borderColor
            ..strokeWidth = style.borderWidth;
          canvas.drawCircle(
            center,
            (radius - style.borderWidth / 2).clamp(0, radius),
            stroke,
          );
        }
      }
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
