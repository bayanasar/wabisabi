import 'package:flutter/material.dart';
import 'palette_raw.dart';

/// Wabi-Sabi color palette for Flutter. Source of truth is palette_raw.dart.
/// Theme files map these into ThemeData; components never reference this directly.
class WabiSabiColors {
  // Earthen tones
  static const clay = Color(kClay);
  static const stone = Color(kStone);
  static const bamboo = Color(kBamboo);
  static const elm = Color(kElm);

  // Natural accents
  static const moss = Color(kMoss);
  static const rust = Color(kRust);
  static const indigoDye = Color(kIndigoDye);
  static const pebble = Color(kPebble);

  // Neutral foundations
  static const rice = Color(kRice);
  static const ash = Color(kAsh);
  static const charcoal = Color(kCharcoal);
  static const soil = Color(kSoil);

  // Seasonal accents
  static const sakura = Color(kSakura);
  static const maple = Color(kMaple);
  static const persimmon = Color(kPersimmon);
  static const tea = Color(kTea);

  // Surface variations
  static const paper = Color(kPaper);
  static const cedar = Color(kCedar);
  static const ceramic = Color(kCeramic);
  static const sand = Color(kSand);

  // Flat "washi" set (paper-like, flat consumers)
  static const washi = Color(kWashi);
  static const mist = Color(kMist);
  static const deadwood = Color(kDeadwood);
  static const ink = Color(kInk);
  static const frost = Color(kFrost);

  // Supplementary operational colors (theme-independent)
  static const paperWhite = Color(kPaperWhite);
  static const mutedLight = Color(kMutedLight);
}

// Operational light theme palette
const Color WAB_LIGHT_BACKGROUND = Color(kLightBackground);
const Color WAB_LIGHT_SURFACE = Color(kLightSurface);
const Color WAB_LIGHT_PRIMARY = Color(kLightPrimary);
const Color WAB_LIGHT_SECONDARY = Color(kLightSecondary);
const Color WAB_LIGHT_ACCENT = Color(kLightAccent);
const Color WAB_LIGHT_MUTED = Color(kLightMuted);
const Color WAB_LIGHT_ON = Color(kLightOn);
const Color WAB_LIGHT_OFF = Color(kLightOff);
const Color WAB_LIGHT_TEXT = Color(kLightText);
const Color WAB_LIGHT_WOODY = Color(kLightWoody);
const Color WAB_LIGHT_SCRATCH = Color(kLightScratch);
const Color WAB_LIGHT_PROGRESS = Color(kLightProgress);
const Color WAB_LIGHT_SEAL = Color(kSealLight);
const Color WAB_LIGHT_LINE = Color(kLineLight);

// Operational dark theme palette
const Color WAB_DARK_BACKGROUND = Color(kDarkBackground);
const Color WAB_DARK_SURFACE = Color(kDarkSurface);
const Color WAB_DARK_PRIMARY = Color(kDarkPrimary);
const Color WAB_DARK_SECONDARY = Color(kDarkSecondary);
const Color WAB_DARK_ACCENT = Color(kDarkAccent);
const Color WAB_DARK_MUTED = Color(kDarkMuted);
const Color WAB_DARK_ON = Color(kDarkOn);
const Color WAB_DARK_OFF = Color(kDarkOff);
const Color WAB_DARK_TEXT = Color(kDarkText);
const Color WAB_DARK_WOODY = Color(kDarkWoody);
const Color WAB_DARK_SCRATCH = Color(kDarkScratch);
const Color WAB_DARK_PROGRESS = Color(kDarkProgress);
const Color WAB_DARK_SEAL = Color(kSealDark);
const Color WAB_DARK_LINE = Color(kLineDark);
const Color WAB_DARK_PAPER = Color(kDarkPaper);
