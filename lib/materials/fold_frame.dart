import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 四摺紙格 — a content region bounded by four physical paper creases.
///
/// This is a material boundary, not a semantic card: it has no border stroke,
/// elevation, action semantics or dashboard chrome. It is the standalone form
/// of the fold-grid language used by the catalogue sheet.
class WabFoldFrame extends StatelessWidget {
  const WabFoldFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.depth = 7,
    this.fill,
    this.isDark,
  });

  final Widget child;
  final EdgeInsets padding;
  final double depth;
  final Color? fill;
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    Widget body = CustomPaint(
      foregroundPainter: _FoldFramePainter(
        dark: isDark ?? WabTheme.of(context).isDark,
        depth: depth,
      ),
      child: Padding(padding: padding, child: child),
    );
    if (fill != null) body = ColoredBox(color: fill!, child: body);
    return body;
  }
}

class _FoldFramePainter extends CustomPainter {
  const _FoldFramePainter({required this.dark, required this.depth});

  final bool dark;
  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final crease =
        dark ? WAB_TEXTURE_PAPER_CREASE_DARK : WAB_TEXTURE_PAPER_CREASE_LIGHT;
    final highlight = dark
        ? WAB_TEXTURE_PAPER_HIGHLIGHT_DARK
        : WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT;

    final d = depth.clamp(3.0, size.shortestSide / 4).toDouble();

    void band(Rect rect, Alignment begin, Alignment end, List<Color> colors) {
      canvas.drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: begin,
            end: end,
            colors: colors,
          ).createShader(rect),
      );
    }

    final c0 = crease.withValues(alpha: dark ? .18 : .12);
    final c1 = crease.withValues(alpha: dark ? .10 : .07);
    final hi = highlight.withValues(alpha: dark ? .08 : .22);

    band(
      Rect.fromLTWH(0, 0, size.width, d),
      Alignment.topCenter,
      Alignment.bottomCenter,
      [c0, c1, hi, Colors.transparent],
    );
    band(
      Rect.fromLTWH(0, size.height - d, size.width, d),
      Alignment.bottomCenter,
      Alignment.topCenter,
      [c0, c1, hi, Colors.transparent],
    );
    band(
      Rect.fromLTWH(0, 0, d, size.height),
      Alignment.centerLeft,
      Alignment.centerRight,
      [c0, c1, hi, Colors.transparent],
    );
    band(
      Rect.fromLTWH(size.width - d, 0, d, size.height),
      Alignment.centerRight,
      Alignment.centerLeft,
      [c0, c1, hi, Colors.transparent],
    );

    final line = Paint()
      ..color = crease.withValues(alpha: dark ? .22 : .15)
      ..strokeWidth = .55;
    canvas.drawLine(Offset(0, .5), Offset(size.width, .5), line);
    canvas.drawLine(
      Offset(0, size.height - .5),
      Offset(size.width, size.height - .5),
      line,
    );
    canvas.drawLine(Offset(.5, 0), Offset(.5, size.height), line);
    canvas.drawLine(
      Offset(size.width - .5, 0),
      Offset(size.width - .5, size.height),
      line,
    );
  }

  @override
  bool shouldRepaint(_FoldFramePainter old) =>
      old.dark != dark || old.depth != depth;
}
