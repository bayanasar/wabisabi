import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../tokens/texture.dart';

/// 拓片 — charcoal rubbing with stone bloom, pinholes and sparse paper fibres.
class WabRubbingTexture extends StatelessWidget {
  const WabRubbingTexture({super.key, this.child, this.seed = 613});
  final Widget? child;
  final int seed;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _RubbingPainter(seed),
        child: child,
      );
}

class _RubbingPainter extends CustomPainter {
  const _RubbingPainter(this.seed);
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rnd = math.Random(seed);
    canvas.drawRect(
        Offset.zero & size, Paint()..color = WAB_TEXTURE_RUBBING_BASE);

    for (var i = 0; i < 12; i++) {
      final rx = math.max(8.0, size.width * (.07 + rnd.nextDouble() * .18));
      final ry = math.max(7.0, size.height * (.08 + rnd.nextDouble() * .20));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
              rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
          width: rx * 2,
          height: ry * 2,
        ),
        Paint()
          ..color =
              (i % 3 == 0 ? WAB_TEXTURE_RUBBING_DUST : WAB_TEXTURE_RUBBING_DEEP)
                  .withValues(alpha: i % 3 == 0 ? .14 : .30)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, math.max(3, rx * .42)),
      );
    }

    final specks = (size.width * size.height / 72).clamp(32, 780).round();
    for (var i = 0; i < specks; i++) {
      final r = .22 + rnd.nextDouble() * (i % 19 == 0 ? 1.45 : .65);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        r,
        Paint()
          ..color = WAB_TEXTURE_RUBBING_DUST.withValues(
              alpha: .055 + rnd.nextDouble() * .11),
      );
    }

    // About a quarter of the former fibre count: enough to read as rubbed paper,
    // not enough to turn the surface into a scratch texture.
    final fibres = (size.width * size.height / 2880).clamp(4, 58).round();
    for (var i = 0; i < fibres; i++) {
      final p =
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final a = rnd.nextDouble() * math.pi * 2;
      final len = 4.0 + rnd.nextDouble() * 15;
      final end = p + Offset(math.cos(a) * len, math.sin(a) * len);
      final ctrl = Offset.lerp(p, end, .5)! +
          Offset((rnd.nextDouble() - .5) * 3, (rnd.nextDouble() - .5) * 3);
      canvas.drawPath(
        Path()
          ..moveTo(p.dx, p.dy)
          ..quadraticBezierTo(ctrl.dx, ctrl.dy, end.dx, end.dy),
        Paint()
          ..color = WAB_TEXTURE_RUBBING_FIBER.withValues(
              alpha: .045 + rnd.nextDouble() * .065)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .30 + rnd.nextDouble() * .45,
      );
    }
  }

  @override
  bool shouldRepaint(_RubbingPainter old) => old.seed != seed;
}
