// Checks the public surface reachable from lib/wabisabi.dart. See ARCHITECTURE.md.
// Run: dart tool/check_public_api.dart
//
// Two rules:
//   PREFIX   every exported name is prefixed — Wab / WAB_ / kWab / wab.
//            The barrel lands in the consumer's namespace; a bare `DotGrid`
//            or `TexturePainter` collides with whatever else they import.
//   EXAMPLE  every exported type appears in example/lib. The catalogue is the
//            kit's only visual test; a widget nobody drew is a widget nobody saw.
//
// A declaration marked @Deprecated is exempt from both rules. An old name kept
// as a migration alias exists precisely to be the old name, and showcasing
// something scheduled for removal would be advertising it. The annotation is a
// public commitment to delete it, and the analyzer flags every use meanwhile.
//
// Known violations live in tool/public_api_baseline.txt. The script fails on
// anything NOT in that file, so the surface can only get cleaner: fix a line,
// delete a line. It also fails on baseline entries that no longer apply, which
// keeps the file from turning into a graveyard.

import 'dart:io';

const _barrel = 'lib/wabisabi.dart';
const _baselinePath = 'tool/public_api_baseline.txt';

final _prefixes = ['Wab', 'WAB_', 'kWab', 'wab'];

/// Top-level declaration: no leading whitespace, so class members never match.
final _typeDecl = RegExp(
  r'^(?:abstract\s+|base\s+|final\s+|sealed\s+|interface\s+|mixin\s+)*'
  r'(?:class|enum|mixin|extension|typedef)\s+([A-Za-z_][A-Za-z0-9_]*)',
  multiLine: true,
);
final _memberDecl = RegExp(
  r'^(?:const|final)\s+[A-Za-z_][A-Za-z0-9_<>?,\s]*?\s+([A-Za-z_][A-Za-z0-9_]*)\s*=',
  multiLine: true,
);
final _functionDecl = RegExp(
  r'^([A-Za-z_][A-Za-z0-9_<>?,\s]*?\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*\([^)]*\)\s*(?:=>|\{)',
  multiLine: true,
);

final _exportLine = RegExp(r"^\s*export\s+'([^']+)'", multiLine: true);

class Decl {
  Decl(this.name, this.file, {required this.isType});
  final String name;
  final String file;
  final bool isType;
}

String normalize(String path) {
  final out = <String>[];
  for (final part in path.split('/')) {
    if (part == '.' || part.isEmpty) continue;
    if (part == '..') {
      if (out.isNotEmpty) out.removeLast();
      continue;
    }
    out.add(part);
  }
  return out.join('/');
}

/// Files the barrel puts on the public surface, directly or via re-export.
Set<String> exportedFiles() {
  final seen = <String>{};
  final queue = <String>[_barrel];
  while (queue.isNotEmpty) {
    final file = queue.removeLast();
    if (!seen.add(file)) continue;
    final dir = file.substring(0, file.lastIndexOf('/'));
    for (final m in _exportLine.allMatches(File(file).readAsStringSync())) {
      final uri = m.group(1)!;
      if (uri.startsWith('package:') || uri.startsWith('dart:')) continue;
      queue.add(normalize('$dir/$uri'));
    }
  }
  return seen..remove(_barrel);
}

/// True when the declaration starting at [offset] carries an @Deprecated
/// annotation on one of the lines immediately above it.
bool isDeprecated(String source, int offset) {
  final before = source.substring(0, offset).trimRight();
  for (final line in before.split('\n').reversed.take(6)) {
    final t = line.trim();
    if (t.startsWith('@Deprecated') || t.startsWith('@deprecated')) return true;
    // walk back past the doc comment and the rest of the annotation's argument
    if (t.isEmpty || t.startsWith('///') || t.startsWith('//')) continue;
    if (t.endsWith(',') || t.endsWith("'") || t.endsWith(')')) continue;
    return false;
  }
  return false;
}

List<Decl> publicDecls(String file) {
  final source = File(file).readAsStringSync();
  final decls = <Decl>[];
  void add(String name, {required bool isType}) {
    if (name.startsWith('_')) return;
    decls.add(Decl(name, file, isType: isType));
  }

  for (final m in _typeDecl.allMatches(source)) {
    if (isDeprecated(source, m.start)) continue;
    add(m.group(1)!, isType: true);
  }
  for (final m in _memberDecl.allMatches(source)) {
    if (isDeprecated(source, m.start)) continue;
    add(m.group(1)!, isType: false);
  }
  for (final m in _functionDecl.allMatches(source)) {
    if (isDeprecated(source, m.start)) continue;
    final name = m.group(2)!;
    // Skip control flow and the type/member declarations already collected.
    if (const {'if', 'for', 'while', 'switch', 'catch', 'return'}
        .contains(name)) {
      continue;
    }
    if (decls.any((d) => d.name == name)) continue;
    add(name, isType: false);
  }
  return decls;
}

Set<String> baseline() {
  final file = File(_baselinePath);
  if (!file.existsSync()) return {};
  return file
      .readAsLinesSync()
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty && !l.startsWith('#'))
      .toSet();
}

void main() {
  final exampleSource = Directory('example/lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .map((f) => f.readAsStringSync())
      .join('\n');
  final usedInExample = RegExp(r'[A-Za-z_][A-Za-z0-9_]*')
      .allMatches(exampleSource)
      .map((m) => m.group(0)!)
      .toSet();

  final violations = <String>{};
  var typeCount = 0;
  var nameCount = 0;

  for (final file in exportedFiles().toList()..sort()) {
    for (final decl in publicDecls(file)) {
      nameCount++;
      if (decl.isType) typeCount++;

      if (!_prefixes.any(decl.name.startsWith)) {
        violations.add('PREFIX ${decl.name} ${decl.file}');
      }
      if (decl.isType && !usedInExample.contains(decl.name)) {
        violations.add('EXAMPLE ${decl.name} ${decl.file}');
      }
    }
  }

  final known = baseline();
  final fresh = (violations.difference(known)).toList()..sort();
  final stale = (known.difference(violations)).toList()..sort();

  stdout.writeln(
    'public api — $nameCount exported names ($typeCount types), '
    '${violations.length} violation(s), ${known.length} baselined',
  );

  if (fresh.isNotEmpty) {
    stderr.writeln(
        '\n${fresh.length} NEW violation(s) — fix them, or add to $_baselinePath:\n');
    for (final v in fresh) {
      stderr.writeln('  $v');
    }
  }
  if (stale.isNotEmpty) {
    stderr.writeln(
        '\n${stale.length} baseline entr(y/ies) no longer apply — delete these lines from $_baselinePath:\n');
    for (final v in stale) {
      stderr.writeln('  $v');
    }
  }
  if (fresh.isNotEmpty || stale.isNotEmpty) exitCode = 1;
}
