import 'package:flutter/material.dart';

import 'lift.dart';

/// 紙翹陰影 — a sheet's lift: a [WabLift] reaching [depth] to the lower right,
/// with that room kept in the layout so the lift is not clipped by a
/// neighbour.
class WabPaperLift extends StatelessWidget {
  const WabPaperLift({
    super.key,
    required this.child,
    this.depth = 8,
    @Deprecated('The lift no longer varies by seed') this.seed = 31,
  });

  final Widget child;

  /// How far the lift reaches, and the room kept for it right and below.
  final double depth;

  @Deprecated('The lift no longer varies by seed')
  final int seed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(right: depth, bottom: depth),
        child: WabLift(reach: depth / 8, child: child),
      );
}
