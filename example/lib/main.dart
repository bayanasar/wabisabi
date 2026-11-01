import 'package:flutter/material.dart';
import 'package:wabisabi/wabisabi.dart';

import 'golden1_showcase.dart';

void main() => runApp(const WabisabiExample());

class WabisabiExample extends StatefulWidget {
  const WabisabiExample({super.key});

  @override
  State<WabisabiExample> createState() => _WabisabiExampleState();
}

class _WabisabiExampleState extends State<WabisabiExample> {
  ThemeMode mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    // Both themes are held at once and the toggle only switches which is
    // active. The kit's palette rides on ThemeData, so the catalogue follows
    // whichever one is live — including ThemeMode.system.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: WabTheme.materialTheme(lightTheme: true),
      darkTheme: WabTheme.materialTheme(lightTheme: false),
      themeMode: mode,
      home: Golden1Showcase(
        onToggleTheme: () => setState(
          () =>
              mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        ),
      ),
    );
  }
}
