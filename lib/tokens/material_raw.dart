// Raw material parameters — no Flutter dependency.
// material.dart wraps the color values in Color() for Flutter use.
// These feed the lib/materials/ painters (deckle edge, rule frames, the
// ambient page ground and the brush divider).
//
// The wood / cloth / jade / paper-mottle / ink-wash parameters that used to
// live here described the pre-golden1 painters and were replaced wholesale by
// texture_raw.dart. They are gone; if you are looking for a material colour,
// it is there.

// ---- 毛邊 deckle edge -------------------------------------------------
const double kDeckleRoughness = 2.0; // vertical-edge wobble amplitude px
const double kDeckleRoughnessPaper = 2.2; // paper panels — torn-edge feel
const double kDeckleRoughnessMetric = 1.8; // metric panels — calmer edge
const double kDeckleRoughnessH = 0.7; // horizontal edges — much calmer
const int kDeckleSeed = 42; // generic noise seed
const int kDeckleSeedPaper = 7; // paper panel noise seed
const int kDeckleSeedMetric = 21; // metric panel noise seed
const double kDeckleSideWidth = 1.2; // ink line width px
// Noise frequencies — looser than the RAG prototype (fewer waves per edge).
const double kDeckleFreq1 = 6.1;
const double kDeckleFreq2 = 17.3;
const double kDeckleFreq3 = 41.9;

// ---- 印色 seal ink ----------------------------------------------------
const int kSealText = 0xFFFAF6EC; // paper-white text on seal red

// ---- 紙紋 paper texture -----------------------------------------------
const int kPaperTextureSeed = 99; // fixed seed — rebuild-stable

// ---- 邊欄 rule frame（古籍版式）-------------------------------------------
// 單欄 single: 茶經封面式——一條單粗墨線，直邊方角。
// 雙欄 double: 外粗內細——外線粗、內線細，中間留隙。
// 細線只用於框內文字分隔（kRuleHairline），不作外框。
const double kRuleSingleWidth = 2.6; // 單欄（單粗）線寬 px
const double kRuleOuterWidth = 2.6; // 雙欄外線寬 px（粗）
const double kRuleGap = 3.5; // 雙欄內外線間隙 px
const double kRuleInnerWidth = 0.8; // 雙欄內線寬 px（細）
const double kRuleOpacityLight = 0.85; // frame ink alpha, light
const double kRuleOpacityDark = 0.6; // frame ink alpha, dark
const double kRuleHairline = 0.6; // 框內文字分隔細線 px

// ---- 印章鈕 stele seals -----------------------------------------------
// 朱文 zhuwen — 細框陽文：透明底，細墨框+墨字。
const double kZhuwenRuleWidth = 1.2; // 朱文細框 px

// ---- 環境背景 ambient page ground（scaffold WabTexturePainter）-----------------
// Light washi: 去黃走灰褐，暗光；dark lacquer 維持燭光金。
const int kWashiCloudWarm = 0x07887A60; // warm cloud, muted taupe (was A07040)
const int kWashiCloudCool = 0x04808A8C; // cool cloud, faint blue-grey
const int kWashiFiber = 0xFF847866; // fiber thread base (grey hemp, 不黃)
const int kWashiGrain = 0x0F8A7C62; // micro-dot grain (muted)
const int kLacquerVignette = 0x18000000; // corner vignette, dark
const int kLacquerPatch = 0x06C8A84A; // warm amber patch, dark
const int kLacquerGrain = 0x09C8A84A; // fine grain, dark

// ---- 筆觸線 brush divider -------------------------------------------------
const double kBrushStrokeWidth1 = 2.4; // main stroke width px
const double kBrushStrokeOpacity1 = 0.9; // main stroke alpha
const double kBrushStrokeWidth2 = 1.0; // echo stroke width px
const double kBrushStrokeOpacity2 = 0.4; // echo stroke alpha
const double kBrushStrokeY1 = 5.0; // main stroke baseline y
const double kBrushStrokeY2 = 8.5; // echo stroke baseline y
