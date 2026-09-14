import 'package:flutter/material.dart';
import 'package:wabisabi/wabisabi.dart';

// Composition only: every visible primitive comes from package:wabisabi.

Widget goldenPaletteSection(BuildContext context) {
  final wab = WabTheme.of(context);
  final colors = <(String, Color)>[
    ('宣紙\nPAPER', WAB_TEXTURE_PAPER_BASE_LIGHT),
    ('霧灰\nMIST', WabiSabiColors.mist),
    ('枯木\nDEADWOOD', WabiSabiColors.deadwood),
    ('墨\nINK', WabiSabiColors.ink),
    ('青瓷\nJADE', WAB_TEXTURE_JADE_BASE_LIGHT),
    ('黏土\nCLAY', WabiSabiColors.clay),
    ('竹青\nBAMBOO', WabiSabiColors.moss),
    ('靛灰\nINDIGO', WAB_TEXTURE_CLOTH_BASE_LIGHT),
    ('秋褐\nRUST', WabiSabiColors.soil),
    ('朱砂\nSEAL', WAB_TEXTURE_CINNABAR_BASE_LIGHT),
  ];
  Widget chip((String, Color) c) => SizedBox(
        width: 66,
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.$2,
                border: Border.all(color: wab.lineColor),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              c.$1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: wab.mutedColor,
                fontFamily: kWabMonoFamily,
                fontSize: WabType.gloss,
                height: 1.1,
              ),
            ),
          ],
        ),
      );
  return Column(
    children: [
      Wrap(spacing: 8, runSpacing: 6, children: colors.map(chip).toList()),
      const SizedBox(height: 6),
      Row(
        children: [
          Text('墨階', style: TextStyle(color: wab.mutedColor, fontSize: WabType.gloss)),
          const SizedBox(width: 8),
          for (var i = 0; i < 7; i++) ...[
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(WAB_TEXTURE_PAPER_BASE_LIGHT, WabiSabiColors.ink, i / 6),
                border: Border.all(color: wab.lineColor),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
    ],
  );
}

Widget goldenTypographySection(BuildContext context) {
  final wab = WabTheme.of(context);
  Widget spec(String glyph, String label, String family, String sample) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(glyph, style: TextStyle(color: wab.textColor, fontFamily: family, fontSize: WabType.brand, fontWeight: FontWeight.w500, height: 1)),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss, letterSpacing: .6)),
            const SizedBox(height: 6),
            Text(sample, style: TextStyle(color: wab.textColor, fontFamily: family, fontSize: WabType.gloss, height: 1.3)),
          ],
        ),
      );
  const ladder = <(String, double)>[
    ('gloss', WabType.gloss),
    ('body', WabType.body),
    ('label', WabType.label),
    ('title', WabType.title),
    ('display', WabType.display),
    ('hero', WabType.hero),
    ('brand', WabType.brand),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spec('文', '正 文  SERIF', kWabKaiFamily, '天地有大美\n而不言'),
          const SizedBox(width: 10),
          spec('筆', '展示  DISPLAY', kWabDisplayFamily, '天地有大美\n而不言'),
          const SizedBox(width: 10),
          spec('器', '等寬  MONO', kWabMonoFamily, '0123456789\nWabisabi()'),
        ],
      ),
      const SizedBox(height: 9),
      Text(
        'WabType · 級 LADDER · φ^⅓',
        style: TextStyle(
          color: wab.mutedColor,
          fontFamily: kWabMonoFamily,
          fontSize: WabType.gloss,
          letterSpacing: .6,
        ),
      ),
      const SizedBox(height: 4),
      Wrap(
        spacing: 9,
        runSpacing: 2,
        children: [
          for (final rung in ladder)
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '永',
                  style: TextStyle(
                    color: wab.textColor,
                    fontFamily: kWabKaiFamily,
                    fontSize: rung.$2,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' ${rung.$1}',
                  style: TextStyle(
                    color: wab.mutedColor,
                    fontFamily: kWabMonoFamily,
                    fontSize: WabType.gloss,
                  ),
                ),
              ]),
            ),
        ],
      ),
    ],
  );
}

Widget goldenRulesSection(BuildContext context) {
  final wab = WabTheme.of(context);
  Widget specimen(WabRuleKind kind, String label) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WabRuleFrame(kind: kind, fill: WAB_TEXTURE_PAPER_BASE_LIGHT, child: const SizedBox(height: 30)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss)),
          ],
        ),
      );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          specimen(WabRuleKind.thin, '細欄 · THIN'),
          const SizedBox(width: 8),
          specimen(WabRuleKind.single, '單欄 · SINGLE'),
          const SizedBox(width: 8),
          specimen(WabRuleKind.double, '雙欄 · DOUBLE'),
        ],
      ),
      const SizedBox(height: 9),
      WabPaperFold(height: 12),
      const SizedBox(height: 3),
      Text('紙摺分隔 · PAPER FOLD', style: TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss)),
      const SizedBox(height: 7),
      WabBrushDivider(),
      const SizedBox(height: 3),
      Row(
        children: [
          Text('筆觸分隔 · BRUSH', style: TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss)),
          const Spacer(),
          WabDotGrid<int>(
            rows: 1,
            cols: 9,
            states: List.generate(9, (i) => i),
            styleOf: (s) => WabInkDotStyle(color: s == 4 ? wab.textColor : wab.mutedColor.withValues(alpha: .5)),
            dotSize: 5,
            gap: 7,
          ),
        ],
      ),
    ],
  );
}

