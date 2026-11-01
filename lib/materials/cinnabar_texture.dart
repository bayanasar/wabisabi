import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 朱砂漆面 — muted cinnabar with fine mineral/crackle traces.
class WabCinnabarTexture extends StatelessWidget {
  const WabCinnabarTexture(
      {super.key, this.isDark, this.child, this.seed = 337});

  final bool? isDark;
  final Widget? child;
  final int seed;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _CinnabarPainter(
            isDark: isDark ?? WabTheme.of(context).isDark, seed: seed),
        child: child,
      );
}

class _CinnabarPainter extends CustomPainter {
  const _CinnabarPainter({required this.isDark, required this.seed});
  final bool isDark;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final base = isDark
        ? WAB_TEXTURE_CINNABAR_BASE_DARK
        : WAB_TEXTURE_CINNABAR_BASE_LIGHT;
    final deep = isDark
        ? WAB_TEXTURE_CINNABAR_DEEP_DARK
        : WAB_TEXTURE_CINNABAR_DEEP_LIGHT;
    final light = isDark
        ? WAB_TEXTURE_CINNABAR_LIGHT_DARK
        : WAB_TEXTURE_CINNABAR_LIGHT_LIGHT;
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    for (var i = 0; i < 7; i++) {
      final r =
          math.min(size.width, size.height) * (.12 + rnd.nextDouble() * .18);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        r,
        Paint()
          ..color = (i.isEven ? deep : light)
              .withValues(alpha: .10 + rnd.nextDouble() * .08)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * .42),
      );
    }
    for (var i = 0; i < 18; i++) {
      final p0 =
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final p1 = Offset(
        (p0.dx + (rnd.nextDouble() - .5) * size.width * .18)
            .clamp(0.0, size.width)
            .toDouble(),
        (p0.dy + (rnd.nextDouble() - .5) * size.height * .26)
            .clamp(0.0, size.height)
            .toDouble(),
      );
      final p2 = Offset(
        (p1.dx + (rnd.nextDouble() - .5) * size.width * .13)
            .clamp(0.0, size.width)
            .toDouble(),
        (p1.dy + (rnd.nextDouble() - .5) * size.height * .20)
            .clamp(0.0, size.height)
            .toDouble(),
      );
      canvas.drawPath(
        Path()
          ..moveTo(p0.dx, p0.dy)
          ..lineTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy),
        Paint()
          ..color = light.withValues(alpha: .16)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .45,
      );
    }
  }

  @override
  bool shouldRepaint(_CinnabarPainter old) =>
      old.isDark != isDark || old.seed != seed;
}
