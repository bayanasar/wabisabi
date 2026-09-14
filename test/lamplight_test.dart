import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/wabisabi.dart';

bool _sameHue(Color a, Color b) => a.withValues(alpha: 1) == b.withValues(alpha: 1);

void main() {
  test('the dark theme casts lamplight, not ink', () {
    final shadows = WabColors.dark().elevationShadow;
    expect(shadows, isNotEmpty);
    for (final s in shadows) {
      expect(_sameHue(s.color, WAB_TEXTURE_LAMP_GLOW), isTrue,
          reason: 'dark elevation should glow, found ${s.color}');
    }
  });

  test('the light theme still casts ink', () {
    for (final s in WabColors.light().elevationShadow) {
      expect(_sameHue(s.color, WAB_TEXTURE_LAMP_GLOW), isFalse);
    }
  });

  test('strength and reach scale the lift', () {
    final base = wabLift(dark: false);
    final tuned = wabLift(dark: false, strength: 2, reach: 2);
    for (var i = 0; i < base.length; i++) {
      expect(tuned[i].color.a, closeTo(base[i].color.a * 2, 1e-6));
      expect(tuned[i].blurRadius, base[i].blurRadius * 2);
      expect(tuned[i].offset, base[i].offset * 2);
    }
  });
}