Widget goldenButtonsSection(BuildContext context) {
  final wab = WabTheme.of(context);
  final items = <(String, String, WabMaterialKind)>[
    ('次 之', '紙 · PAPER', WabMaterialKind.paper),
    ('木 牌', '木 · WOOD', WabMaterialKind.wood),
    ('布 札', '布 · CLOTH', WabMaterialKind.cloth),
    ('玉 扣', '玉 · JADE', WabMaterialKind.jade),
    ('白 文', '白文 · BAIWEN', WabMaterialKind.baiwen),
    ('朱 文', '朱文 · ZHUWEN', WabMaterialKind.zhuwen),
  ];
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final item in items)
        SizedBox(
          width: 88,
          child: Column(
            children: [
              WabButton(
                kind: item.$3,
                onPressed: () {},
                expand: true,
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                child: item.$3 == WabMaterialKind.baiwen
                    ? WabSealText(item.$1, fontSize: WabType.title, color: wab.paperWhite, strokeWidth: .7)
                    : item.$3 == WabMaterialKind.zhuwen
                        ? WabSealText(item.$1, fontSize: WabType.title, color: wab.sealColor, strokeWidth: .7)
                        : Text(item.$1),
              ),
              const SizedBox(height: 3),
              Text(item.$2, style: TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss)),
            ],
          ),
        ),
      SizedBox(
        width: 88,
        child: Column(
          children: [
            WabSealButton(label: '落 印', onPressed: () {}, expand: true, fontSize: WabType.title),
            const SizedBox(height: 3),
            Text('印章 · SEAL', style: TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss)),
          ],
        ),
      ),
    ],
  );
}

Widget goldenStatesSection(BuildContext context, {required bool toggle, required VoidCallback onToggle}) {
  final wab = WabTheme.of(context);
  const states = [
    ('Default', WabButtonVisualState.normal),
    ('Hover', WabButtonVisualState.hover),
    ('Pressed', WabButtonVisualState.pressed),
    ('Disabled', WabButtonVisualState.disabled),
  ];
  const kinds = [WabMaterialKind.paper, WabMaterialKind.wood, WabMaterialKind.cloth];
  const labels = ['紙 鈕', '木 牌', '布 札'];
  return Column(
    children: [
      for (final state in states)
        Padding(
          // no trailing gap under the last row; the cell has no slack for it
          padding: EdgeInsets.only(bottom: state == states.last ? 0 : 6),
          child: Row(
            children: [
              SizedBox(width: 62, child: Text(state.$1, style: TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss))),
              for (var i = 0; i < kinds.length; i++) ...[
                Expanded(
                  child: WabButton(
                    kind: kinds[i],
                    state: state.$2,
                    onPressed: state.$2 == WabButtonVisualState.disabled ? null : () {},
                    expand: true,
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                    child: Text(labels[i]),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
      const Spacer(),
      WabToggleButton(
        text: Text(toggle ? 'ON · 玉印' : 'OFF · 玉印'),
        isOn: toggle,
        pair: WabTogglePair.jadeBaiwen,
        callback: onToggle,
      ),
    ],
  );
}

Widget goldenInputsSection(BuildContext context, {
  required bool check,
  required int radio,
  required bool switchValue,
  required double slider,
  required ValueChanged<bool?> onCheck,
  required ValueChanged<int?> onRadio,
  required ValueChanged<bool> onSwitch,
  required ValueChanged<double> onSlider,
}) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: WabTextFormField(hintText: '輸入文字…')),
          const SizedBox(width: 8),
          Expanded(child: WabSearchField(hintText: '搜尋…')),
        ],
      ),
      const SizedBox(height: 7),
      const WabMultilineField(hintText: '多行輸入…', minLines: 2, maxLines: 2),
      const SizedBox(height: 6),
      Row(
        children: [
          WabCheckbox(value: check, label: '複選', onChanged: onCheck),
          const SizedBox(width: 5),
          WabRadio<int>(value: 1, groupValue: radio, label: '單選', onChanged: onRadio),
          const Spacer(),
          WabSwitch(value: switchValue, label: switchValue ? '開' : '關', onChanged: onSwitch),
        ],
      ),
      const SizedBox(height: 5),
      WabSlider(value: slider, onChanged: onSlider),
    ],
  );
}

