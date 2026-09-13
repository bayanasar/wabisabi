import 'package:flutter/material.dart';

import '../materials/paper_lift.dart';
import '../materials/surface.dart';
import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import 'button.dart';
import '../theme/type_scale.dart';

/// Collection/content card: frameless paper lifted by an irregular contact
/// shadow. Hierarchy comes from paper depth rather than a dashboard border.
class WabCollectionCard extends StatelessWidget {
  const WabCollectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonLabel,
    this.onPressed,
    this.highlighted = false,
  });

  final Widget icon;
  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onPressed;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return WabPaperLift(
        seed: highlighted ? 67 : 31,
        child: WabSurface(
          kind: WabSurfaceKind.paper,
          clip: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 38, child: Center(child: icon)),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: wab.textColor,
                    fontSize: WabType.body,
                    fontWeight: FontWeight.w600,
                    fontFamilyFallback: kWabKaiFallback,
                  ),
                ),
                const SizedBox(height: 6),
                Divider(
                  color: wab.lineColor.withValues(alpha: .65),
                  thickness: WAB_RULE_HAIRLINE,
                  height: WAB_RULE_HAIRLINE,
                  indent: 18,
                  endIndent: 18,
                ),
                const SizedBox(height: 6),
                // Flexible so a tight grid cell ellipsizes the description
                // instead of overflowing the card.
                Flexible(
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: wab.mutedColor,
                      fontSize: WabType.gloss,
                      height: 1.35,
                      fontFamilyFallback: kWabKaiFallback,
                    ),
                  ),
                ),
                if (buttonLabel != null) ...[
                  const SizedBox(height: 9),
                  WabButton(
                    kind: highlighted ? WabMaterialKind.wood : WabMaterialKind.zhuwen,
                    onPressed: onPressed,
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                    child: Text(buttonLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
    );
  }
}
