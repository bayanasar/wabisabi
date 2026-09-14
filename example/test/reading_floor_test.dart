// WabType.gloss is the smallest size text is set in, but a size is only kept
// if the page keeps it: a cell drawn smaller than designed takes its type below
// the floor with it. This measures every run of text as it lands on screen,
// every transform above it included.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/wabisabi.dart';
import 'package:example/golden1_showcase.dart';

const _widths = <double>[320, 390, 900, 1024, 1280, 1440, 1920];

/// The smallest font size of any visible run in [span].
double _smallest(InlineSpan span, double inherited) {
  var smallest = double.infinity;
  final size = span.style?.fontSize ?? inherited;
  if (span is TextSpan) {
    if ((span.text ?? '').trim().isNotEmpty) smallest = size;
    for (final child in span.children ?? const <InlineSpan>[]) {
      smallest = math.min(smallest, _smallest(child, size));
    }
  }
  return smallest;
}

/// Icons and seal faces are drawn, not read: a seal's characters are fitted to
/// its square the way a glyph is fitted to an icon's.
bool _isMark(Element element, InlineSpan span) {
  final family = span.style?.fontFamily ?? '';
  if (family.contains('MaterialIcons') || family.contains('CupertinoIcons')) {
    return true;
  }
  var inSeal = false;
  element.visitAncestorElements((ancestor) {
    inSeal = ancestor.widget is WabSealMark;
    return !inSeal;
  });
  return inSeal;
}

void main() {
  for (final width in _widths) {
    testWidgets('no text lands below the reading floor at ${width.toInt()}px',
        (tester) async {
      tester.view.physicalSize = Size(width, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        theme: WabTheme.materialTheme(lightTheme: true),
        home: Golden1Showcase(onToggleTheme: () {}),
      ));
      await tester.pump(const Duration(milliseconds: 200));

      final tooSmall = <String>[];
      for (final element in find.byType(RichText).evaluate()) {
        final paragraph = element.renderObject! as RenderParagraph;
        if (!paragraph.attached || paragraph.size.isEmpty) continue;
        if (_isMark(element, paragraph.text)) continue;
        final base = _smallest(paragraph.text, WabType.body);
        if (base == double.infinity) continue;

        final m = paragraph.getTransformTo(null);
        final scale = math.sqrt(
          m.entry(0, 0) * m.entry(0, 0) + m.entry(1, 0) * m.entry(1, 0),
        );
        if (scale == 0) continue; // collapsed, not drawn

        final onScreen = paragraph.textScaler.scale(base) * scale;
        if (onScreen < WabType.gloss - .01) {
          tooSmall.add('${onScreen.toStringAsFixed(1)}px  '
              '"${paragraph.text.toPlainText().replaceAll('\n', ' ')}"');
        }
      }

      expect(tooSmall, isEmpty, reason: tooSmall.take(10).join('\n'));
    });
  }
}
