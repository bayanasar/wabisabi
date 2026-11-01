import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../tokens/texture.dart';

/// 木紋 — warm timber with layered grain, pores, knot and a restrained top sheen.
class WabWoodGrain extends CustomPainter {
  const WabWoodGrain(
      {this.isDark = false, this.seed = 3.0, this.showKnot = true});

  final bool isDark;
  final double seed;
  final bool showKnot;

  @override
  void paint(Canvas canvas, Size size) {
    final base =
        isDark ? WAB_TEXTURE_WOOD_BASE_DARK : WAB_TEXTURE_WOOD_BASE_LIGHT;
    final deep =
        isDark ? WAB_TEXTURE_WOOD_DEEP_DARK : WAB_TEXTURE_WOOD_DEEP_LIGHT;
    final light =
        isDark ? WAB_TEXTURE_WOOD_LIGHT_DARK : WAB_TEXTURE_WOOD_LIGHT_LIGHT;
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final lines = (size.height / 3.4).ceil();
    for (var i = 0; i < lines; i++) {
      final y0 = i * 3.4 + 1;
      final path = Path()..moveTo(0, y0);
      for (var x = 0.0; x <= size.width + 5; x += 3.5) {
        final wobble = math.sin(x * .026 + i * 1.31 + seed) * 2.2 +
            math.sin(x * .071 + i * .73) * .8 +
            math.sin(x * .15 + i * 2.03) * .28;
        path.lineTo(x, y0 + wobble);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = (i % 4 == 0 ? light : deep)
              .withValues(alpha: i % 4 == 0 ? .13 : .17)
          ..style = PaintingStyle.stroke
          ..strokeWidth = i % 5 == 0 ? .85 : .55,
      );
    }

    final safeWidth = size.width <= 0 ? 1.0 : size.width;
    final safeHeight = size.height <= 0 ? 1.0 : size.height;
    for (var i = 0; i < (safeWidth / 22).ceil(); i++) {
      final x = (i * 37.0 + seed * 11) % safeWidth;
      final y = (i * 19.0 + seed * 7) % safeHeight;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 4.0 + i % 7, height: .7),
        Paint()..color = deep.withValues(alpha: .10),
      );
    }

    if (showKnot && size.width > 70 && size.height > 35) {
      final c = Offset(size.width * .72, size.height * .58);
      for (var r = 3.0; r < math.min(17.0, size.height * .28); r += 3.1) {
        canvas.drawOval(
          Rect.fromCenter(center: c, width: r * 2.7, height: r * 1.5),
          Paint()
            ..color = deep.withValues(alpha: .16)
            ..style = PaintingStyle.stroke
            ..strokeWidth = .75,
        );
      }
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 1.2),
      Paint()..color = light.withValues(alpha: isDark ? .08 : .24),
    );
  }

  @override
  bool shouldRepaint(WabWoodGrain old) =>
      old.isDark != isDark || old.seed != seed || old.showKnot != showKnot;
}
