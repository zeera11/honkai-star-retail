// ignore: unused_import
import 'package:flutter/material.dart';

enum GalaxyIntensity { minimal, standard, ultra }

enum FontPreset { orbitron, rajdhani, exo2 }

enum FontSizePreset { compact, defaultSize, large }

class AppSettings {
  final bool isDarkMode;
  final FontSizePreset fontSize;
  final FontPreset fontStyle;
  final GalaxyIntensity intensity;
  final bool reduceMotion;
  final bool highContrast;

  AppSettings({
    required this.isDarkMode,
    required this.fontSize,
    required this.fontStyle,
    required this.intensity,
    required this.reduceMotion,
    required this.highContrast,
  });
}
