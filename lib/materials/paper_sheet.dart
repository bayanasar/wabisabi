import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';
import 'fiber_texture.dart';
import 'paper_texture.dart';

/// A large aged xuan sheet used as an application ground.
class WabPaperSheet extends StatelessWidget {
  const WabPaperSheet({
    super.key,
    required this.child,
    this.isDark,
    this.horizontalFolds = const [.19, .47, .73],
    this.verticalFolds = const [.34, .67],
  });

  final Widget child;
  final bool? isDark;
  final List<double> horizontalFolds;
  final List<double> verticalFolds;

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? WabTheme.of(context).isDark;
    final base =
        dark ? WAB_TEXTURE_PAPER_BASE_DARK : WAB_TEXTURE_PAPER_BASE_LIGHT;
    return ColoredBox(
      color: base,
      child: Stack(
        children: [
          Positioned.fill(
            child: WabPaperTexture(
              isDark: dark,
              kind: WabPaperTextureKind.mottle,
              strength: dark ? .58 : .72,
            ),
          ),
          Positioned.fill(
            child: WabFiberTexture(
              isDark: dark,
              seed: 991,
              strength: dark ? .12 : .16,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _SheetAgePainter(
                isDark: dark,
                horizontalFolds: horizontalFolds,
                verticalFolds: verticalFolds,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _SheetAgePainter extends CustomPainter {
  const _SheetAgePainter({
    required this.isDark,
    required this.horizontalFolds,
    required this.verticalFolds,
  });

  final bool isDark;
  final List<double> horizontalFolds;
  final List<double> verticalFolds;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final shadow =
        isDark ? WAB_TEXTURE_PAPER_CREASE_DARK : WAB_TEXTURE_PAPER_CREASE_LIGHT;
    final light = isDark
        ? WAB_TEXTURE_PAPER_HIGHLIGHT_DARK
        : WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT;
    final age =
        isDark ? WAB_TEXTURE_PAPER_AGE_DARK : WAB_TEXTURE_PAPER_AGE_LIGHT;

    // Internal grid folds are gapless: mostly a shallow shadow ridge, with only
    // a hair of reflected light. No bright band that reads as spacing.
    void hFold(double t) {
      final y = size.height * t.clamp(0.0, 1.0);
      final band = Rect.fromLTWH(0, y - 2.8, size.width, 5.6);
      canvas.drawRect(
        band,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              shadow.withValues(alpha: .055),
              shadow.withValues(alpha: .14),
              light.withValues(alpha: isDark ? .025 : .045),
              Colors.transparent,
            ],
          ).createShader(band),
      );
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + .25),
        Paint()
          ..color = shadow.withValues(alpha: .22)
          ..strokeWidth = .55,
      );
    }

    void vFold(double t) {
      final x = size.width * t.clamp(0.0, 1.0);
      final band = Rect.fromLTWH(x - 2.8, 0, 5.6, size.height);
      canvas.drawRect(
        band,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              shadow.withValues(alpha: .045),
              shadow.withValues(alpha: .115),
              light.withValues(alpha: isDark ? .020 : .035),
              Colors.transparent,
            ],
          ).createShader(band),
      );
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + .22, size.height),
        Paint()
          ..color = shadow.withValues(alpha: .17)
          ..strokeWidth = .5,
      );
    }

    for (final y in horizontalFolds) {
      hFold(y);
    }
    for (final x in verticalFolds) {
      vFold(x);
    }

    final edge = Paint()..color = age.withValues(alpha: isDark ? .05 : .055);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 2.2), edge);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 3.2, size.width, 3.2), edge);
    canvas.drawRect(Rect.fromLTWH(0, 0, 2.0, size.height), edge);
    canvas.drawRect(Rect.fromLTWH(size.width - 2.0, 0, 2.0, size.height), edge);
  }

  @override
  bool shouldRepaint(_SheetAgePainter old) =>
      old.isDark != isDark ||
      old.horizontalFolds != horizontalFolds ||
      old.verticalFolds != verticalFolds;
}
