import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/settings_model.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  // =========================================================
  // SPACING SYSTEM
  // =========================================================

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // =========================================================
  // RADIUS SYSTEM
  // =========================================================

  static const double radiusSm = 14;
  static const double radiusMd = 18;
  static const double radiusLg = 24;
  static const double radiusXl = 30;

  // =========================================================
  // GLOW OPACITY
  // =========================================================

  static const double glowLow = 0.08;
  static const double glowMedium = 0.14;
  static const double glowHigh = 0.22;

  // =========================================================
  // DARK COLORS
  // =========================================================

  static const Color hsrDeepSpace = Color(0xFF0B1838);

  static const Color hsrCyan = Color(0xFF00D4FF);

  static const Color hsrPurple = Color(0xFF9B6FFF);

  static const Color hsrGold = Color(0xFFFFD700);

  static const Color hsrDanger = Color(0xFFFF4466);

  static const Color hsrSuccess = Color(0xFF00FF88);

  // =========================================================
  // LIGHT COLORS
  // =========================================================

  static const Color bgBase = AppColors.lBgBase;

  static const Color bgAtmosphere = AppColors.lBgAtmo;

  static const Color nebulaOverlay = AppColors.lBgMist;

  static const Color surfaceCard = AppColors.lSurface;

  static const Color surfaceElevated = AppColors.lSurfaceHi;

  static const Color primaryBlue = AppColors.lBlue;

  static const Color deepAccent = AppColors.lIndigoDeep;

  static const Color darkText = AppColors.lTextMain;

  static const Color secondaryText = AppColors.lTextSub;

  static const Color glowCyan = AppColors.lCyan;

  static const Color nebulaPurple = AppColors.lPurple;

  static const Color softGold = Color(0xFFFFD84D);

  static const Color premiumGold = Color(0xFFFFD700);

  static const Color premiumGoldDeep = Color(0xFFFFB800);

  static const Color cosmicBlue = Color(0xFF5B7CFF);

  static const Color auroraBlue = Color(0xFF7FD6FF);

  static const Color nebulaGlass = Color(0xFFF4F7FF);

  static const Color cosmicShadow = Color(0xFF9AA8D7);

  static const Color hologramBorder = Color(0xFFDCE7FF);

  static const Color frostWhite = AppColors.lBgFrost;

  static const Color luxuryOverlay = Color(0x66FFFFFF);

  static const Color holographicShine = Color(0x99FFFFFF);

  static const Color premiumDivider = Color(0x22A9BFFF);

  // =========================================================
  // ALIASES
  // =========================================================

  static const Color stellarPrimary = primaryBlue;

  static const Color stellarAccent = deepAccent;

  static const Color stellarText = darkText;

  static const Color celestialMist = bgAtmosphere;

  static const Color moonlightSilver = bgBase;

  static const Color nebulaWhite = frostWhite;

  static const Color astralSurface = surfaceCard;

  static const Color galaxyBlue = primaryBlue;

  static const Color hologramCyan = glowCyan;

  static const Color auroraGlow = nebulaPurple;

  static const Color indigoShadow = Color(0xFF25345F);

  // =========================================================
  // FONT HELPER
  // =========================================================

  static TextStyle fontStyle(
    FontPreset preset, {
    required double size,
    required FontWeight weight,
    required Color color,
    double spacing = 0,
    double height = 1.2,
  }) {
    switch (preset) {
      case FontPreset.orbitron:
        return GoogleFonts.orbitron(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: spacing,
          height: height,
        );

      case FontPreset.rajdhani:
        return GoogleFonts.rajdhani(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: spacing,
          height: height,
        );

      case FontPreset.exo2:
        return GoogleFonts.exo2(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: spacing,
          height: height,
        );
    }
  }

  // =========================================================
  // THEME GENERATOR
  // =========================================================

  static ThemeData generateTheme({
    required bool isDark,
    required FontPreset fontPreset,
    required double scale,
    required bool highContrast,
  }) {
    final Color primaryColor = isDark ? hsrCyan : primaryBlue;

    final Color backgroundColor = isDark ? hsrDeepSpace : bgBase;

    final Color textColor =
        isDark ? Colors.white : (highContrast ? Colors.black : darkText);

    final Color subTextColor = isDark ? Colors.white70 : secondaryText;

    final Color cardColor = isDark
        ? const Color(0xFF101E42).withOpacity(0.82)
        : Colors.white.withOpacity(0.72);

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,

      scaffoldBackgroundColor: backgroundColor,

      primaryColor: primaryColor,

      cardColor: cardColor,

      splashColor: primaryColor.withOpacity(0.08),

      highlightColor: Colors.transparent,

      dividerColor: isDark ? Colors.white10 : AppColors.lBorder,

      // =====================================================
      // APP BAR
      // =====================================================

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppFonts.orbitron(
          preset: fontPreset,
          fontSize: 14.5 * scale,
          fontWeight: FontWeight.w900,
          color: primaryColor,
          letterSpacing: 2.2,
          height: 1,
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
          size: 21,
        ),
        actionsIconTheme: IconThemeData(
          color: primaryColor,
          size: 20,
        ),
      ),

      // =====================================================
      // COLOR SCHEME
      // =====================================================

      colorScheme: isDark
          ? const ColorScheme.dark(
              primary: hsrCyan,
              secondary: hsrPurple,
              surface: Color(
                0xFF101E42,
              ),
            )
          : const ColorScheme.light(
              primary: primaryBlue,
              secondary: nebulaPurple,
              surface: Color(
                0xFFF6FAFF,
              ),
            ),

      // =====================================================
      // TEXT THEME
      // =====================================================

      textTheme: TextTheme(
        displayLarge: AppFonts.orbitron(
          preset: fontPreset,
          fontSize: 32 * scale,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 1.6,
          height: 1,
        ),
        displayMedium: AppFonts.orbitron(
          preset: fontPreset,
          fontSize: 26 * scale,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 1.2,
          height: 1.04,
        ),
        titleLarge: AppFonts.orbitron(
          preset: fontPreset,
          fontSize: 19 * scale,
          fontWeight: FontWeight.w800,
          color: primaryColor,
          letterSpacing: 1,
          height: 1.15,
        ),
        titleMedium: GoogleFonts.rajdhani(
          fontSize: 17 * scale,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        bodyLarge: GoogleFonts.exo2(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w500,
          color: textColor,
          height: 1.65,
          letterSpacing: 0.1,
        ),
        bodyMedium: GoogleFonts.exo2(
          fontSize: 13.5 * scale,
          fontWeight: highContrast ? FontWeight.w600 : FontWeight.w500,
          color: subTextColor,
          height: 1.62,
          letterSpacing: 0.1,
        ),
        bodySmall: GoogleFonts.exo2(
          fontSize: 11.5 * scale,
          fontWeight: FontWeight.w500,
          color: subTextColor.withOpacity(0.82),
          height: 1.55,
          letterSpacing: 0.1,
        ),
        labelLarge: AppFonts.orbitron(
          preset: fontPreset,
          fontSize: 11.5 * scale,
          fontWeight: FontWeight.w800,
          color: primaryColor,
          letterSpacing: 1.6,
        ),
        labelMedium: AppFonts.orbitron(
          preset: fontPreset,
          fontSize: 9.5 * scale,
          fontWeight: FontWeight.w800,
          color: primaryColor.withOpacity(0.84),
          letterSpacing: 1.8,
        ),
        labelSmall: AppFonts.orbitron(
          preset: fontPreset,
          fontSize: 8 * scale,
          fontWeight: FontWeight.w900,
          color: primaryColor.withOpacity(0.72),
          letterSpacing: 2.2,
        ),
      ),
    );
  }

  // =========================================================
  // GLASS DECORATION
  // =========================================================

  static BoxDecoration glassDecoration(
    bool isDark, {
    double opacity = 0.6,
  }) {
    if (isDark) {
      return BoxDecoration(
        color: const Color(
          0xFF101E42,
        ).withOpacity(opacity),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: hsrCyan.withOpacity(0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: hsrCyan.withOpacity(
              0.06,
            ),
            blurRadius: 30,
            spreadRadius: -8,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(
              0.35,
            ),
            blurRadius: 24,
            offset: const Offset(
              0,
              14,
            ),
          ),
        ],
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.96),
          const Color(0xFFF4F8FF).withOpacity(0.92),
          const Color(0xFFE7F0FF).withOpacity(0.84),
        ],
      ),
      borderRadius: BorderRadius.circular(26),
      border: Border.all(
        color: hologramBorder.withOpacity(0.82),
        width: 1.4,
      ),
      boxShadow: [
        BoxShadow(
          color: glowCyan.withOpacity(
            0.12,
          ),
          blurRadius: 36,
          spreadRadius: -6,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: nebulaPurple.withOpacity(0.10),
          blurRadius: 40,
          spreadRadius: -10,
          offset: const Offset(0, 20),
        ),
      ],
    );
  }

  // =========================================================
  // LIGHT CARD
  // =========================================================

  static BoxDecoration lightCard({
    double radius = 20,
    bool glow = false,
    Color? glowColor,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.98),
          const Color(0xFFF7FAFF).withOpacity(0.94),
          const Color(0xFFE8F0FF).withOpacity(0.88),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: hologramBorder.withOpacity(
          0.9,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: glowColor != null
              ? glowColor.withOpacity(
                  glow ? 0.24 : 0.10,
                )
              : glowCyan.withOpacity(
                  glow ? 0.22 : 0.10,
                ),
          blurRadius: glow ? 34 : 18,
          spreadRadius: glow ? -6 : -3,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  // =========================================================
  // LIGHT BUTTON
  // =========================================================

  static BoxDecoration lightButton({
    double radius = 18,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4F7BFF),
          Color(0xFF786BFF),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withOpacity(
          0.24,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: cosmicBlue.withOpacity(
            0.34,
          ),
          blurRadius: 28,
          spreadRadius: -6,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}
