import 'package:flutter/material.dart';

class AppColors {
  // --- CORE COSMIC PALETTE (Premium Dark Theme) ---
  static const Color cosmicInk = Color(0xFF08111F);
  static const Color twilightPlum = Color(0xFF4D4177);
  static const Color deepSky = Color(0xFF3A60A0);
  static const Color milkyGlow = Color(0xFFC8DDF5);
  static const Color neonBlue = Color(0xFF59CFFF);

  // --- DARK MODE ALIASES ---
  static const Color bg = cosmicInk;
  static const Color bg2 = Color(0xFF141E46);
  static const Color bg3 = Color(0xFF1B2755);

  static const Color card = Color(0xFF0A1230);
  static const Color card2 = Color(0xFF0E1A3A);
  static const Color cardBg = Color(0x331A2D6B);

  static const Color cyan = neonBlue;
  static const Color cyan2 = deepSky;
  static const Color neonEdge = neonBlue;

  static const Color purple = Color(0xFF8D7CFF);
  static const Color purple2 = twilightPlum;
  static const Color purpleGlow = Color(0xFF9B6FFF);

  static const Color border = Color(0xFF1A2D6B);
  static const Color border2 = neonBlue;
  static const Color glassBorder = Color(0x663A60A0);

  // --- STATUS & ACCENTS ---
  static const Color gold = Color(0xFFFFD700);
  static const Color gold2 = Color(0xFFC8A800);
  static const Color success = Color(0xFF00FF88);
  static const Color danger = Color(0xFFFF4466);

  // --- TYPOGRAPHY ---
  static const Color textMain = Color(0xFFE8F0FF);
  static const Color textSecondary = Color(0xFF8FA8D8);
  static const Color textDim = Color(0xFF4A6090);

  // --- GRADIENTS ---
  static const List<Color> cosmicGradient = [cosmicInk, twilightPlum];
  static const List<Color> buttonGradient = [deepSky, twilightPlum];

  // ═══════════════════════════════════════════════════
  // LIGHT MODE CELESTIAL PALETTE
  // ═══════════════════════════════════════════════════

  // Backgrounds
  static const Color lBgBase = Color(0xFFDFE9FB);
  static const Color lBgAtmo = Color(0xFFD4E2FB);
  static const Color lBgDeep = Color(0xFFEAF2FF);
  static const Color lBgFrost = Color(0xFFF7FBFF);
  static const Color lBgNebula = Color(0xFFEEF4FF);
  static const Color lBgMist = Color(0xFFE7EEFF);

  // Surfaces (glassmorphism)
  static const Color lSurface = Color(0xCCF0F6FF); // 80% opacity white-blue
  static const Color lSurfaceHi = Color(0xE6FFFFFF); // bright glass
  static const Color lSurfaceLo = Color(0xB3DDE8F8); // deeper glass

  // Accents
  static const Color lCyan = Color(0xFF6AD7FF);
  static const Color lCyan2 = Color(0xFF7BE7FF);
  static const Color lPurple = Color(0xFF8D7BFF);
  static const Color lPurple2 = Color(0xFFA58BFF);
  static const Color lBlue = Color(0xFF3A60A0);
  static const Color lIndigoDeep = Color(0xFF4D4177);
  static const Color lBlueLight = Color(0xFF5578B8);

  // Borders
  static const Color lBorder = Color(0xFFBDD0EE);
  static const Color lBorderGlow = Color(0xFF6AD7FF);
  static const Color lBorderSoft = Color(0xFFD0DFF8);

  // Text
  static const Color lTextMain = Color(0xFF1A2747);
  static const Color lTextMid = Color(0xFF25345F);
  static const Color lTextSub = Color(0xFF5D6D92);
  static const Color lTextDim = Color(0xFF8898BB);

  // Glow / effects
  static const Color lGlowCyan = Color(0x406AD7FF);
  static const Color lGlowPurple = Color(0x2E8D7BFF);
  static const Color lGlowBlue = Color(0x303A60A0);

  // Gold accent
  static const Color lGold = Color(0xFFF3D36B);
  static const Color lGoldDeep = Color(0xFFD4A800);

  // Status
  static const Color lSuccess = Color(0xFF00C96E);
  static const Color lDanger = Color(0xFFE02050);

// LIGHT MODE
  static const Color lCard = Color(0xFFF8FAFF);
}
