import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 紙摺分隔 — a fold used as a separator in a sheet of paper.
///
/// This paints only the crease language over the surrounding material. It is
/// not a standalone paper strip: use it where a sheet would naturally fold or
/// where a tactile divider is needed.
class WabPaperFold extends StatelessWidget {
  const WabPaperFold({
    super.key,
    this.child,
    this.height = 12,
    this.padding = EdgeInsets.zero,
    this.isDark,
    this.seed = 197,
  });

  final Widget? child;
  final double height;
  final EdgeInsets padding;
  final bool? isDark;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? WabTheme.of(context).isDark;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _PaperFoldPainter(isDark: dark, seed: seed),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _PaperFoldPainter extends CustomPainter {
  const _PaperFoldPainter({required this.isDark, required this.seed});

  final bool isDark;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final crease =
        isDark ? WAB_TEXTURE_PAPER_CREASE_DARK : WAB_TEXTURE_PAPER_CREASE_LIGHT;
    final highlight = isDark
        ? WAB_TEXTURE_PAPER_HIGHLIGHT_DARK
        : WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT;
    final rnd = math.Random(seed);
    final y = size.height * .52;

    final band = Rect.fromLTWH(0, y - 3.5, size.width, 7);
    canvas.drawRect(
      band,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            highlight.withValues(alpha: isDark ? .06 : .16),
            crease.withValues(alpha: isDark ? .12 : .10),
            crease.withValues(alpha: isDark ? .19 : .16),
            highlight.withValues(alpha: isDark ? .04 : .20),
            Colors.transparent,
          ],
        ).createShader(band),
    );

    final creasePath = Path()..moveTo(0, y);
    final highlightPath = Path()..moveTo(0, y - .9);
    for (var x = 0.0; x <= size.width + 12; x += 24) {
      final wobble = (rnd.nextDouble() - .5) * .9;
      creasePath.lineTo(x, y + wobble);
      highlightPath.lineTo(x, y - .9 + wobble * .35);
    }

    canvas.drawPath(
      creasePath,
      Paint()
        ..color = crease.withValues(alpha: isDark ? .30 : .24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .85
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .8),
    );
    canvas.drawPath(
      highlightPath,
      Paint()
        ..color = highlight.withValues(alpha: isDark ? .10 : .46)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .55,
    );
  }

  @override
  bool shouldRepaint(_PaperFoldPainter old) =>
      old.isDark != isDark || old.seed != seed;
}
