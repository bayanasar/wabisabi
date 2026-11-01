import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/wab_colors.dart';
import '../theme/wab_theme.dart';
import '../tokens/texture.dart';

/// 墨暈 — layered wet-ink clouds with soft capillary spread.
///
/// No scratch or contour lines are drawn; the material reads through density,
/// overlap and blur alone.
class WabInkWash extends CustomPainter {
  /// Resolves the theme once, at construction, so [shouldRepaint] can compare
  /// what the painter will actually draw with. Reading the theme inside
  /// [paint] leaves a stale wash behind when light/dark flips.
  /// Pass [colors] — `WabTheme.of(context)` — so the wash follows the ambient
  /// theme. A painter has no context of its own; without it the palette falls
  /// back to the legacy statics.
  factory WabInkWash({WabColors? colors, bool? isDark, int seed = 943}) {
    final dark = isDark ?? colors?.isDark ?? WabTheme.isDark;
    final ink = dark
        ? (colors?.mutedLight ?? WabTheme.mutedLight)
        : (colors?.textColor ?? WabTheme.textColor);
    return WabInkWash._(dark, ink, seed);
  }

  const WabInkWash._(this.isDark, this.ink, this.seed);

  final bool isDark;

  /// The wash colour, resolved from the theme at construction.
  final Color ink;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final dark = isDark;
    final rnd = math.Random(seed);

    for (var i = 0; i < 9; i++) {
      final rx = size.width * (.10 + rnd.nextDouble() * .20);
      final ry = size.height * (.13 + rnd.nextDouble() * .25);
      final center =
          Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final op = (dark ? .050 : .065) + rnd.nextDouble() * (dark ? .05 : .085);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
        Paint()
          ..color = ink.withValues(alpha: op)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, math.min(rx, ry) * .46),
      );
    }

    // A few lighter bloom centers create water-loaded edges without linework.
    for (var i = 0; i < 3; i++) {
      final r =
          math.min(size.width, size.height) * (.08 + rnd.nextDouble() * .10);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        r,
        Paint()
          ..color = (dark ? WAB_TEXTURE_INK : WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT)
              .withValues(alpha: dark ? .035 : .10)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * .65),
      );
    }
  }

  @override
  bool shouldRepaint(WabInkWash old) =>
      old.isDark != isDark || old.ink != ink || old.seed != seed;
}
