import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import '../tokens/texture.dart';

enum WabPaperTextureKind { paper, mottle }

/// 宣紙紙紋 — pulp clouds, tiny inclusions and broad shallow wave folds.
///
/// The texture intentionally avoids scratch-like random lines. Old xuan reads
/// through low-frequency waviness and uneven pulp density rather than noise.
class WabPaperTexture extends StatelessWidget {
  const WabPaperTexture({
    super.key,
    this.isDark,
    this.child,
    this.kind = WabPaperTextureKind.paper,
    this.strength = 1,
  });

  final bool? isDark;
  final Widget? child;
  final WabPaperTextureKind kind;
  final double strength;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _PaperTexturePainter(
          isDark: isDark ?? WabTheme.of(context).isDark,
          kind: kind,
          strength: strength,
        ),
        child: child,
      );
}

class _PaperTexturePainter extends CustomPainter {
  const _PaperTexturePainter({
    required this.isDark,
    required this.kind,
    required this.strength,
  });

  final bool isDark;
  final WabPaperTextureKind kind;
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rnd = math.Random(WAB_PAPER_TEXTURE_SEED + kind.index * 97);
    final area10k = size.width * size.height / 10000;
    final strong = kind == WabPaperTextureKind.mottle;
    final deep =
        isDark ? WAB_TEXTURE_PAPER_PULP_DARK : WAB_TEXTURE_PAPER_PULP_LIGHT;
    final age =
        isDark ? WAB_TEXTURE_PAPER_AGE_DARK : WAB_TEXTURE_PAPER_AGE_LIGHT;
    final pale = isDark
        ? WAB_TEXTURE_PAPER_HIGHLIGHT_DARK
        : WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT;

    final clouds =
        (area10k * (strong ? 1.45 : .62)).round().clamp(3, strong ? 20 : 11);
    for (var i = 0; i < clouds; i++) {
      final rx = size.width * (.07 + rnd.nextDouble() * (strong ? .28 : .20));
      final ry = size.height * (.06 + rnd.nextDouble() * (strong ? .25 : .17));
      final tone = i % 3 == 0 ? age : (i.isEven ? deep : pale);
      final opacity =
          ((strong ? .075 : .040) + rnd.nextDouble() * (strong ? .085 : .050)) *
              strength;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
              rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
          width: math.max(16, rx * 2),
          height: math.max(12, ry * 2),
        ),
        Paint()
          ..color = tone.withValues(alpha: opacity.clamp(0, .26))
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, math.max(5, rx * .44)),
      );
    }

    final inclusions = (area10k * (strong ? 10 : 6)).round().clamp(6, 130);
    for (var i = 0; i < inclusions; i++) {
      final c =
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final w = .4 + rnd.nextDouble() * 2.0;
      final h = .2 + rnd.nextDouble() * .8;
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate((rnd.nextDouble() - .5) * 1.2);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: w, height: h),
        Paint()
          ..color = deep.withValues(
              alpha: (.035 + rnd.nextDouble() * .055) * strength),
      );
      canvas.restore();
    }

    final crease =
        isDark ? WAB_TEXTURE_PAPER_CREASE_DARK : WAB_TEXTURE_PAPER_CREASE_LIGHT;
    final highlight = isDark
        ? WAB_TEXTURE_PAPER_HIGHLIGHT_DARK
        : WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT;
    final waveCount =
        (size.height / (strong ? 105 : 145)).round().clamp(1, strong ? 7 : 5);
    for (var i = 0; i < waveCount; i++) {
      final y = size.height * ((i + .6) / (waveCount + .2)) +
          (rnd.nextDouble() - .5) * 14;
      final amp = 1.8 + rnd.nextDouble() * (strong ? 3.0 : 2.1);
      final wavelength = 72.0 + rnd.nextDouble() * 110;
      final phase = rnd.nextDouble() * math.pi * 2;
      final path = Path();
      for (var x = -8.0; x <= size.width + 8; x += 12) {
        final yy = y + math.sin((x / wavelength) * math.pi * 2 + phase) * amp;
        if (x <= -8) {
          path.moveTo(x, yy);
        } else {
          path.lineTo(x, yy);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = crease.withValues(alpha: (isDark ? .030 : .040) * strength)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strong ? 2.2 : 1.8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.4),
      );
      canvas.save();
      canvas.translate(0, -1.3);
      canvas.drawPath(
        path,
        Paint()
          ..color =
              highlight.withValues(alpha: (isDark ? .030 : .095) * strength)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_PaperTexturePainter old) =>
      old.isDark != isDark || old.kind != kind || old.strength != strength;
}
