import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 宣紙纖維 — sparse plant fibres and compressed pulp knots.
class WabFiberTexture extends StatelessWidget {
  const WabFiberTexture({
    super.key,
    this.isDark,
    this.child,
    this.seed = 731,
    this.strength = 1,
  });

  final bool? isDark;
  final Widget? child;
  final int seed;
  final double strength;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _FiberTexturePainter(
          isDark: isDark ?? WabTheme.of(context).isDark,
          seed: seed,
          strength: strength,
        ),
        child: child,
      );
}

class _FiberTexturePainter extends CustomPainter {
  const _FiberTexturePainter(
      {required this.isDark, required this.seed, required this.strength});
  final bool isDark;
  final int seed;
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rnd = math.Random(seed);
    final count = (size.width * size.height / 3400).clamp(7, 88).round();
    final tint = isDark ? WAB_TEXTURE_FIBER_DARK : WAB_TEXTURE_FIBER_LIGHT;
    final pale = isDark
        ? WAB_TEXTURE_PAPER_HIGHLIGHT_DARK
        : WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT;

    for (var i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final angle = rnd.nextDouble() * math.pi * 2;
      final long = i % 11 == 0;
      final len = (long ? 12.0 : 4.0) + rnd.nextDouble() * (long ? 24 : 14);
      final dx = math.cos(angle) * len;
      final dy = math.sin(angle) * len;
      final bend = (rnd.nextDouble() - .5) * 5.5;
      final path = Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(
          x + dx * .48 - math.sin(angle) * bend,
          y + dy * .48 + math.cos(angle) * bend,
          x + dx,
          y + dy,
        );
      final opacity = (.035 + rnd.nextDouble() * .065) * strength;
      canvas.drawPath(
        path,
        Paint()
          ..color = (i % 7 == 0 ? pale : tint)
              .withValues(alpha: opacity.clamp(0, .16))
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = .28 + rnd.nextDouble() * .50,
      );
    }

    final knots = math.max(1, (count / 10).round());
    for (var i = 0; i < knots; i++) {
      final c =
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      canvas.drawOval(
        Rect.fromCenter(
            center: c,
            width: 1.5 + rnd.nextDouble() * 4,
            height: .5 + rnd.nextDouble() * 1.4),
        Paint()
          ..color = tint.withValues(
              alpha: (.035 + rnd.nextDouble() * .045) * strength),
      );
    }
  }

  @override
  bool shouldRepaint(_FiberTexturePainter old) =>
      old.isDark != isDark || old.seed != seed || old.strength != strength;
}
