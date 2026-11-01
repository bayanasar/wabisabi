import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tokens/spacing.dart';
import 'wab_colors.dart';
import 'type_scale.dart';

/// Kai fallback chain — the face for ALL text. First entry is the bundled
/// LXGW WenKai TC (霞鶩文楷, pubspec family `WabKai`, 繁簡全覆蓋), so
/// consumers need no system fonts at all. 正楷帶行意 — no 宋體, no 黑體.
/// The system names below are pure last-resort fallbacks.
const List<String> kWabKaiFallback = [
  'packages/wabisabi/WabKai',
  'Kaiti SC',
  'STKaiti',
  'KaiTi',
  'TW-Kai',
  'DFKai-SB',
  'serif',
];

/// Display chain — hero titles, seals, section headers. Same bundled 文楷,
/// meant to be used with FontWeight.w600+ so the Medium master reads as
/// 行意重筆; then system Kai faces; then the kai chain.
const List<String> kWabDisplayFallback = [
  'packages/wabisabi/WabKai',
  'Xingkai SC',
  'STXingkai',
  'HanziPen SC',
  ...kWabKaiFallback,
];

/// Monospace fallback chain — for code and English labels. First entry is
/// the bundled JetBrains Mono (pubspec family `WabMono`).
const List<String> kWabMonoFallback = [
  'packages/wabisabi/WabMono',
  'JetBrains Mono',
  'SF Mono',
  'SFMono-Regular',
  'Menlo',
  'DejaVu Sans Mono',
  'Consolas',
  'monospace',
];

class WabTheme {
  /// The palette carried by the ambient theme. This is the supported way to
  /// read kit colours: it registers a dependency, so a widget rebuilds when the
  /// theme changes, and it is per-subtree rather than per-process.
  static WabColors of(BuildContext context) => WabColors.of(context);

  // ---------------------------------------------------------------------------
  // Legacy process-wide statics.
  //
  // Assigned by whichever theme builder ran last, which is why an app cannot
  // hold a light and a dark theme at once while anything reads them. Kept so
  // consumers pinned to an older tag keep working; new code reads
  // WabTheme.of(context). See the debts section of ARCHITECTURE.md.
  // ---------------------------------------------------------------------------
  static late Color primaryColor;
  static late Color secondaryColor;
  static late Color hintColor;
  static late Color backgroundColor;
  static late Color surfaceColor;
  static late Color accentColor;
  static late Color onColor;
  static late Color offColor;
  static late Color textColor;
  static late Color woodyColor;
  static late Color progressColor;
  static late Color mutedColor;
  static late Color scratchColor;
  static late Color sealColor;
  static late Color lineColor;
  static late Color paperWhite;
  static late Color mutedLight;
  static bool isDark = true;

  /// Publishes [colors] to the legacy statics.
  static void _adopt(WabColors colors) {
    isDark = colors.isDark;
    primaryColor = colors.primaryColor;
    secondaryColor = colors.secondaryColor;
    hintColor = colors.hintColor;
    backgroundColor = colors.backgroundColor;
    surfaceColor = colors.surfaceColor;
    accentColor = colors.accentColor;
    onColor = colors.onColor;
    offColor = colors.offColor;
    textColor = colors.textColor;
    woodyColor = colors.woodyColor;
    progressColor = colors.progressColor;
    mutedColor = colors.mutedColor;
    scratchColor = colors.scratchColor;
    sealColor = colors.sealColor;
    lineColor = colors.lineColor;
    paperWhite = colors.paperWhite;
    mutedLight = colors.mutedLight;
  }

  /// Drop shadow for ELEVATED surfaces — falls to the bottom-right. The stacked
  /// shadows (decreasing opacity, increasing blur) read as a soft gradient.
  static List<BoxShadow> get elevationShadow =>
      (isDark ? WabColors.dark() : WabColors.light()).elevationShadow;

