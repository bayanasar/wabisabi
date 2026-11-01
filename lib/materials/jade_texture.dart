import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 玉面 — translucent celadon clouding with only occasional mineral veins.
class WabJadeTexture extends StatelessWidget {
  const WabJadeTexture({super.key, this.isDark, this.child, this.seed = 421});

  final bool? isDark;
  final Widget? child;
  final int seed;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _JadePainter(
            isDark: isDark ?? WabTheme.of(context).isDark, seed: seed),
        child: child,
      );
}

class _JadePainter extends CustomPainter {
  const _JadePainter({required this.isDark, required this.seed});

  final bool isDark;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final base =
        isDark ? WAB_TEXTURE_JADE_BASE_DARK : WAB_TEXTURE_JADE_BASE_LIGHT;
    final deep =
        isDark ? WAB_TEXTURE_JADE_DEEP_DARK : WAB_TEXTURE_JADE_DEEP_LIGHT;
    final cloud =
        isDark ? WAB_TEXTURE_JADE_CLOUD_DARK : WAB_TEXTURE_JADE_CLOUD_LIGHT;
    final vein =
        isDark ? WAB_TEXTURE_JADE_VEIN_DARK : WAB_TEXTURE_JADE_VEIN_LIGHT;

    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    for (var i = 0; i < 7; i++) {
      final rx = size.width * (.16 + rnd.nextDouble() * .24);
      final ry = size.height * (.18 + rnd.nextDouble() * .30);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
              rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
          width: rx * 2,
          height: ry * 2,
        ),
        Paint()
          ..color =
              (i.isEven ? cloud : deep).withValues(alpha: i.isEven ? .24 : .13)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, math.min(rx, ry) * .45),
      );
    }

    // Mineral veins should be rare enough to feel discovered rather than noisy.
    for (var i = 0; i < 2; i++) {
      final start =
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final path = Path()..moveTo(start.dx, start.dy);
      var p = start;
      for (var j = 0; j < 3; j++) {
        final nx = (p.dx + (rnd.nextDouble() - .5) * size.width * .24)
            .clamp(0.0, size.width)
            .toDouble();
        final ny = (p.dy + (rnd.nextDouble() - .5) * size.height * .32)
            .clamp(0.0, size.height)
            .toDouble();
        p = Offset(nx, ny);
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = vein.withValues(alpha: .035 + rnd.nextDouble() * .025)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .35 + rnd.nextDouble() * .30,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, math.max(1.0, size.height * .16)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT.withValues(
                alpha: isDark ? .08 : .26),
            Colors.transparent,
          ],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_JadePainter old) =>
      old.isDark != isDark || old.seed != seed;
}
