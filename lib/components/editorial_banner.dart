import 'package:flutter/material.dart';

import '../theme/typography.dart';
import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import '../theme/type_scale.dart';

/// Editorial masthead matching the kit's document-source language: brand at
/// left, title/subtitle immediately after it, quiet motto/actions at right.
///
/// The row sheds its quieter parts as it narrows rather than overflowing: the
/// motto goes first, then the kit label and its rule. What is left — brand,
/// title, actions — is what a masthead cannot do without.
///
/// [height] is a floor, not a ceiling: a viewer who has turned text size up
/// gets a taller masthead rather than a clipped one.
class WabEditorialBanner extends StatelessWidget {
  const WabEditorialBanner({
    super.key,
    required this.brand,
    required this.kitLabel,
    required this.title,
    required this.subtitle,
    this.motto,
    this.seal,
    this.trailing = const [],
    this.height = 92,
  });

  final String brand;
  final String kitLabel;
  final String title;
  final String subtitle;
  final String? motto;
  final Widget? seal;
  final List<Widget> trailing;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 13, 24, 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wab = WabTheme.of(context);
            // The thresholds are widths at a text scale of 1; a viewer who has
            // turned text size up needs proportionally more room for the same
            // parts.
            final textScale =
                MediaQuery.textScalerOf(context).scale(WabType.body) / WabType.body;
            final room = constraints.maxWidth / textScale;
            final showMotto = motto != null && room >= _mottoWidth;
            final showKitLabel = room >= _kitLabelWidth;
            final showSubtitle = room >= _subtitleWidth;
            return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              brand,
              style: const TextStyle(
                fontFamily: kWabDisplayFamily,
                fontFamilyFallback: kWabDisplayFallback,
                fontSize: WabType.brand,
                fontWeight: FontWeight.w500,
                letterSpacing: 7,
                height: 1,
              ).copyWith(color: wab.textColor),
            ),
            if (showKitLabel) ...[
              const SizedBox(width: 16),
              Container(
                width: WAB_RULE_HAIRLINE,
                height: 54,
                color: wab.lineColor,
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: 84,
                child: Text(
                  kitLabel,
                  style: const TextStyle(
                    fontFamily: kWabMonoFamily,
                    fontSize: WabType.gloss,
                    letterSpacing: 2.6,
                    height: 1.45,
                  ).copyWith(color: wab.mutedColor),
                ),
              ),
            ],
            const SizedBox(width: 22),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: kWabDisplayFamily,
                            fontFamilyFallback: kWabDisplayFallback,
                            fontSize: WabType.label,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2.5,
                          ).copyWith(color: wab.textColor),
                        ),
                      ),
                      if (seal != null) ...[const SizedBox(width: 9), seal!],
                    ],
                  ),
                  if (showSubtitle) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: kWabMonoFamily,
                        fontSize: WabType.gloss,
                        letterSpacing: 3.1,
                      ).copyWith(color: wab.mutedColor),
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            if (showMotto)
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  motto!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: kWabKaiFamily,
                    fontFamilyFallback: kWabKaiFallback,
                    fontSize: WabType.gloss,
                    letterSpacing: 1.6,
                  ).copyWith(color: wab.mutedColor),
                ),
              ),
            ...trailing,
          ],
            );
          },
        ),
      ),
    );
  }
}

/// Below this the motto is dropped.
const double _mottoWidth = 1000;

/// Below this the kit label and its rule are dropped too.
const double _kitLabelWidth = 600;

/// Below this only the title survives; the subtitle would be squeezed to a
/// column of single characters.
const double _subtitleWidth = 520;
