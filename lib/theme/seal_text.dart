import 'package:flutter/material.dart';

import 'typography.dart';
import 'wab_theme.dart';

/// 印體 — a readable seal-adjacent display treatment built from the bundled
/// WabKai face. The glyph is widened, slightly flattened and reinforced with a
/// carved ink stroke: closer to a legible clerical/seal impression than body kai.
class WabSealText extends StatelessWidget {
  const WabSealText(
    this.text, {
    super.key,
    this.fontSize = 24,
    this.color,
    this.strokeWidth = .76,
    this.widthScale = 1.12,
    this.heightScale = .90,
  });

  final String text;
  final double fontSize;
  final Color? color;
  final double strokeWidth;
  final double widthScale;
  final double heightScale;

  @override
  Widget build(BuildContext context) {
    // Inherit the surrounding component ink first. This is important for
    // negative/白文 surfaces: a WabButton can declare white seal ink and
    // WabSealText follows it in both light and dark themes.
    final inherited = DefaultTextStyle.of(context).style.color;
    final ink = color ?? inherited ?? WabTheme.of(context).textColor;
    final effectiveSize = fontSize < 24 ? 24.0 : fontSize;
    final base = TextStyle(
      fontFamily: kWabDisplayFamily,
      fontFamilyFallback: kWabKaiFallback,
      fontSize: effectiveSize,
      fontWeight: FontWeight.w500,
      height: .92,
      letterSpacing: -.05,
    );

    return Transform.scale(
      scaleX: widthScale,
      scaleY: heightScale,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: base.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..strokeJoin = StrokeJoin.round
                ..color = ink,
            ),
          ),
          Text(text,
              textAlign: TextAlign.center, style: base.copyWith(color: ink)),
        ],
      ),
    );
  }
}