Widget goldenMarksSection(BuildContext context) {
  final wab = WabTheme.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          WabStatusBadge('Default'),
          WabStatusBadge('Primary', kind: WabBadgeKind.primary),
          WabStatusBadge('Success', kind: WabBadgeKind.success),
          WabStatusBadge('Warning', kind: WabBadgeKind.warning),
          WabStatusBadge('Error', kind: WabBadgeKind.error),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WabSealMark(text: '侘寂', size: 48, seed: 3),
          const SizedBox(width: 8),
          WabSealMark(text: '留白', kind: WabSealMarkKind.zhuwen, size: 48, seed: 9),
          const SizedBox(width: 10),
          WabVerticalTag(text: '題簽'),
          const SizedBox(width: 6),
          WabVerticalTag(text: '編目'),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const WabStarRating(rating: 4),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final color in [WAB_TEXTURE_CINNABAR_BASE_LIGHT, wab.accentColor, wab.mutedColor, wab.offColor]) ...[
                    WabInkDot(style: WabInkDotStyle(color: color), size: 7),
                    const SizedBox(width: 5),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 9),
      WabNotice(title: '通知標題', message: '這是一條溫和的內容示例。', onDismiss: () {}),
    ],
  );
}

Widget goldenCardsSection(BuildContext context) {
  final wab = WabTheme.of(context);
  final card = WabCollectionCard(
    icon: Icon(Icons.auto_awesome_outlined, color: wab.textColor, size: 22),
    title: '基礎卡片',
    description: '題名、內容與動作保持克制。',
    buttonLabel: '落 款',
    onPressed: () {},
  );
  final panel = WabPanel(
    title: '面板標題',
    trailing: const WabStatusBadge('PANEL'),
    child: Text('無外框紙面；內部分隔仍使用淡墨細線。', style: TextStyle(color: wab.mutedColor, fontSize: WabType.gloss)),
  );
  final container = WabContentContainer(
    padding: const EdgeInsets.all(11),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('內容區塊', style: TextStyle(color: wab.textColor, fontWeight: FontWeight.w500, fontSize: WabType.gloss)),
        const SizedBox(height: 8),
        Text('WabContent\u200BContainer\n只負責內容邊界，不憑空製造 elevation。', style: TextStyle(color: wab.mutedColor, fontSize: WabType.gloss, height: 1.4)),
      ],
    ),
  );

  // Three across needs a full cell. A cell reflowed to a phone's width puts the
  // container under the other two and scrolls, as the longer sections do.
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 400) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: card),
            const SizedBox(width: 9),
            Expanded(child: panel),
            const SizedBox(width: 9),
            Expanded(child: container),
          ],
        );
      }
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: card),
                const SizedBox(width: 9),
                Expanded(child: panel),
              ],
            ),
            const SizedBox(height: 9),
            container,
          ],
        ),
      );
    },
  );
}

Widget goldenShadowsSection(BuildContext context) {
  final wab = WabTheme.of(context);
  final caption = TextStyle(color: wab.mutedColor, fontFamily: kWabMonoFamily, fontSize: WabType.gloss);
  // The lift paints outside its child, so every tile keeps room to its lower
  // right for the furthest reach on show.
  Widget tile(String label, Widget lift, {bool keepsRoom = false}) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            keepsRoom ? lift : Padding(padding: const EdgeInsets.only(right: 16, bottom: 16), child: lift),
            Text(label, style: caption),
          ],
        ),
      );
  Widget surface(WabSurfaceKind kind) =>
      SizedBox(height: 36, child: WabSurface(kind: kind, child: const SizedBox.expand()));
  const gap = SizedBox(width: 8);

  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tile('紙 · WabLift()', WabLift(child: surface(WabSurfaceKind.paper))),
          gap,
          tile('木 · .wood', WabLift.wood(child: surface(WabSurfaceKind.woodGrain))),
          gap,
          tile('玉 · .jade', WabLift.jade(child: surface(WabSurfaceKind.jadeSheen))),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tile('reach: .5', WabLift(reach: .5, child: surface(WabSurfaceKind.paper))),
          gap,
          tile('strength: 2', WabLift(strength: 2, child: surface(WabSurfaceKind.paper))),
          gap,
          // WabPaperLift is a lift of that reach with the room for it kept.
          tile('WabPaperLift\u200B(depth: 13)', WabPaperLift(depth: 13, child: surface(WabSurfaceKind.paper)), keepsRoom: true),
        ],
      ),
    ],
  );
}

Widget goldenLightDarkSection(BuildContext context, {required bool isDark, required VoidCallback onToggle}) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 78,
              child: WabSurface(
                kind: WabSurfaceKind.paper,
                isDark: false,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('日：宣紙\nLIGHT THEME', style: TextStyle(color: WAB_LIGHT_TEXT, fontFamily: kWabMonoFamily, fontSize: WabType.gloss)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 78,
              child: WabSurface(
                kind: WabSurfaceKind.rubbing,
                isDark: true,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('夜：拓片\nDARK THEME', style: TextStyle(color: WAB_DARK_TEXT, fontFamily: kWabMonoFamily, fontSize: WabType.gloss)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      const Spacer(),
      WabTextButton(
        text: Text(isDark ? '切換至宣紙 · LIGHT' : '切換至拓片 · DARK'),
        callback: onToggle,
        padding: 9,
      ),
    ],
  );
}
