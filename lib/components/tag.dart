import 'package:flutter/material.dart';

import '../materials/deckle_surface.dart';
import '../materials/paper_texture.dart';
import '../theme/typography.dart';
import '../theme/wab_theme.dart';
import '../tokens/texture.dart';
import '../theme/type_scale.dart';

/// 題簽 — narrow hanging paper label with barely perceptible irregular edges.
class WabVerticalTag extends StatelessWidget {
  const WabVerticalTag({
    super.key,
    required this.text,
    this.width = 28,
    this.height = 66,
    this.roughness = .42,
  });

  final String text;
  final double width;
  final double height;
  final double roughness;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: WabDeckleSurface(
        fill: wab.isDark
            ? WAB_TEXTURE_PAPER_BASE_DARK
            : WAB_TEXTURE_PAPER_BASE_LIGHT,
        texture: WabPaperTexture(strength: .48),
        roughness: roughness,
        child: Center(
          child: Text(
            text.split('').join('\n'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: wab.textColor,
              fontFamily: kWabKaiFamily,
              fontFamilyFallback: kWabKaiFallback,
              fontSize: WabType.gloss,
              height: 1.15,
            ),
          ),
        ),
      ),
    );
  }
}
