import 'package:flutter/material.dart';

import '../theme/lift.dart';
import '../theme/wab_theme.dart';
import 'surface.dart';

/// 影 — lifts [child] off the page: ink cast to the lower right by day, the
/// same shape in lamplight by night.
///
/// Wrap anything. [strength] scales how dark (or bright) the lift is, [reach]
/// how far it falls and how soft it is. The lift paints outside the child
/// without taking layout room, so leave space to its lower right.
///
/// The kit's materials cast differently: [WabLift.wood] is dense — paper's
/// reach, darker; [WabLift.jade] lets light through — further reach, fainter.
class WabLift extends StatelessWidget {
  const WabLift({
    super.key,
    required this.child,
    this.strength = 1,
    this.reach = 1,
    this.borderRadius = BorderRadius.zero,
    this.isDark,
  });

  /// Wood is dense: paper's reach, darker.
  const WabLift.wood({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.isDark,
  })  : strength = 1.5,
        reach = 1;

  /// Jade lets light through: further reach, fainter.
  const WabLift.jade({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.isDark,
  })  : strength = .8,
        reach = 1.6;

  /// The lift a surface of [kind] casts.
  factory WabLift.forSurface(
    WabSurfaceKind kind, {
    Key? key,
    required Widget child,
    BorderRadius borderRadius = BorderRadius.zero,
    bool? isDark,
  }) =>
      switch (kind) {
        WabSurfaceKind.woodGrain => WabLift.wood(
            key: key, borderRadius: borderRadius, isDark: isDark, child: child),
        WabSurfaceKind.jadeSheen => WabLift.jade(
            key: key, borderRadius: borderRadius, isDark: isDark, child: child),
        _ => WabLift(
            key: key, borderRadius: borderRadius, isDark: isDark, child: child),
      };

  final Widget child;
  final double strength;
  final double reach;

  /// The child's corners, so the lift follows its shape.
  final BorderRadius borderRadius;

  /// Overrides the theme's brightness.
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? WabTheme.of(context).isDark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: wabLift(dark: dark, strength: strength, reach: reach),
      ),
      child: child,
    );
  }
}
