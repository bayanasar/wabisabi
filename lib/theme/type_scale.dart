/// The kit's type ladder — a golden-section scale.
///
/// Every rung is φ^⅓ (≈1.174) above the one below it, so every *third* rung is
/// exactly φ apart: 8.65 → 14 → 22.65. The base is [body] at 14, and the ladder
/// runs three rungs down and five up, which spans everything the kit draws from
/// an interlinear note to the brand mark.
///
/// One step is too fine to read as a size change on its own, which is the
/// point: sizes that sit next to each other differ by a third of a golden
/// section, and sizes that must read as different ranks are a full φ apart.
///
/// Flutter multiplies these by `MediaQuery.textScaler`, so they are the size at
/// a scale factor of 1.
///
/// [gloss] is the reading floor. The two rungs below it are too small for a
/// brush face on a screen — the strokes thin out before the counters close —
/// so nothing a person has to read is set in them. They stay on the ladder,
/// deprecated, so the series is still whole.
abstract final class WabType {
  /// The ratio between adjacent rungs: the cube root of the golden section.
  static const double step = 1.1739849967;

  /// 夾註 — interlinear annotation. `body / φ`. Below the reading floor.
  @Deprecated('Below the reading floor; use WabType.gloss')
  static const double annotation = 8.65;

  /// One rung above [annotation]. Below the reading floor.
  @Deprecated('Below the reading floor; use WabType.gloss')
  static const double caption = 10.16;

  /// 眉批 — the smallest size text is set in: captions, supporting lines,
  /// badge and tag labels, banner subtitles.
  static const double gloss = 11.93;

  /// Body text, and the base the ladder is built from.
  static const double body = 14;

  /// Control and navigation labels.
  static const double label = 16.44;

  /// Section and panel titles.
  static const double title = 19.3;

  /// Display text and seal faces. `body × φ`.
  static const double display = 22.65;

  /// Hero lines on a masthead.
  static const double hero = 26.59;

  /// The brand mark itself. `body × φ^(5/3)`.
  static const double brand = 31.22;
}
