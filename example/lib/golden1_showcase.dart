import 'package:flutter/material.dart';
import 'package:wabisabi/wabisabi.dart';

import 'golden1_refinements.dart';
import 'golden1_sections.dart';
import 'kit_coverage_sections.dart';

class Golden1Showcase extends StatefulWidget {
  const Golden1Showcase({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<Golden1Showcase> createState() => _Golden1ShowcaseState();
}

class _Golden1ShowcaseState extends State<Golden1Showcase> {
  final _sectionKeys = List<GlobalKey>.generate(13, (_) => GlobalKey());
  int _selected = 0;
  bool _check = true;
  int _radio = 0;
  bool _switch = true;
  double _slider = .42;
  bool _toggle = true;

  // CI/local builds can override with --dart-define=WAB_BUILD_HASH=<sha>.
  static const _buildHash = String.fromEnvironment(
    'WAB_BUILD_HASH',
    defaultValue: 'e248347',
  );

  static const _nav = [
    '01 色 · PALETTE',
    '02 材 · MATERIALS',
    '03 書 · TYPOGRAPHY',
    '04 邊 · BORDERS & RULES',
    '05 器 · COMPONENTS',
    '06 狀態 · STATES',
    '07 表單 · INPUTS',
    '08 標記 · BADGES & SEALS',
    '09 卡片 · CARDS & PANELS',
    '10 陰影 · SHADOWS',
    '11 明暗 · LIGHT & DARK',
    '12 骨架 · SCAFFOLD & CHROME',
    '13 零件 · ODDS & ENDS',
  ];

  static const _titles = [
    '01  色 | PALETTE',
    '02  材 | MATERIALS',
    '03  書 | TYPOGRAPHY',
    '04  邊 | BORDERS & RULES',
    '05  器 | COMPONENTS · BUTTONS',
    '06  狀態 | STATES',
    '07  表單 | INPUTS',
    '08  標記 | BADGES & SEALS',
    '09  卡片 | CARDS & PANELS',
    '10  陰影 | SHADOWS',
    '11  明暗 | LIGHT & DARK',
    '12  骨架 | SCAFFOLD & CHROME',
    '13  零件 | ODDS & ENDS',
  ];

  static const _subtitles = [
    '調煉紙、墨、木、土、釉的克制色系',
    '生成式材質，一material一筆：WabSurface 即由此組成',
    '標題、正文、數字：統一的文字體系',
    '源自古籍的欄界與紙摺語言',
    '多材質按鈕體系',
    '克制而自然的狀態變化',
    '欄界語言延伸至現代輸入控件',
    '源自印章與題簽的標記語言',
    '內容容器與信息組織',
    '源自實物紙邊的接觸投影',
    '行墨與拓片的雙重世界',
    '頁面骨架、題頭與導覽家具',
    '其餘導出組件，含自持狀態者',
  ];

  /// φ. The board's proportions come from it, as the type ladder does.
  static const _phi = 1.6180339887;

  /// The width one board cell gets on a full-size desktop board. Every section
  /// is composed against it, so the narrow layout renders at the same geometry
  /// and scales the whole cell down rather than re-flowing each specimen.
  static const _cellDesignWidth = 460.0;

  /// Each cell is a golden rectangle — φ wider than it is tall.
  static const _cellDesignHeight = _cellDesignWidth / _phi;

  /// The index rail is one more golden section in from the cell width, so the
  /// rail, a cell and the board all sit on the same series.
  static const _sidebarWidth = _cellDesignWidth / (_phi * _phi);

  /// Below this the sidebar and the three-column board are dropped for a
  /// single scrolling column of cells.
  static const _compactWidth = 900.0;
  static const _boardTop = 10.0;
  static const _boardBottom = 30.0;

  int get _rowCount => (_nav.length / 3).ceil();

  /// A fold at every row boundary, so the sheet creases between cells.
  List<double> get _desktopFolds {
    final total = _boardTop + _boardBottom + _rowCount * _cellDesignHeight;
    return [
      for (var i = 1; i < _rowCount; i++)
        (_boardTop + i * _cellDesignHeight) / total,
    ];
  }

  void _jumpTo(int index) {
    setState(() => _selected = index);
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        alignment: .02,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wab = WabTheme.of(context);
    return WabTypographyScope(
      child: Scaffold(
        backgroundColor: wab.backgroundColor,
        body: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                // The build stamp is the widest thing in the masthead; on a
                // narrow sheet the theme toggle is the only action worth the
                // room it costs.
                final compact = constraints.maxWidth < _compactWidth;
                return WabPaperSheet(
              isDark: wab.isDark,
              horizontalFolds: const [],
              verticalFolds: const [],
              child: WabEditorialBanner(
                brand: '侘 寂',
                kitLabel: 'WABISABI\nUI KIT',
                title: '現代應用的東方美學界面系統',
                subtitle: 'A TIMELESS UI SYSTEM FOR MODERN APPS',
                motto: '取法自然 · 材質為語 · 克制為美 · 留白生境',
                seal: WabSealMark(text: '侘寂', size: 25, seed: 17),
                trailing: [
                  if (!compact) ...[
                    Text(
                      'v0.2 · BUILD $_buildHash\nLESS, BUT DEEPER.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: wab.mutedColor,
                        fontFamily: kWabMonoFamily,
                        fontSize: WabType.gloss,
                        letterSpacing: 1.45,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  WabIconButton(
                    icon: Icon(
                      wab.isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: 15,
                    ),
                    kind: WabMaterialKind.zhuwen,
                    callback: widget.onToggleTheme,
                  ),
                ],
              ),
                );
              },
            ),
            Divider(
              height: 1,
              thickness: WAB_RULE_HAIRLINE,
              color: wab.lineColor,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // A large text preference needs the room a single column has,
                  // so it counts against the width when choosing a layout.
                  if (constraints.maxWidth / _textScale(context) <
                      _compactWidth) {
                    return _mobileBoard();
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sidebar(context),
                      VerticalDivider(
                        width: 1,
                        thickness: WAB_RULE_HAIRLINE,
                        color: wab.lineColor,
                      ),
                      Expanded(child: _board(context)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebar(BuildContext context) {
    final wab = WabTheme.of(context);
    return WabPaperSheet(
      isDark: wab.isDark,
      horizontalFolds: const [],
      verticalFolds: const [],
      child: WabSidebar(
        width: _sidebarWidth,
        padding: const EdgeInsets.fromLTRB(15, 18, 15, 18),
        children: [
          Text(
            '素 材 庫',
            style: TextStyle(
              color: wab.textColor,
              fontFamily: kWabDisplayFamily,
              fontSize: WabType.label,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'MATERIAL INDEX · v0.2',
            style: TextStyle(
              color: wab.mutedColor,
              fontFamily: kWabMonoFamily,
              fontSize: WabType.gloss,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _nav.length; i++)
            Opacity(
              opacity: _selected == i ? 1 : .63,
              child: WabTextButton(
                text: Text(
                  _nav[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: kWabMonoFamily,
                    fontSize: WabType.gloss,
                    fontWeight:
                        _selected == i ? FontWeight.w500 : FontWeight.w400,
                    letterSpacing: .8,
                  ),
                ),
                callback: () => _jumpTo(i),
                mergeTop: i != 0,
                padding: 9,
              ),
            ),
          const Spacer(),
          Text(
            'LESS, BUT DEEPER.',
            style: TextStyle(
              color: wab.mutedColor,
              fontFamily: kWabMonoFamily,
              fontSize: WabType.gloss,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _board(BuildContext context) {
    final wab = WabTheme.of(context);
    return SingleChildScrollView(
          child: WabPaperSheet(
            isDark: wab.isDark,
            horizontalFolds: _desktopFolds,
            verticalFolds: const [.333333, .666667],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, _boardTop, 16, _boardBottom),
              child: Column(
                children: [
                  for (var row = 0; row < _rowCount; row++)
                    _row([
                      for (var slot = 0; slot < 3; slot++)
                        if (row * 3 + slot < _nav.length) row * 3 + slot,
                    ]),
                ],
              ),
            ),
          ),
        );
  }

  /// Narrow layout: one column of cells, each drawn at [_cellDesignWidth] and
  /// scaled to the sheet. The sections were composed for a fixed cell — they
  /// use Expanded and Spacer against a known box — so scaling the finished cell
  /// keeps the composition intact where re-flowing it would not.
  ///
  /// Past native size it only magnifies as far as the viewer asked for with
  /// their text-size setting, and only as far as the sheet has room for.
  Widget _mobileBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wab = WabTheme.of(context);
        const sheetPadding = 14.0;
        final available = constraints.maxWidth - sheetPadding * 2;
        final fit = available / _cellDesignWidth;
        final scale =
            (fit.clamp(.4, 1.0) * _textScale(context)).clamp(.4, fit).toDouble();

        return SingleChildScrollView(
          child: WabPaperSheet(
            isDark: wab.isDark,
            horizontalFolds: const [],
            verticalFolds: const [],
            child: Padding(
              padding: const EdgeInsets.all(sheetPadding),
              child: Column(
                children: [
                  for (var i = 0; i < _nav.length; i++) ...[
                    _scaledCell(context, i, scale),
                    const SizedBox(height: 18),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _scaledCell(BuildContext context, int index, double scale) {
    const height = _cellDesignHeight;
    return SizedBox(
      width: _cellDesignWidth * scale,
      height: height * scale,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: _cell(
          width: _cellDesignWidth,
          height: height,
          child: _section(context, index),
        ),
      ),
    );
  }

  /// A cell at exact design geometry.
  ///
  /// The sections are composed against a fixed box — Expanded and Spacer
  /// against a known height — so the viewer's text-size setting must not be
  /// allowed to grow type inside one; it would clip, silently, in release. The
  /// setting is honoured by magnifying the whole cell instead (see
  /// [_textScale]), which grows the type and everything holding it together.
  Widget _cell({
    required double width,
    required double height,
    required Widget child,
  }) =>
      MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: SizedBox(width: width, height: height, child: child),
      );

  /// The viewer's text-size preference as a plain multiplier.
  double _textScale(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(WabType.body) / WabType.body;

  Widget _row(List<int> indices) {
    return SizedBox(
      height: _cellDesignHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var slot = 0; slot < 3; slot++)
            if (slot >= indices.length)
              const Expanded(child: SizedBox.shrink())
            else
              Expanded(
              child: ClipRect(
                child: Transform.scale(
                  scaleX: 1.002,
                  scaleY: 1.002,
                  alignment: Alignment.topLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: _cell(
                      width: _cellDesignWidth,
                      height: _cellDesignHeight,
                      child: _section(context, indices[slot]),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, int index) {
    final wab = WabTheme.of(context);
    final content = switch (index) {
      0 => goldenPaletteSection(context),
      1 => kitMaterialsSection(context),
      2 => goldenTypographySection(context),
      3 => refinedRulesSection(context),
      4 => refinedButtonsSection(context),
      5 => goldenStatesSection(
          context,
          toggle: _toggle,
          onToggle: () => setState(() => _toggle = !_toggle),
        ),
      6 => goldenInputsSection(
          context,
          check: _check,
          radio: _radio,
          switchValue: _switch,
          slider: _slider,
          onCheck: (v) => setState(() => _check = v ?? false),
          onRadio: (v) => setState(() => _radio = v ?? 0),
          onSwitch: (v) => setState(() => _switch = v),
          onSlider: (v) => setState(() => _slider = v),
        ),
      7 => goldenMarksSection(context),
      8 => goldenCardsSection(context),
      9 => goldenShadowsSection(context),
      10 => goldenLightDarkSection(
          context,
          isDark: wab.isDark,
          onToggle: widget.onToggleTheme,
        ),
      11 => kitChromeSection(context),
      _ => const KitOddsAndEndsSection(),
    };

    return KeyedSubtree(
      key: _sectionKeys[index],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titles[index],
              style: TextStyle(
                color: wab.textColor,
                fontFamily: kWabKaiFamily,
                fontSize: WabType.body,
                fontWeight: FontWeight.w500,
                letterSpacing: .7,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _subtitles[index],
              style: TextStyle(
                color: wab.mutedColor,
                fontFamily: kWabKaiFamily,
                fontSize: WabType.gloss,
                letterSpacing: .4,
              ),
            ),
            const SizedBox(height: 7),
            Divider(
              height: 1,
              thickness: WAB_RULE_HAIRLINE,
              color: wab.lineColor.withValues(alpha: .55),
            ),
            const SizedBox(height: 10),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
