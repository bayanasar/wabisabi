import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 靛布布紋 — dyed warp/weft with small-scale over-under relief.
///
/// Irregularity comes from yarn spacing and dye density, never stray white
/// scratches. The pitch is dense enough to read as cloth at swatch scale but
/// loose enough that individual warp/weft rhythm remains visible.
class WabClothWeave extends CustomPainter {
  const WabClothWeave({this.isDark = false, this.seed = 509});

  final bool isDark;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rnd = math.Random(seed);
    final base =
        isDark ? WAB_TEXTURE_CLOTH_BASE_DARK : WAB_TEXTURE_CLOTH_BASE_LIGHT;
    final deep =
        isDark ? WAB_TEXTURE_CLOTH_DEEP_DARK : WAB_TEXTURE_CLOTH_DEEP_LIGHT;
    final thread =
        isDark ? WAB_TEXTURE_CLOTH_THREAD_DARK : WAB_TEXTURE_CLOTH_THREAD_LIGHT;
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    // Quiet indigo dye variation beneath the weave.
    for (var i = 0; i < 5; i++) {
      final r =
          math.min(size.width, size.height) * (.16 + rnd.nextDouble() * .22);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        r,
        Paint()
          ..color = deep.withValues(alpha: .075 + rnd.nextDouble() * .045)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, math.max(4, r * .8)),
      );
    }

    // Slightly looser than the previous 1.85 pitch: still textile-dense, but
    // no longer visually collapses into a solid micro-grid.
    const pitch = 2.55;
    var row = 0;
    for (var y = -pitch; y <= size.height + pitch; y += pitch, row++) {
      var col = 0;
      for (var x = -pitch; x <= size.width + pitch; x += pitch, col++) {
        final over = (row + col).isEven;
        final jy = (rnd.nextDouble() - .5) * .18;
        final jx = (rnd.nextDouble() - .5) * .16;

        canvas.drawLine(
          Offset(x + jx, y + jy),
          Offset(x + pitch * .94 + jx, y + jy),
          Paint()
            ..color = (over ? thread : deep).withValues(alpha: over ? .27 : .24)
            ..strokeWidth = over ? .58 : .44
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawLine(
          Offset(x + pitch * .47 + jx, y - pitch * .47 + jy),
          Offset(x + pitch * .47 + jx, y + pitch * .47 + jy),
          Paint()
            ..color = (over ? deep : thread).withValues(alpha: over ? .22 : .25)
            ..strokeWidth = over ? .42 : .55
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(WabClothWeave old) =>
      old.isDark != isDark || old.seed != seed;
}

class WabClothTexture extends StatelessWidget {
  const WabClothTexture({super.key, this.isDark, this.child, this.seed = 509});
  final bool? isDark;
  final Widget? child;
  final int seed;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: WabClothWeave(
            isDark: isDark ?? WabTheme.of(context).isDark, seed: seed),
        child: child,
      );
}
