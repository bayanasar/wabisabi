import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wabisabi/wabisabi.dart';

Future<void> _load(String family, String file) async {
  final bytes = File('assets/fonts/$file').readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.sublistView(bytes))))
      .load();
}

/// The pixels of [text] in [style], on its baseline at a fixed height, so
/// two styles with different line metrics draw a shared glyph in the same
/// place.
Future<Uint8List> _pixels(String text, TextStyle style) async {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  final baseline = painter.computeDistanceToActualBaseline(
    TextBaseline.alphabetic,
  );
  final recorder = ui.PictureRecorder();
  painter.paint(Canvas(recorder), Offset(0, 48 - baseline));
  final image = await recorder.endRecording().toImage(96, 64);
  final data = await image.toByteData();
  painter.dispose();
  image.dispose();
  return data!.buffer.asUint8List();
}

void main() {
  testWidgets('Chinese in the monospace chain is drawn in the bundled Kai', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await _load(kWabMonoFamily, 'WabMono-Regular.ttf');
      await _load(kWabKaiFamily, 'WabKai-Regular.ttf');

      const mono = TextStyle(
        fontFamily: kWabMonoFamily,
        fontFamilyFallback: kWabMonoFallback,
        fontSize: 32,
      );
      const kai = TextStyle(fontFamily: kWabKaiFamily, fontSize: 32);
      const latin = TextStyle(fontFamily: kWabMonoFamily, fontSize: 32);

      // WabMono has no 事, so the chain must reach WabKai for it.
      expect(await _pixels('事', mono), await _pixels('事', kai));
      // Latin still comes from WabMono.
      expect(await _pixels('g', mono), await _pixels('g', latin));
      expect(await _pixels('g', mono), isNot(await _pixels('g', kai)));
    });
  });
}
