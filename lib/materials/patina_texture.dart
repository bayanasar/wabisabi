import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 舊化 / PATINA — warm oxidised ground with a sparse crackle network.
class WabPatinaTexture extends StatelessWidget {
  const WabPatinaTexture({super.key, this.isDark, this.child, this.seed = 877});

  final bool? isDark;
  final Widget? child;
  final int seed;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _PatinaPainter(
            isDark: isDark ?? WabTheme.of(context).isDark, seed: seed),
        child: child,
      );
}

class _PatinaPainter extends CustomPainter {
  const _PatinaPainter({required this.isDark, required this.seed});
  final bool isDark;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final base =
        isDark ? WAB_TEXTURE_PATINA_BASE_DARK : WAB_TEXTURE_PATINA_BASE_LIGHT;
    final deep =
        isDark ? WAB_TEXTURE_PATINA_DEEP_DARK : WAB_TEXTURE_PATINA_DEEP_LIGHT;
    final light =
        isDark ? WAB_TEXTURE_PATINA_LIGHT_DARK : WAB_TEXTURE_PATINA_LIGHT_LIGHT;
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    for (var i = 0; i < 8; i++) {
      final r =
          math.min(size.width, size.height) * (.12 + rnd.nextDouble() * .20);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        r,
        Paint()
          ..color = (i.isEven ? deep : light)
              .withValues(alpha: .12 + rnd.nextDouble() * .09)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * .5),
      );
    }

    for (var i = 0; i < 22; i++) {
      var p =
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final path = Path()..moveTo(p.dx, p.dy);
      for (var j = 0; j < 3 + rnd.nextInt(3); j++) {
        final nx = (p.dx + (rnd.nextDouble() - .5) * size.width * .16)
            .clamp(0.0, size.width)
            .toDouble();
        final ny = (p.dy + (rnd.nextDouble() - .5) * size.height * .22)
            .clamp(0.0, size.height)
            .toDouble();
        p = Offset(nx, ny);
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = deep.withValues(alpha: .12 + rnd.nextDouble() * .10)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .35 + rnd.nextDouble() * .45,
      );
    }
  }

  @override
  bool shouldRepaint(_PatinaPainter old) =>
      old.isDark != isDark || old.seed != seed;
}
