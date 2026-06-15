import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/settings_model.dart';

class AppFonts {
  static TextStyle orbitron({
    required FontPreset preset,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
  }) {
    switch (preset) {
      case FontPreset.orbitron:
        return GoogleFonts.orbitron(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          shadows: shadows,
        );

      case FontPreset.exo2:
        return GoogleFonts.exo2(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          shadows: shadows,
        );

      case FontPreset.rajdhani:
        return GoogleFonts.rajdhani(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          shadows: shadows,
        );
    }
  }
}