  static ThemeData materialTheme(
      {Color? primaryColor, Color? secondaryColor, bool lightTheme = true}) {
    final base = lightTheme
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);

    final colors = lightTheme
        ? WabColors.light(
            primaryColor: primaryColor, secondaryColor: secondaryColor)
        : WabColors.dark(
            primaryColor: primaryColor, secondaryColor: secondaryColor);
    _adopt(colors);

    TextTheme baseTextThemeOf(TextTheme base) {
      return base.copyWith(
        headlineMedium: base.headlineMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.textColor,
        ),
        titleLarge: base.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: WabType.label,
          letterSpacing: 0.2,
          color: colors.textColor,
        ),
        displayLarge: base.displayLarge!.copyWith(
          fontSize: WabType.display,
          fontWeight: FontWeight.w700,
          color: colors.textColor,
        ),
        labelLarge: base.labelLarge!.copyWith(
          fontSize: WabType.label,
          fontWeight: FontWeight.w600,
          color: colors.textColor,
        ),
        bodyMedium: base.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
          color: colors.textColor,
        ),
      );
    }

    final baseTextTheme = baseTextThemeOf(base.textTheme)
        .apply(fontFamilyFallback: kWabKaiFallback);

    return base.copyWith(
      extensions: [colors],
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0.0,
        backgroundColor: colors.backgroundColor, // flat — matches scaffold
        toolbarTextStyle: baseTextTheme.bodyMedium,
        titleTextStyle: baseTextTheme.titleLarge,
      ),
      textTheme: baseTextTheme,
      primaryColor: colors.primaryColor,
      scaffoldBackgroundColor: colors.backgroundColor,
      cardColor: colors.surfaceColor,
      dialogTheme: DialogThemeData(backgroundColor: colors.surfaceColor),
      dividerColor: colors.secondaryColor,
      cardTheme: CardThemeData(
        color: colors.surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WAB_CARD_BORDER_RADIUS),
          side: BorderSide(color: colors.secondaryColor, width: 0.8),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: colors.scratchColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WAB_CARD_BORDER_RADIUS),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colors.textColor.withValues(alpha: 0.45)),
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: colors.accentColor,
        secondary: colors.secondaryColor,
        surface: colors.surfaceColor,
        error: colors.sealColor,
        onPrimary: colors.textColor,
        onSecondary: colors.textColor,
        onSurface: colors.textColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Light: lighter & translucent wood; dark: solid dark wood.
          backgroundColor: lightTheme
              ? colors.woodyColor.withValues(alpha: 0.55)
              : colors.woodyColor,
          foregroundColor: colors.textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WAB_CARD_BORDER_RADIUS),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WAB_CARD_BORDER_RADIUS),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
    );
  }

  static CupertinoThemeData cupertinoTheme(
      {Color? primaryColor, Color? secondaryColor, bool lightTheme = false}) {
    final base = CupertinoThemeData(
        brightness: lightTheme ? Brightness.light : Brightness.dark);

    final colors = lightTheme
        ? WabColors.light(
            primaryColor: primaryColor, secondaryColor: secondaryColor)
        : WabColors.dark(
            primaryColor: primaryColor, secondaryColor: secondaryColor);
    _adopt(colors);

    return base.copyWith(
      primaryColor: colors.primaryColor,
      primaryContrastingColor: colors.secondaryColor,
      barBackgroundColor: colors.surfaceColor,
      scaffoldBackgroundColor: colors.backgroundColor,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          color: colors.textColor,
          fontFamilyFallback: kWabKaiFallback,
        ),
        actionTextStyle: TextStyle(
          color: colors.accentColor,
          fontFamilyFallback: kWabKaiFallback,
        ),
        navTitleTextStyle: TextStyle(
          color: colors.textColor,
          fontSize: WabType.title,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          fontFamilyFallback: kWabKaiFallback,
        ),
      ),
    );
  }
}
