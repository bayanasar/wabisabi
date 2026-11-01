import 'package:flutter/material.dart';
import 'material_raw.dart';
import 'texture.dart';

/// Material parameters for Flutter. Source of truth is material_raw.dart.
/// The materials/ painters consume these; components never reference them
/// directly.

// ---- 毛邊 deckle edge ----
const double WAB_DECKLE_ROUGHNESS = kDeckleRoughness;
const double WAB_DECKLE_ROUGHNESS_PAPER = kDeckleRoughnessPaper;
const double WAB_DECKLE_ROUGHNESS_METRIC = kDeckleRoughnessMetric;
const double WAB_DECKLE_ROUGHNESS_H = kDeckleRoughnessH;
const int WAB_DECKLE_SEED = kDeckleSeed;
const int WAB_DECKLE_SEED_PAPER = kDeckleSeedPaper;
const int WAB_DECKLE_SEED_METRIC = kDeckleSeedMetric;
const double WAB_DECKLE_SIDE_WIDTH = kDeckleSideWidth;
const double WAB_DECKLE_FREQ1 = kDeckleFreq1;
const double WAB_DECKLE_FREQ2 = kDeckleFreq2;
const double WAB_DECKLE_FREQ3 = kDeckleFreq3;

// ---- 印色 seal ink ----
const Color WAB_SEAL_TEXT = Color(kSealText);

/// Ink for a label sitting on light wood.
@Deprecated('Renamed to WAB_TEXTURE_WOOD_TEXT_LIGHT with the rest of the '
    'material palette. This alias will go at the next major version.')
const Color WAB_WOOD_TEXT_LIGHT = WAB_TEXTURE_WOOD_TEXT_LIGHT;

// ---- 紙紋 paper texture ----
const int WAB_PAPER_TEXTURE_SEED = kPaperTextureSeed;

// ---- 邊欄 rule frame ----
const double WAB_RULE_SINGLE_WIDTH = kRuleSingleWidth;
const double WAB_RULE_OUTER_WIDTH = kRuleOuterWidth;
const double WAB_RULE_GAP = kRuleGap;
const double WAB_RULE_INNER_WIDTH = kRuleInnerWidth;
const double WAB_RULE_OPACITY_LIGHT = kRuleOpacityLight;
const double WAB_RULE_OPACITY_DARK = kRuleOpacityDark;
const double WAB_RULE_HAIRLINE = kRuleHairline;

// ---- 印章鈕 stele seals ----
const double WAB_ZHUWEN_RULE_WIDTH = kZhuwenRuleWidth;

// ---- 環境背景 ambient page ground ----
const Color WAB_WASHI_CLOUD_WARM = Color(kWashiCloudWarm);
const Color WAB_WASHI_CLOUD_COOL = Color(kWashiCloudCool);
const Color WAB_WASHI_FIBER = Color(kWashiFiber);
const Color WAB_WASHI_GRAIN = Color(kWashiGrain);
const Color WAB_LACQUER_VIGNETTE = Color(kLacquerVignette);
const Color WAB_LACQUER_PATCH = Color(kLacquerPatch);
const Color WAB_LACQUER_GRAIN = Color(kLacquerGrain);

// ---- 筆觸線 brush divider ----
const double WAB_BRUSH_STROKE_WIDTH1 = kBrushStrokeWidth1;
const double WAB_BRUSH_STROKE_OPACITY1 = kBrushStrokeOpacity1;
const double WAB_BRUSH_STROKE_WIDTH2 = kBrushStrokeWidth2;
const double WAB_BRUSH_STROKE_OPACITY2 = kBrushStrokeOpacity2;
const double WAB_BRUSH_STROKE_Y1 = kBrushStrokeY1;
const double WAB_BRUSH_STROKE_Y2 = kBrushStrokeY2;
