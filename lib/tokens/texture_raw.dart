// Raw texture palette — ARGB ints only, no Flutter dependency.
// These values describe physical material appearance rather than semantic UI roles.

const int kTextureFiberLight = 0xFF9F927D;
const int kTextureFiberDark = 0xFF9C9589;

// Physical xuan sheet — warmer/darker than card white.
const int kTexturePaperBaseLight = 0xFFE8E2D7;
const int kTexturePaperBaseDark = 0xFF2A2620;
const int kTexturePaperPulpLight = 0xFFB9AA94;
const int kTexturePaperPulpDark = 0xFF777064;
const int kTexturePaperAgeLight = 0xFF9D8060;
const int kTexturePaperAgeDark = 0xFF544638;
const int kTexturePaperCreaseLight = 0xFFBEB3A0;
const int kTexturePaperHighlightLight = 0xFFFFFCF3;
const int kTexturePaperCreaseDark = 0xFF5F5A50;
const int kTexturePaperHighlightDark = 0xFF39362F;

// 木 — day timber is lifted a quarter of the way to white at its own hue and
// saturation, so it sits lighter on the page without going chalky. Mixing it
// toward the paper instead washed the colour out of it. Night timber keeps its
// value but gives up 40% of its saturation: lamplight on wood, not varnish.
const int kTextureWoodBaseLight = 0xFFC6A782;
const int kTextureWoodDeepLight = 0xFFAF794D;
const int kTextureWoodLightLight = 0xFFDCC39E;
const int kTextureWoodTextLight = 0xFF3A2E1C;  // label ink on light wood
const int kTextureWoodBaseDark = 0xFF43352C;
const int kTextureWoodDeepDark = 0xFF211B17;
const int kTextureWoodLightDark = 0xFF625345;

const int kTextureClothBaseLight = 0xFF314B57;
const int kTextureClothDeepLight = 0xFF182C34;
const int kTextureClothThreadLight = 0xFF91A1A7;
const int kTextureClothBaseDark = 0xFF203740;
const int kTextureClothDeepDark = 0xFF0E2027;
const int kTextureClothThreadDark = 0xFF61757E;

const int kTextureJadeBaseLight = 0xFFA9C1B4;
const int kTextureJadeDeepLight = 0xFF7FA08F;
const int kTextureJadeCloudLight = 0xFFDCE5DE;
const int kTextureJadeVeinLight = 0xFFF0F0E8;
const int kTextureJadeTextLight = 0xFF294438;  // label ink on light jade
const int kTextureJadeBaseDark = 0xFF36584C;
const int kTextureJadeDeepDark = 0xFF1F3931;
const int kTextureJadeCloudDark = 0xFF719084;
const int kTextureJadeVeinDark = 0xFFAFC0B5;

// 墨 — the kit casts no pure-black shadow. This is the rubbing ink, and it
// is what every shadow, bevel and pressed edge is drawn in: pigment, not
// absence. Lifted off 0x000000 so it reads warm against paper.
const int kTextureInk = 0xFF24231F;

// 燈暈 — in the dark the kit casts no shadow, because a shadow on a dark
// ground is invisible. Depth is lamplight instead, in the shape the shadow
// would have had. Sampled from warm ambient light along a trim line at night:
// the falloff's hue (36°), burnt yellower.
const int kTextureLampGlow = 0xFFDEB77C;

const int kTextureRubbingBase = 0xFF24231F;
const int kTextureRubbingDeep = 0xFF10100E;
const int kTextureRubbingDust = 0xFF8A877E;
const int kTextureRubbingFiber = 0xFFD5D0C5;

const int kTexturePatinaBaseLight = 0xFFB28B60;
const int kTexturePatinaDeepLight = 0xFF795A3D;
const int kTexturePatinaLightLight = 0xFFD8C39D;
const int kTexturePatinaBaseDark = 0xFF65492F;
const int kTexturePatinaDeepDark = 0xFF34271E;
const int kTexturePatinaLightDark = 0xFF92704D;

// Muted cinnabar: a mineral red, not orange lacquer.
const int kTextureCinnabarBaseLight = 0xFF96382F;
const int kTextureCinnabarDeepLight = 0xFF67251F;
const int kTextureCinnabarLightLight = 0xFFC06C61;
const int kTextureCinnabarBaseDark = 0xFF9E493C;
const int kTextureCinnabarDeepDark = 0xFF55241F;
const int kTextureCinnabarLightDark = 0xFFC37A6C;

const int kTextureFoldShadowLight = 0x665A5242;
const int kTextureFoldShadowDark = 0x66000000;
