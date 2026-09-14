import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../tokens/palette.dart';
import '../tokens/texture.dart';

/// 影 — what a lifted surface casts, falling to the lower right: three stacked
/// layers, each fainter and softer than the last.
///
/// By day it is ink. By night it is the same shape in lamplight
/// ([WAB_TEXTURE_LAMP_GLOW]): no shadow shows on a dark ground, so wherever the
/// light theme casts ink the dark theme casts warm light.
///
/// [strength] scales how dark — or how bright — it is. [reach] scales how far
/// it falls and how soft it is. Put the result on any `BoxDecoration`, or wrap
/// a widget in `WabLift`. `WabColors.lift` reads [dark] from the theme.
List<BoxShadow> wabLift({
  required bool dark,
  double strength = 1,
  double reach = 1,
}) {
  final tone = dark ? WAB_TEXTURE_LAMP_GLOW : WAB_LIGHT_TEXT;
  final alphas = dark ? _nightAlpha : _dayAlpha;
  return [
    for (var i = 0; i < alphas.length; i++)
      BoxShadow(
        color: tone.withValues(alpha: math.min(1.0, alphas[i] * strength)),
        blurRadius: _blur[i] * reach,
        offset: _fall[i] * reach,
      ),
  ];
}

const _dayAlpha = [.20, .13, .07];
const _nightAlpha = [.24, .13, .06];
const _blur = [3.0, 9.0, 18.0];
const _fall = [Offset(2, 2), Offset(4, 5), Offset(8, 11)];
