// Checks the two house rules from ARCHITECTURE.md that are mechanical enough
// to check. Run: dart tool/check_house_rules.dart
//
//   ink and paper  No pure black, no pure white, no Material accent colour.
//                  A shadow is pigment, not the absence of light.
//   the ladder     No font size written as a number. Sizes come from WabType,
//                  which is a golden-section scale; a literal is a size chosen
//                  on its own. Nothing below the reading floor, WabType.gloss.
//
// Both hold across lib/ and example/lib/, because a catalogue that breaks the
// kit's own rules is how the rules stop being true.

import 'dart:io';

/// What may never appear in a colour position, and what to use instead.
const _forbiddenColors = <String, String>{
  'Colors.black': 'WAB_TEXTURE_INK — a shadow is ink, not absent light',
  'Colors.white': 'a paper tone: WAB_TEXTURE_PAPER_HIGHLIGHT_LIGHT, or paperWhite',
  'Colors.red': "the theme's sealColor",
  'Colors.redAccent': "the theme's sealColor",
  '0xFF000000': 'WAB_TEXTURE_INK',
  '0xFFFFFFFF': 'a paper tone',
};

/// `Colors.transparent` is not a colour, it is the absence of one, and
/// `Colors.black` never appears as a substring of it — but `Colors.blackXx`
/// would, so matches are bounded.
final _wordBoundary = RegExp(r'[A-Za-z0-9_]');

/// A font size written as a number rather than taken from the ladder.
final _literalFontSize = RegExp(r'fontSize:\s*-?[0-9]');

/// A rung below the reading floor. The analyzer flags these as deprecated, but
/// an ignore comment silences the analyzer and not this.
final _belowFloor = RegExp(r'WabType\.(annotation|caption)\b');

final _lineComment = RegExp(r'^\s*//');

List<File> sources() => [
      for (final dir in ['lib', 'example/lib'])
        ...Directory(dir)
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart')),
    ]..sort((a, b) => a.path.compareTo(b.path));

void main() {
  final problems = <String>[];
  var files = 0;

  for (final file in sources()) {
    files++;
    final path = file.path.replaceAll(r'\', '/');
    // The tokens are where the raw values legitimately live, and the rule
    // documents itself in prose there.
    final isTokenFile = path.startsWith('lib/tokens/');
    final lines = file.readAsLinesSync();

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (_lineComment.hasMatch(line) || line.trimLeft().startsWith('///')) {
        continue;
      }
      final where = '$path:${i + 1}';

      for (final entry in _forbiddenColors.entries) {
        final at = line.indexOf(entry.key);
        if (at < 0) continue;
        final after = at + entry.key.length;
        if (after < line.length && _wordBoundary.hasMatch(line[after])) {
          continue; // Colors.blackberry is somebody else's problem
        }
        if (isTokenFile && entry.key.startsWith('0x')) continue;
        problems.add('$where\n    ${entry.key} — use ${entry.value}');
      }

      if (_literalFontSize.hasMatch(line)) {
        problems.add(
          '$where\n'
          '    font size written as a literal — use a WabType rung, or add one '
          'to the ladder if the size is genuinely missing',
        );
      }

      if (path != 'lib/theme/type_scale.dart' && _belowFloor.hasMatch(line)) {
        problems.add(
          '$where\n'
          '    ${_belowFloor.firstMatch(line)![0]} is below the reading floor '
          '— use WabType.gloss or larger',
        );
      }
    }
  }

  if (problems.isEmpty) {
    stdout.writeln('house rules ok — $files files, ink and paper only, '
        'every size on the ladder and above the floor');
    return;
  }

  stderr.writeln('${problems.length} house-rule problem(s):\n');
  for (final p in problems) {
    stderr.writeln('  $p\n');
  }
  exitCode = 1;
}
