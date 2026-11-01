import 'package:flutter/material.dart';

import '../theme/wab_theme.dart';
import '../tokens/material.dart';

/// 古籍欄界三級：
/// - [thin]：雙欄內線同級，適合輸入框、搜索框等輕邊界
/// - [single]：單粗欄
/// - [double]：外粗內細雙欄
enum WabRuleKind { thin, single, double }

/// Flat rule frame modelled on Chinese book-page boundaries.
class WabRuleFrame extends StatelessWidget {
  const WabRuleFrame({
    super.key,
    required this.child,
    this.kind = WabRuleKind.single,
    this.fill,
    this.texture,
    this.ruleColor,
    this.isDark,
  });

  final Widget child;
  final WabRuleKind kind;
  final Color? fill;
  final Widget? texture;
  final Color? ruleColor;
  final bool? isDark;

  static double ruleWidth(WabRuleKind kind) => switch (kind) {
        WabRuleKind.thin => WAB_RULE_INNER_WIDTH,
        WabRuleKind.single => WAB_RULE_SINGLE_WIDTH,
        WabRuleKind.double => WAB_RULE_OUTER_WIDTH,
      };

  static double ruleInset(WabRuleKind kind) => switch (kind) {
        WabRuleKind.thin => WAB_RULE_INNER_WIDTH + 2,
        WabRuleKind.single => WAB_RULE_SINGLE_WIDTH + 2,
        WabRuleKind.double =>
          WAB_RULE_OUTER_WIDTH + WAB_RULE_GAP + WAB_RULE_INNER_WIDTH + 2,
      };

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? WabTheme.of(context).isDark;
    final ink = (ruleColor ?? WabTheme.of(context).textColor).withValues(
      alpha: dark ? WAB_RULE_OPACITY_DARK : WAB_RULE_OPACITY_LIGHT,
    );
    return Stack(
      children: [
        if (fill != null) Positioned.fill(child: ColoredBox(color: fill!)),
        if (texture != null)
          Positioned.fill(child: IgnorePointer(child: texture!)),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _RuleFramePainter(kind, ink)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(ruleInset(kind)),
          child: child,
        ),
      ],
    );
  }
}

class _RuleFramePainter extends CustomPainter {
  const _RuleFramePainter(this.kind, this.ink);

  final WabRuleKind kind;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    if (kind == WabRuleKind.thin) {
      canvas.drawRect(
        rect.deflate(WAB_RULE_INNER_WIDTH / 2),
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = WAB_RULE_INNER_WIDTH,
      );
      return;
    }
    if (kind == WabRuleKind.single) {
      canvas.drawRect(
        rect.deflate(WAB_RULE_SINGLE_WIDTH / 2),
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = WAB_RULE_SINGLE_WIDTH,
      );
      return;
    }

    canvas.drawRect(
      rect.deflate(WAB_RULE_OUTER_WIDTH / 2),
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = WAB_RULE_OUTER_WIDTH,
    );
    canvas.drawRect(
      rect.deflate(
        WAB_RULE_OUTER_WIDTH + WAB_RULE_GAP + WAB_RULE_INNER_WIDTH / 2,
      ),
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = WAB_RULE_INNER_WIDTH,
    );
  }

  @override
  bool shouldRepaint(_RuleFramePainter old) =>
      old.kind != kind || old.ink != ink;
}
