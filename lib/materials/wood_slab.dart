import 'package:flutter/material.dart';

import '../theme/lift.dart';
import '../theme/wab_theme.dart';
import '../tokens/texture.dart';
import 'wood_grain.dart';

/// 木板 — a rigid wood material form built on top of [WabWoodGrain].
///
/// This is intentionally different from a plain wood-grain surface: a slab has
/// a small physical edge, directional bevel light and a right/down contact
/// shadow. Use the flat [WabWoodGrain] painter when only surface texture is
/// desired.
class WabWoodSlab extends StatelessWidget {
  const WabWoodSlab({
    super.key,
    required this.child,
    this.isDark,
    this.seed = 201,
    this.lifted = true,
    this.showKnot = true,
    this.radius = 3.0,
  });

  final Widget child;
  final bool? isDark;
  final int seed;
  final bool lifted;
  final bool showKnot;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? WabTheme.of(context).isDark;
    final shape = BorderRadius.circular(radius);

    return Container(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: lifted
            ? [
                // Wood is dense: its lift is darker than paper's.
                ...wabLift(dark: dark, strength: 1.5, reach: .5),
              ]
            : const <BoxShadow>[],
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: CustomPaint(
          painter: WabWoodGrain(
            isDark: dark,
            seed: seed.toDouble(),
            showKnot: showKnot,
          ),
          foregroundPainter: _WoodSlabEdgePainter(dark: dark),
          child: child,
        ),
      ),
    );
  }
}

class _WoodSlabEdgePainter extends CustomPainter {
  const _WoodSlabEdgePainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final light =
        WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT.withValues(alpha: dark ? .08 : .24);
    final darkEdge = WAB_TEXTURE_INK.withValues(alpha: dark ? .26 : .18);

    final highlight = Paint()
      ..color = light
      ..strokeWidth = .85
      ..style = PaintingStyle.stroke;
    final shade = Paint()
      ..color = darkEdge
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // The top/left catch light while the lower/right edges reveal thickness.
    canvas.drawLine(const Offset(.8, .8), Offset(size.width - 1.0, .8), highlight);
    canvas.drawLine(const Offset(.8, .8), Offset(.8, size.height - 1.0), highlight);
    canvas.drawLine(
      Offset(1.0, size.height - .8),
      Offset(size.width - .8, size.height - .8),
      shade,
    );
    canvas.drawLine(
      Offset(size.width - .8, 1.0),
      Offset(size.width - .8, size.height - .8),
      shade,
    );
  }

  @override
  bool shouldRepaint(_WoodSlabEdgePainter old) => old.dark != dark;
}
