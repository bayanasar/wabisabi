import 'package:flutter/material.dart';
import 'package:wabisabi/wabisabi.dart';

// Specimens for the parts of the kit the golden1 board never drew.
// Composition only: every visible primitive comes from package:wabisabi.
//
// tool/check_public_api.dart fails when a type is exported from the barrel and
// never appears here, so this file is where a new export earns its place.

TextStyle _caption(WabColors wab) => TextStyle(
      color: wab.mutedColor,
      fontFamily: kWabMonoFamily,
      fontSize: WabType.gloss,
      height: 1.2,
    );

Widget _specimen(
  WabColors wab,
  String label,
  double width,
  double height,
  Widget child,
) =>
    SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: width, height: height, child: child),
          const SizedBox(height: 3),
          Text(_breakCamelCase(label), style: _caption(wab)),
        ],
      ),
    );

final _camelHump = RegExp(r'(?<=[a-z])(?=[A-Z])');

/// Lets a class name wrap between its words — WabPaper·Texture — instead of
/// wherever the box runs out.
String _breakCamelCase(String label) => label.replaceAll(_camelHump, '\u200B');

/// 骨架 — page chrome: scaffolds, bars, legacy containers, nav furniture.
Widget kitChromeSection(BuildContext context) {
  final wab = WabTheme.of(context);
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 9,
          runSpacing: 8,
          children: [
            _specimen(
              wab,
              'WabScaffold',
              150,
              76,
              WabScaffold(
                title: const Text('卷 一', style: TextStyle(fontSize: WabType.gloss)),
                body: Center(
                  child: Text('body', style: _caption(wab)),
                ),
              ),
            ),
            _specimen(
              wab,
              'WabTexturedScaffold',
              150,
              76,
              WabTexturedScaffold(
                title: const Text('卷 二', style: TextStyle(fontSize: WabType.gloss)),
                body: Center(
                  child: Text('ambient ground', style: _caption(wab)),
                ),
              ),
            ),
            _specimen(
              wab,
              'WabAppBar',
              150,
              52,
              WabAppBar(
                title: const Text('題 名', style: TextStyle(fontSize: WabType.gloss)),
                action: const Icon(Icons.more_horiz, size: 15),
              ),
            ),
            _specimen(
              wab,
              'WabTexturePainter\n(scaffold ground)',
              100,
              52,
              CustomPaint(
                painter: WabTexturePainter(isDark: wab.isDark),
                child: const SizedBox.expand(),
              ),
            ),
            _specimen(
              wab,
              'WabContainer',
              128,
              46,
              WabContainer(child: Text('框 · framed', style: _caption(wab))),
            ),
            _specimen(
              wab,
              'WabLiteContainer',
              128,
              46,
              WabLiteContainer(child: Text('輕框 · lite', style: _caption(wab))),
            ),
            _specimen(
              wab,
              'WabProfileHeader',
              168,
              50,
              const WabProfileHeader(
                name: '陸 羽',
                subtitle: '茶經 · 卷上',
                avatar: AssetImage('images/avatar.jpg'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Text('WabColors · WabTheme.of(context)', style: _caption(wab)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            for (final swatch in <(String, Color)>[
              ('background', wab.backgroundColor),
              ('surface', wab.surfaceColor),
              ('primary', wab.primaryColor),
              ('accent', wab.accentColor),
              ('text', wab.textColor),
              ('muted', wab.mutedColor),
              ('line', wab.lineColor),
              ('seal', wab.sealColor),
              ('scratch', wab.scratchColor),
              ('woody', wab.woodyColor),
              ('progress', wab.progressColor),
              ('on', wab.onColor),
            ])
              SizedBox(
                width: 52,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: swatch.$2,
                        border: Border.all(color: wab.lineColor),
                      ),
                    ),
                    Text(swatch.$1, style: _caption(wab)),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 9),
        SizedBox(
          height: 82,
          child: WabBanner(
            title: '侘 寂',
            subtitle: 'WABBANNER · MASTHEAD',
            height: 82,
            leading: WabSealMark(text: '侘', size: 22, seed: 31),
            trailing: [
              WabStatusBadge('WabBanner', kind: WabBadgeKind.neutral),
            ],
          ),
        ),
      ],
    ),
  );
}

