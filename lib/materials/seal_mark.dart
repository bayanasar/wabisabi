import 'package:flutter/material.dart';

import '../theme/seal_text.dart';
import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import 'cinnabar_texture.dart';
import 'deckle_border.dart';

/// Seal marks are cinnabar ink in both 白文 and 朱文 forms.
class WabSealMark extends StatelessWidget {
  const WabSealMark({
    super.key,
    required this.text,
    this.kind = WabSealMarkKind.baiwen,
    this.size = 48,
    this.seed = 5,
  });

  final String text;
  final WabSealMarkKind kind;
  final double size;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final bai = kind == WabSealMarkKind.baiwen;
    final wab = WabTheme.of(context);
    final red = wab.sealColor;
    final shape = WabDeckleBorder(
      roughness: .42,
      horizontalRoughness: .42,
      seed: seed,
      radius: 2.5,
      side: BorderSide(
        color: red,
        width: bai ? 1.0 : WAB_ZHUWEN_RULE_WIDTH,
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        // The glyphs keep their own proportions, so they are centred rather
        // than left at the top-left of the face.
        alignment: Alignment.center,
        children: [
          if (bai)
            Positioned.fill(
              child: ClipPath.shape(
                shape: shape,
                child: WabCinnabarTexture(
                  seed: seed * 17,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          Positioned.fill(
            child: CustomPaint(painter: _SealOutlinePainter(shape)),
          ),
          Padding(
            padding: EdgeInsets.all(size * .085),
            child: FittedBox(
              fit: BoxFit.contain,
              child: WabSealText(
                text,
                fontSize: size * .52,
                color: bai ? wab.paperWhite : red,
                strokeWidth: size * .014,
                widthScale: 1.05,
                heightScale: .96,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum WabSealMarkKind { baiwen, zhuwen }

class _SealOutlinePainter extends CustomPainter {
  const _SealOutlinePainter(this.shape);
  final OutlinedBorder shape;

  @override
  void paint(Canvas canvas, Size size) => shape.paint(canvas, Offset.zero & size);

  @override
  bool shouldRepaint(_SealOutlinePainter old) => old.shape != shape;
}
