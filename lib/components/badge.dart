import 'package:flutter/material.dart';

import '../materials/deckle_border.dart';
import '../theme/wab_colors.dart';
import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import '../theme/type_scale.dart';

enum WabBadgeKind {
  neutral,
  primary,
  success,
  warning,
  error,
  progress,
  done,
}

/// Small semantic status label. Edges share the same restrained deckle amount
/// as seals and archival tags, so none reads as either plastic-perfect or torn.
class WabStatusBadge extends StatelessWidget {
  const WabStatusBadge(
    this.label, {
    super.key,
    this.kind = WabBadgeKind.neutral,
  });

  final String label;
  final WabBadgeKind kind;

  Color _bg(WabColors wab) => switch (kind) {
        WabBadgeKind.neutral => wab.secondaryColor.withValues(alpha: .72),
        WabBadgeKind.primary || WabBadgeKind.progress => wab.progressColor,
        WabBadgeKind.success || WabBadgeKind.done => wab.onColor,
        WabBadgeKind.warning => wab.accentColor.withValues(alpha: .82),
        WabBadgeKind.error => wab.sealColor,
      };

  bool get _darkText =>
      kind == WabBadgeKind.neutral || kind == WabBadgeKind.warning;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    final side = kind == WabBadgeKind.neutral
        ? BorderSide(color: wab.lineColor, width: WAB_RULE_HAIRLINE)
        : BorderSide.none;
    final shape = WabDeckleBorder(
      roughness: .42,
      horizontalRoughness: .42,
      seed: 120 + kind.index * 17,
      radius: 10,
      side: side,
    );
    return DecoratedBox(
      decoration: ShapeDecoration(color: _bg(wab), shape: shape),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Text(
          label,
          style: TextStyle(
            color: _darkText ? wab.textColor : wab.paperWhite,
            fontSize: WabType.gloss,
            fontWeight: FontWeight.w600,
            height: 1,
            fontFamilyFallback: kWabKaiFallback,
          ),
        ),
      ),
    );
  }
}

class WabStarRating extends StatelessWidget {
  const WabStarRating({
    super.key,
    required this.rating,
    this.max = 5,
    this.size = 16,
  });

  final int rating;
  final int max;
  final double size;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (i) {
        final filled = i < rating;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          size: size,
          color: filled ? wab.accentColor : wab.secondaryColor,
        );
      }),
    );
  }
}
