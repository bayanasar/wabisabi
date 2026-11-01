import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'wab_widget.dart';
import '../theme/wab_colors.dart';
import '../theme/wab_theme.dart';
import '../tokens/material.dart';
import '../tokens/spacing.dart';
import '../theme/type_scale.dart';

class WabScaffold extends WabWidget {
  const WabScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.textured = false,
  });

  final Widget body;
  final Text? title;
  final WabAppBar? appBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Paints the ambient washi / lacquer ground behind [body].
  /// [WabTexturedScaffold] is this flag with a name.
  final bool textured;

  Widget _ground(WabColors wab, Widget content) {
    if (!textured) return content;
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: WabTexturePainter(isDark: wab.isDark)),
        ),
        content,
      ],
    );
  }

  /// CupertinoPageScaffold has no floating-action slot, so place the button
  /// where Material would rather than dropping it.
  Widget _withFloatingAction(Widget content) {
    if (floatingActionButton == null) return content;
    return Stack(
      children: [
        Positioned.fill(child: content),
        Positioned(
          right: 16,
          bottom: 16,
          child: SafeArea(child: floatingActionButton!),
        ),
      ],
    );
  }

  Widget _wrapCupertinoBody(BuildContext context, Widget content) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.bodyMedium ??
        TextStyle(
          color: WabTheme.of(context).textColor,
          fontSize: WabType.body,
          fontFamilyFallback: kWabKaiFallback,
          decoration: TextDecoration.none,
        );
    return Material(
      type: MaterialType.transparency,
      child: DefaultTextStyle(
        style: defaultStyle,
        child: content,
      ),
    );
  }

  @override
  CupertinoPageScaffold createCupertinoWidget(BuildContext context) {
    final wab = WabTheme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: textured ? wab.backgroundColor : null,
      navigationBar: appBar?.createCupertinoWidget(context) ??
          WabAppBar(title: title).createCupertinoWidget(context),
      child: _wrapCupertinoBody(
        context,
        _ground(wab, _withFloatingAction(body)),
      ),
    );
  }

  @override
  Scaffold createMaterialWidget(BuildContext context) {
    final wab = WabTheme.of(context);
    return Scaffold(
      backgroundColor: textured ? wab.backgroundColor : null,
      appBar: appBar?.createMaterialWidget(context) ??
          WabAppBar(title: title).createMaterialWidget(context),
      body: _ground(wab, body),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
    );
  }
}

/// [WabScaffold] with the ambient material ground painted behind the body.
class WabTexturedScaffold extends WabScaffold {
  const WabTexturedScaffold({
    super.key,
    required super.body,
    super.title,
    super.appBar,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
  }) : super(textured: true);
}

class WabAppBar extends WabWidget {
  const WabAppBar({super.key, this.title, this.action, this.leading});

  final Text? title;
  final Widget? action;
  final Widget? leading;

  @override
  CupertinoNavigationBar createCupertinoWidget(BuildContext context) =>
      CupertinoNavigationBar(
        leading: leading,
        middle: title,
        trailing: action,
      );

  @override
  PreferredSize createMaterialWidget(BuildContext context) => PreferredSize(
        preferredSize: WAB_APP_BAR_SIZE,
        child: AppBar(
          leading: leading,
          title: title,
          actions: action == null ? null : [action!],
        ),
      );
}

/// Lifted panel on the primary ground.
///
/// Composes a [Container] rather than extending one: the decoration is built
/// at build time from the ambient theme, so it follows a theme change instead
/// of freezing whatever palette existed when the widget was constructed.
class WabContainer extends StatelessWidget {
  const WabContainer({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return Container(
      padding: padding ?? WAB_PADDING_CONTAINER_SMALL,
      margin: WAB_PADDING_ALL,
      decoration: _lifted(wab, wab.primaryColor),
      child: child,
    );
  }
}

/// [WabContainer] on the surface ground.
class WabLiteContainer extends StatelessWidget {
  const WabLiteContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return Container(
      margin: WAB_PADDING_ALL,
      padding: WAB_PADDING_CONTAINER_SMALL,
      decoration: _lifted(wab, wab.surfaceColor),
      child: child,
    );
  }
}

BoxDecoration _lifted(WabColors wab, Color fill) => BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(WAB_SECTION_BORDER_RADIUS),
      boxShadow: wab.elevationShadow,
      border: Border.all(
        color: wab.isDark
            ? wab.accentColor.withValues(alpha: 0.28)
            : wab.secondaryColor,
        width: 0.8,
      ),
    );

/// Content bounds only — no ground, no elevation.
class WabContentContainer extends StatelessWidget {
  const WabContentContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        margin: margin ?? const EdgeInsets.only(bottom: 8),
        // No default width cap — opt in via [maxWidth] only when needed.
        constraints:
            maxWidth == null ? null : BoxConstraints(maxWidth: maxWidth!),
        child: child,
      );
}

class WabTexturePainter extends CustomPainter {
  final bool isDark;
  WabTexturePainter({required this.isDark});

