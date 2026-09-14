import 'package:flutter/material.dart';

import '../materials/paper_lift.dart';
import '../materials/surface.dart';
import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import '../theme/type_scale.dart';

/// Frameless titled paper panel. A subtle irregular contact shadow replaces the
/// outer border; internal hairlines remain available for structure.
class WabPanel extends StatelessWidget {
  const WabPanel({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
    this.expand = false,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets padding;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: wab.textColor,
                  fontSize: WabType.label,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5,
                  fontFamilyFallback: kWabKaiFallback,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 7),
        Divider(
          color: wab.lineColor.withValues(alpha: .68),
          thickness: WAB_RULE_HAIRLINE,
          height: WAB_RULE_HAIRLINE,
        ),
        const SizedBox(height: 10),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium ??
              TextStyle(
                color: wab.textColor,
                fontSize: WabType.body,
                fontFamilyFallback: kWabKaiFallback,
                decoration: TextDecoration.none,
              ),
          child: expand ? Expanded(child: child) : child,
        ),
      ],
    );

    return WabPaperLift(
      child: WabSurface(
        kind: WabSurfaceKind.paper,
        clip: false,
        child: Padding(padding: padding, child: body),
      ),
    );
  }
}