/// 材 — one swatch per material, drawn by the painter that makes it.
///
/// This is the whole material vocabulary in one place. WabSurface wraps these
/// into named kinds; the caption gives the primitive so it is clear what a
/// surface is actually made of.
Widget kitMaterialsSection(BuildContext context) {
  const w = 78.0;
  const h = 42.0;
  final wab = WabTheme.of(context);
  final dark = wab.isDark;
  final paper =
      dark ? WAB_TEXTURE_PAPER_BASE_DARK : WAB_TEXTURE_PAPER_BASE_LIGHT;

  Widget onPaper(Widget child) => ColoredBox(color: paper, child: child);

  return SingleChildScrollView(
    child: Wrap(
      spacing: 8,
      runSpacing: 7,
      children: [
        _specimen(wab, '宣紙\nWabPaperTexture', w, h,
            onPaper(WabPaperTexture(child: const SizedBox.expand()))),
        _specimen(wab, '雲斑\nWabPaperTextureKind', w, h,
            onPaper(WabPaperTexture(
              kind: WabPaperTextureKind.mottle,
              child: const SizedBox.expand(),
            ))),
        _specimen(wab, '纖紙\nWabFiberTexture', w, h,
            onPaper(
                WabFiberTexture(strength: 1, child: const SizedBox.expand()))),
        _specimen(wab, '木紋\nWabWoodGrain', w, h,
            CustomPaint(
              painter: WabWoodGrain(isDark: dark),
              child: const SizedBox.expand(),
            )),
        _specimen(wab, '木板\nWabWoodSlab', w, h,
            WabWoodSlab(radius: 3, child: const SizedBox.expand())),
        _specimen(wab, '布紋\nWabClothTexture', w, h,
            WabClothTexture(child: const SizedBox.expand())),
        _specimen(wab, '織紋\nWabClothWeave', w, h,
            CustomPaint(
              painter: WabClothWeave(isDark: dark),
              child: const SizedBox.expand(),
            )),
        _specimen(wab, '玉面\nWabJadeTexture', w, h,
            WabJadeTexture(child: const SizedBox.expand())),
        _specimen(wab, '硃砂\nWabCinnabarTexture', w, h,
            WabCinnabarTexture(child: const SizedBox.expand())),
        _specimen(wab, '舊化\nWabPatinaTexture', w, h,
            WabPatinaTexture(child: const SizedBox.expand())),
        _specimen(wab, '拓片\nWabRubbingTexture', w, h,
            const WabRubbingTexture(child: SizedBox.expand())),
        _specimen(wab, '墨暈\nWabInkWash', w, h,
            onPaper(CustomPaint(
              painter: WabInkWash(colors: wab),
              child: const SizedBox.expand(),
            ))),
        _specimen(wab, '毛邊\nWabDeckleSurface', w, h,
            WabDeckleSurface(
              fill: paper,
              texture: WabPaperTexture(),
              child: const SizedBox.expand(),
            )),
        _specimen(wab, '邊形\nDeckleBorder', w, h,
            DecoratedBox(
              decoration: ShapeDecoration(
                color: paper,
                shape: WabDeckleBorder(seed: 61, radius: 2),
              ),
              child: const SizedBox.expand(),
            )),
      ],
    ),
  );
}

/// 零件 — the remaining exported odds and ends, including the two that carry
/// their own state.
class KitOddsAndEndsSection extends StatefulWidget {
  const KitOddsAndEndsSection({super.key});

  @override
  State<KitOddsAndEndsSection> createState() => _KitOddsAndEndsSectionState();
}

class _KitOddsAndEndsSectionState extends State<KitOddsAndEndsSection> {
  String _tea = 'sencha';
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              _specimen(
                wab,
                'WabDropdown',
                132,
                46,
                WabDropdown<String>(
                  value: _tea,
                  items: const {
                    'sencha': '煎 茶',
                    'matcha': '抹 茶',
                    'houjicha': '焙 茶',
                  },
                  onChanged: (v) => setState(() => _tea = v ?? _tea),
                ),
              ),
              _specimen(
                wab,
                'WabNumberFormField',
                110,
                46,
                WabNumberFormField(
                  value: _count,
                  labelText: '盞',
                  callback: (v) =>
                      setState(() => _count = int.tryParse(v) ?? _count),
                ),
              ),
              _specimen(
                wab,
                'WabImage',
                58,
                46,
                const WabImage(
                  path: 'images/avatar.jpg',
                  width: 58,
                  height: 46,
                ),
              ),
              _specimen(
                wab,
                'WabIcon',
                58,
                46,
                const WabIcon(path: 'images/mark.png', height: 46),
              ),
              _specimen(
                wab,
                'WabWarningText',
                110,
                24,
                Align(
                  alignment: Alignment.centerLeft,
                  child: WabWarningText(text: '水 未 沸'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('WabDivider', style: _caption(wab)),
          WabDivider(),
        ],
      ),
    );
  }
}
