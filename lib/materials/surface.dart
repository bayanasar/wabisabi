import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/spacing.dart';
import '../tokens/texture.dart';
import 'cinnabar_texture.dart';
import 'cloth_weave.dart';
import 'deckle_surface.dart';
import 'fiber_texture.dart';
import 'ink_wash.dart';
import 'jade_texture.dart';
import 'paper_texture.dart';
import 'patina_texture.dart';
import 'rubbing_texture.dart';
import 'wood_grain.dart';

enum WabSurfaceKind {
  paper,
  fiber,
  mottle,
  woodGrain,
  clothWeave,
  jadeSheen,
  rubbing,
  inkWash,
  patina,
  cinnabar,
  deckle,
}

/// Public material façade. Every catalogue material comes through the kit.
class WabSurface extends StatelessWidget {
  const WabSurface({
    super.key,
    required this.kind,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.isDark,
    this.clip = true,
  });

  final WabSurfaceKind kind;
  final Widget child;
  final EdgeInsets padding;
  final bool? isDark;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? WabTheme.of(context).isDark;
    final paper =
        dark ? WAB_TEXTURE_PAPER_BASE_DARK : WAB_TEXTURE_PAPER_BASE_LIGHT;
    final fibrePaper = dark
        ? paper
        : Color.alphaBlend(
            WAB_TEXTURE_PAPER_AGE_LIGHT.withValues(alpha: .055), paper);
    final content = Padding(padding: padding, child: child);

    Widget surface = switch (kind) {
      WabSurfaceKind.paper => ColoredBox(
          color: paper,
          child: WabPaperTexture(
            isDark: dark,
            strength: 1.05,
            child: WabFiberTexture(isDark: dark, strength: .12, child: content),
          ),
        ),
      WabSurfaceKind.fiber => ColoredBox(
          color: fibrePaper,
          child: WabPaperTexture(
            isDark: dark,
            strength: .70,
            child: WabFiberTexture(isDark: dark, strength: .54, child: content),
          ),
        ),
      WabSurfaceKind.mottle => ColoredBox(
          color: paper,
          child: WabPaperTexture(
            isDark: dark,
            kind: WabPaperTextureKind.mottle,
            strength: 1.20,
            child: content,
          ),
        ),
      WabSurfaceKind.woodGrain =>
        CustomPaint(painter: WabWoodGrain(isDark: dark), child: content),
      WabSurfaceKind.clothWeave =>
        WabClothTexture(isDark: dark, child: content),
      WabSurfaceKind.jadeSheen => WabJadeTexture(isDark: dark, child: content),
      WabSurfaceKind.rubbing => WabRubbingTexture(child: content),
      WabSurfaceKind.inkWash => ColoredBox(
          color: paper,
          child: WabPaperTexture(
            isDark: dark,
            strength: .28,
            child: CustomPaint(
              painter: WabInkWash(colors: WabTheme.of(context), isDark: dark),
              child: content,
            ),
          ),
        ),
      WabSurfaceKind.patina => WabPatinaTexture(isDark: dark, child: content),
      WabSurfaceKind.cinnabar =>
        WabCinnabarTexture(isDark: dark, child: content),
      WabSurfaceKind.deckle => WabDeckleSurface(
          fill: paper,
          texture: WabPaperTexture(isDark: dark, strength: 1.0),
          roughness: 3.1,
          child: content,
        ),
    };

    if (!clip || kind == WabSurfaceKind.deckle) return surface;
    return ClipRRect(
      borderRadius: BorderRadius.circular(WAB_CARD_BORDER_RADIUS),
      child: surface,
    );
  }
}
