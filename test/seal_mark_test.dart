import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/wabisabi.dart';

void main() {
  // Text of any proportion sits in the middle of the face: a word or two
  // characters are wider than tall, and one character is smaller than the face.
  for (final kind in WabSealMarkKind.values) {
    for (final text in ['FEY', '侘寂', '侘']) {
      testWidgets('${kind.name} seal centres "$text"', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(child: WabSealMark(text: text, kind: kind, size: 48)),
          ),
        );

        final seal = tester.getRect(find.byType(WabSealMark));
        final glyphs = tester.getRect(find.byType(FittedBox));
        expect(glyphs.center.dx, moreOrLessEquals(seal.center.dx, epsilon: .5));
        expect(glyphs.center.dy, moreOrLessEquals(seal.center.dy, epsilon: .5));
      });
    }
  }
}
