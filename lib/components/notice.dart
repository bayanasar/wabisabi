import 'package:flutter/material.dart';

import '../materials/surface.dart';
import '../theme/typography.dart';
import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import '../theme/type_scale.dart';

/// A quiet notice/toast specimen using paper + ink rather than a filled modern
/// alert card.
class WabNotice extends StatelessWidget {
  const WabNotice({
    super.key,
    required this.title,
    this.message,
    this.dotColor,
    this.onDismiss,
  });

  final String title;
  final String? message;
  final Color? dotColor;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: wab.lineColor, width: WAB_RULE_HAIRLINE),
      ),
      child: WabSurface(
        kind: WabSurfaceKind.paper,
        clip: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6, right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor ?? wab.sealColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: wab.textColor,
                        fontFamily: kWabKaiFamily,
                        fontFamilyFallback: kWabKaiFallback,
                        fontSize: WabType.body,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        message!,
                        style: TextStyle(
                          color: wab.mutedColor,
                          fontFamily: kWabKaiFamily,
                          fontFamilyFallback: kWabKaiFallback,
                          fontSize: WabType.gloss,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onDismiss != null)
                GestureDetector(
                  onTap: onDismiss,
                  child: Icon(Icons.close, size: 12, color: wab.mutedColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
