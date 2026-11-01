import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import 'deckle_border.dart';

/// 毛邊面 deckle surface — a fill plus an optional texture (paper grain,
/// cloth weave, …), clipped to a [WabDeckleBorder] shape, with the 淡墨
/// outline stroked on top of the clipped fill.
///
/// In the dark theme, pair `fill: WabTheme.paperWhite` (夜紙) with
/// `texture: const WabPaperTexture()` for the 拓片 look — stone-rubbing
/// black paper, light ink text.
///
/// The surface sizes itself to [child]; fill and texture follow it.
class WabDeckleSurface extends StatelessWidget {
  const WabDeckleSurface({
    super.key,
    required this.child,
    this.fill,
    this.texture,
    this.seed = WAB_DECKLE_SEED,
    this.roughness = WAB_DECKLE_ROUGHNESS,
    this.horizontalRoughness,
    this.sideColor,
  });

  /// Content; determines the surface size.
  final Widget child;

  /// Flat fill under the texture. Null when the texture paints its own
  /// base (e.g. `WabClothTexture`).
  final Color? fill;

  /// Texture layer painted over [fill] and under [child]
  /// (e.g. `WabPaperTexture`, `WabClothTexture`).
  final Widget? texture;

  final int seed;
  final double roughness;

  /// Vertical-edge wobble override; defaults to the token value.
  final double? horizontalRoughness;

  /// Outline color; defaults to the theme 淡墨 hairline.
  final Color? sideColor;

  @override
  Widget build(BuildContext context) {
    final shape = WabDeckleBorder(
      seed: seed,
      roughness: roughness,
      horizontalRoughness: horizontalRoughness ?? WAB_DECKLE_ROUGHNESS_H,
      side: BorderSide(
        color: sideColor ?? WabTheme.of(context).lineColor,
        width: WAB_DECKLE_SIDE_WIDTH,
      ),
    );
    return Stack(
      children: [
        ClipPath.shape(
          shape: shape,
          child: Stack(
            children: [
              if (fill != null)
                Positioned.fill(child: ColoredBox(color: fill!)),
              if (texture != null)
                Positioned.fill(child: IgnorePointer(child: texture!)),
              child,
            ],
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _ShapeOutlinePainter(shape)),
          ),
        ),
      ],
    );
  }
}

/// Paints only the outline of a shape (strokes the deckle edge over the
/// clipped fill).
class _ShapeOutlinePainter extends CustomPainter {
  const _ShapeOutlinePainter(this.shape);

  final OutlinedBorder shape;

  @override
  void paint(Canvas canvas, Size size) {
    shape.paint(canvas, Offset.zero & size);
  }

  @override
  bool shouldRepaint(_ShapeOutlinePainter old) => old.shape != shape;
}
