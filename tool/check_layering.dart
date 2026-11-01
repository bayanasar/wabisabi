// Enforces the import contract inside lib/. See ARCHITECTURE.md for the why.
// Run: dart tool/check_layering.dart
//
// Imports may point DOWN a layer or sideways within one; never up.
//
//   tokens/*_raw.dart  (0)  pure Dart, no Flutter
//   tokens/*.dart      (1)  Flutter-typed token wrappers
//   theme/             (2)  ThemeData + text primitives
//   materials/         (3)  procedural painters and surfaces
//   components/        (4)  widgets
//   wabisabi.dart           the barrel — exports everything, imported by nobody
//
// Sideways imports are fine and expected (surface.dart composes its siblings);
// the invariants are direction, acyclicity, and a sealed raw token layer.

import 'dart:io';

const _layerOf = <String, int>{
  'tokens_raw': 0,
  'tokens': 1,
  'theme': 2,
  'materials': 3,
  'components': 4,
};

const _barrel = 'lib/wabisabi.dart';

/// Layer name for a lib-relative path, or null when the path sits in a
/// directory the contract does not describe.
String? layerName(String path) {
  if (path.startsWith('lib/tokens/')) {
    return path.endsWith('_raw.dart') ? 'tokens_raw' : 'tokens';
  }
  if (path.startsWith('lib/theme/')) return 'theme';
  if (path.startsWith('lib/materials/')) return 'materials';
  if (path.startsWith('lib/components/')) return 'components';
  return null;
}

/// Relative (non-`package:`, non-`dart:`) imports and exports, resolved
/// against the importing file's directory.
List<String> localDeps(String path) {
  final dir = path.substring(0, path.lastIndexOf('/'));
  final pattern = RegExp(r"^\s*(?:import|export)\s+'([^']+)'", multiLine: true);
  final deps = <String>[];
  for (final m in pattern.allMatches(File(path).readAsStringSync())) {
    final uri = m.group(1)!;
    if (uri.startsWith('package:') || uri.startsWith('dart:')) {
      if (uri.startsWith('package:wabisabi/')) deps.add(_barrel);
      continue;
    }
    deps.add(normalize('$dir/$uri'));
  }
  return deps;
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

/// Every cycle reachable in [graph], as the list of files that close it.
List<List<String>> findCycles(Map<String, List<String>> graph) {
  final cycles = <List<String>>[];
  final state = <String, int>{}; // 1 = on stack, 2 = done
  final stack = <String>[];

  void visit(String node) {
    state[node] = 1;
    stack.add(node);
    for (final dep in graph[node] ?? const <String>[]) {
      if (state[dep] == 1) {
        cycles.add([...stack.sublist(stack.indexOf(dep)), dep]);
      } else if (state[dep] == null) {
        visit(dep);
      }
    }
    stack.removeLast();
    state[node] = 2;
  }

  for (final node in graph.keys) {
    if (state[node] == null) visit(node);
  }
  return cycles;
}

void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.replaceAll(r'\', '/'))
      .where((p) => p.endsWith('.dart'))
      .toList()
    ..sort();

  final problems = <String>[];
  final graph = <String, List<String>>{};

  for (final file in files) {
    final deps = localDeps(file);
    graph[file] = deps;

    if (file == _barrel) continue; // the barrel may reach anything

    final layer = layerName(file);
    if (layer == null) {
      problems.add(
        '$file\n'
        '    lives outside the declared layers. Add the directory to '
        'ARCHITECTURE.md and to _layerOf in this script, or move the file.',
      );
      continue;
    }

    for (final dep in deps) {
      if (dep == _barrel) {
        problems.add(
          '$file\n'
          '    imports the barrel. Inside lib/ import the defining file '
          'directly — the barrel is for consumers.',
        );
        continue;
      }

      final depLayer = layerName(dep);
      if (depLayer == null) {
        problems.add(
          '$file\n    imports $dep, which is outside the declared layers.',
        );
        continue;
      }

      if (depLayer == 'tokens_raw' && layer != 'tokens') {
        problems.add(
          '$file\n'
          '    imports the raw token $dep. Raw tokens are the pure-Dart source '
          'for tool/export_tokens.dart; wrap the value in tokens/ and use the '
          'WAB_* wrapper instead.',
        );
        continue;
      }

      if (_layerOf[depLayer]! > _layerOf[layer]!) {
        problems.add(
          '$file ($layer)\n'
          '    imports upward into $dep ($depLayer). Imports point down or '
          'sideways only.',
        );
      }
    }
  }

  for (final cycle in findCycles(graph)) {
    problems.add('import cycle:\n    ${cycle.join('\n    -> ')}');
  }

  if (problems.isEmpty) {
    stdout.writeln(
        'layering ok — ${files.length} files, no upward imports, no cycles');
    return;
  }

  stderr.writeln('${problems.length} layering problem(s):\n');
  for (final p in problems) {
    stderr.writeln('  $p\n');
  }
  exitCode = 1;
}