  // Deterministic pseudo-random in [0,1) from two ints.
  static double _rand(int a, int b) =>
      ((a * 1664525 + b * 1013904223 + 42) & 0x7FFFFFFF) / 0x7FFFFFFF;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    if (isDark) {
      _paintDarkLacquer(canvas, w, h);
    } else {
      _paintLightWashi(canvas, w, h);
    }
  }

  void _paintLightWashi(Canvas canvas, double w, double h) {
    // Layer 1 — cloud tonal variation: overlapping translucent ellipses
    // Some warmer, some slightly cooler, creates the watercolor cloudiness.
    const cloudPositions = [
      [0.08, 0.12],
      [0.55, 0.07],
      [0.82, 0.18],
      [0.25, 0.35],
      [0.70, 0.30],
      [0.10, 0.60],
      [0.45, 0.55],
      [0.90, 0.65],
      [0.30, 0.80],
      [0.65, 0.75],
      [0.15, 0.92],
      [0.80, 0.88],
      [0.50, 0.20],
      [0.40, 0.70],
    ];
    final warmCloud = Paint()
      ..color = WAB_WASHI_CLOUD_WARM
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    final coolCloud = Paint()
      ..color = WAB_WASHI_CLOUD_COOL
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 55);
    for (int k = 0; k < cloudPositions.length; k++) {
      final cx = cloudPositions[k][0] * w;
      final cy = cloudPositions[k][1] * h;
      final rx = 80.0 + _rand(k, 1) * 100;
      final ry = 60.0 + _rand(k, 2) * 80;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx, cy), width: rx * 2, height: ry * 2),
          k.isEven ? warmCloud : coolCloud);
    }

    // Layer 2 — washi fiber threads: horizontal, slight organic wave, varying weight
    final fiberBase = Paint()..style = PaintingStyle.stroke;
    double jPos = 0;
    int row = 0;
    while (jPos < h) {
      final opacity = (0x06 + (_rand(row, 7) * 0x0E).toInt()) / 255;
      final strokeW = 0.3 + _rand(row, 11) * 0.7;
      fiberBase.color = WAB_WASHI_FIBER.withValues(alpha: opacity);
      fiberBase.strokeWidth = strokeW;

      if (_rand(row, 3) < 0.62) {
        final path = Path()..moveTo(0, jPos);
        for (double x = 0; x < w; x += 60) {
          final ctrlX = x + 30;
          final ctrlY = jPos + (_rand(row, (x ~/ 10)) * 3 - 1.5);
          final endY = jPos + (_rand(row, (x ~/ 7)) * 2 - 1.0);
          path.quadraticBezierTo(ctrlX, ctrlY, x + 60, endY);
        }
        canvas.drawPath(path, fiberBase);
      }

      jPos += 2 + (_rand(row, 5) * 4).toInt();
      row++;
    }

    // Layer 3 — grain: scattered micro-dots
    final grainPaint = Paint()..color = WAB_WASHI_GRAIN;
    for (int i = 0; i < w.toInt(); i += 3) {
      for (int j = 0; j < h.toInt(); j += 3) {
        if (_rand(i, j) > 0.80) {
          final r = 0.3 + _rand(i + 1, j) * 0.4;
          canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), r, grainPaint);
        }
      }
    }
  }

  void _paintDarkLacquer(Canvas canvas, double w, double h) {
    // Layer 1 — vignette: soft black at corners to add depth
    final vigPaint = Paint()..color = WAB_LACQUER_VIGNETTE;
    final vRad = w * 0.45;
    canvas.drawCircle(Offset(0, 0), vRad, vigPaint);
    canvas.drawCircle(Offset(w, 0), vRad, vigPaint);
    canvas.drawCircle(Offset(0, h), vRad, vigPaint);
    canvas.drawCircle(Offset(w, h), vRad, vigPaint);

    // Layer 2 — warm amber cloud patches (barely visible)
    final warmPatch = Paint()
      ..color = WAB_LACQUER_PATCH
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70);
    const patches = [
      [0.25, 0.30],
      [0.70, 0.60],
      [0.45, 0.80],
      [0.80, 0.20]
    ];
    for (int k = 0; k < patches.length; k++) {
      final cx = patches[k][0] * w;
      final cy = patches[k][1] * h;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: 160, height: 120),
        warmPatch,
      );
    }

    // Layer 3 — fine warm grain
    final grainPaint = Paint()..color = WAB_LACQUER_GRAIN;
    for (int i = 0; i < w.toInt(); i += 3) {
      for (int j = 0; j < h.toInt(); j += 3) {
        if (_rand(i, j) > 0.85) {
          canvas.drawCircle(
              Offset(i.toDouble(), j.toDouble()), 0.6, grainPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant WabTexturePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// Old name, kept so consumers can migrate without a broken build.
@Deprecated('Renamed to WabTexturePainter. This alias goes at the next major '
    'version.')
typedef TexturePainter = WabTexturePainter;
