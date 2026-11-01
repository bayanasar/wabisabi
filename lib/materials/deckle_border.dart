import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/material.dart';

/// 毛邊 deckle edge — an [OutlinedBorder] whose four edges wobble with a
/// fixed-seed multi-frequency sine noise, so the irregular edge is stable
/// across rebuilds. No radius, no shadow — the paper state of a surface.
///
/// Pass [side] built from `WabTheme.of(context).lineColor`. A ShapeBorder is
/// constructed outside the widget tree and has no context of its own, so the
/// default falls back to the legacy static — the one place in the kit that
/// still must.
class WabDeckleBorder extends OutlinedBorder {
  WabDeckleBorder({
    BorderSide? side,
    this.roughness = WAB_DECKLE_ROUGHNESS,
    this.horizontalRoughness = WAB_DECKLE_ROUGHNESS_H,
    this.seed = WAB_DECKLE_SEED,
    this.radius = 0,
  }) : super(
          side: side ??
              BorderSide(
                color: WabTheme.lineColor,
                width: WAB_DECKLE_SIDE_WIDTH,
              ),
        );

  /// Wobble amplitude in px on the vertical (left/right) edges — the wavy pair.
  final double roughness;

  /// Wobble amplitude in px on the horizontal (top/bottom) edges — much calmer.
  final double horizontalRoughness;

  /// Noise seed — different seeds give different (stable) edges.
  final int seed;

  /// Corner radius in px (印章用：很小的圓角). 0 = square corners.
  final double radius;

  double _noise(int edge, double t) {
    final s = seed * 0.37 + edge * 17.0;
    return math.sin(t * WAB_DECKLE_FREQ1 + s) * 0.55 +
        math.sin(t * WAB_DECKLE_FREQ2 + s * 1.7) * 0.30 +
        math.sin(t * WAB_DECKLE_FREQ3 + s * 2.3) * 0.15;
  }

  Path _decklePath(Rect rect) {
    final r = rect.deflate(side.width / 2);
    const steps = 36;
    final path = Path();
    final rad = radius.clamp(0.0, r.shortestSide / 2);
    void edge(Offset Function(double) pt, int idx) {
      // Edges 0/2 are top/bottom (calm), 1/3 are left/right (wavy).
      final amp = (idx == 0 || idx == 2) ? horizontalRoughness : roughness;
      // With a corner radius, each edge stops short of the corners and the
      // corners are bridged with quadratic arcs.
      final span =
          rad > 0 ? rad / ((idx == 0 || idx == 2) ? r.width : r.height) : 0.0;
      for (var i = 0; i <= steps; i++) {
        final t = span + (i / steps) * (1 - span * 2);
        final base = pt(t);
        final n = _noise(idx, t) * amp;
        final off = switch (idx) {
          0 => Offset(0, -n),
          1 => Offset(n, 0),
          2 => Offset(0, n),
          _ => Offset(-n, 0),
        };
        final p = base + off;
        if (i == 0 && idx == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      if (rad > 0) {
        // Corner arc to the next edge's start.
        final corners = [r.topRight, r.bottomRight, r.bottomLeft, r.topLeft];
        final c = corners[idx];
        final next = (idx + 1) % 4;
        final nextPt = switch (next) {
          1 => Offset(r.right, r.top + rad),
          2 => Offset(r.right - rad, r.bottom),
          3 => Offset(r.left, r.bottom - rad),
          _ => Offset(r.left + rad, r.top),
        };
        path.quadraticBezierTo(c.dx, c.dy, nextPt.dx, nextPt.dy);
      }
    }

    edge((t) => Offset(r.left + r.width * t, r.top), 0);
    edge((t) => Offset(r.right, r.top + r.height * t), 1);
    edge((t) => Offset(r.right - r.width * t, r.bottom), 2);
    edge((t) => Offset(r.left, r.bottom - r.height * t), 3);
    path.close();
    return path;
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) => WabDeckleBorder(
      side: side ?? this.side,
      roughness: roughness,
      horizontalRoughness: horizontalRoughness,
      seed: seed,
      radius: radius);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _decklePath(rect.deflate(side.width));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _decklePath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    final p = side.toPaint()..strokeJoin = StrokeJoin.round;
    canvas.drawPath(_decklePath(rect), p);
  }

  @override
  ShapeBorder scale(double t) => this;
}

/// Old name, kept so consumers can migrate without a broken build.
@Deprecated('Renamed to WabDeckleBorder. Every type the barrel exports carries '
    'the Wab prefix, because the barrel lands in the consumer namespace. This '
    'alias goes at the next major version.')
typedef DeckleBorder = WabDeckleBorder;
