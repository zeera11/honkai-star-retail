import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  FontSizePreset _fontSize = FontSizePreset.defaultSize;

  FontPreset _fontStyle = FontPreset.orbitron;

  GalaxyIntensity _intensity = GalaxyIntensity.standard;

  bool _reduceMotion = false;

  bool _highContrast = false;

  bool get isDarkMode => _isDarkMode;

  FontSizePreset get fontSize => _fontSize;

  FontPreset get fontStyle => _fontStyle;

  GalaxyIntensity get intensity => _intensity;

  bool get reduceMotion => _reduceMotion;

  bool get highContrast => _highContrast;

  SettingsProvider() {
    loadSettings();
  }

  // =====================================================
  // LOAD
  // =====================================================

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool('isDarkMode') ?? true;

    _fontStyle = FontPreset.values[prefs.getInt(
          'fontStyleIdx',
        ) ??
        0];

    _fontSize = FontSizePreset.values[prefs.getInt(
          'fontSizeIdx',
        ) ??
        1];

    _intensity = GalaxyIntensity.values[prefs.getInt(
          'intensityIdx',
        ) ??
        1];

    _reduceMotion = prefs.getBool(
          'reduceMotion',
        ) ??
        false;

    _highContrast = prefs.getBool(
          'highContrast',
        ) ??
        false;

    notifyListeners();
  }

  // =====================================================
  // SAVE
  // =====================================================

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isDarkMode',
      _isDarkMode,
    );

    await prefs.setInt(
      'fontSizeIdx',
      _fontSize.index,
    );

    await prefs.setInt(
      'fontStyleIdx',
      _fontStyle.index,
    );

    await prefs.setInt(
      'intensityIdx',
      _intensity.index,
    );

    await prefs.setBool(
      'reduceMotion',
      _reduceMotion,
    );

    await prefs.setBool(
      'highContrast',
      _highContrast,
    );
  }

  // =====================================================
  // THEME TOGGLE
  // =====================================================

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isDarkMode',
      _isDarkMode,
    );
  }

  // =====================================================
  // FONT SCALE
  // =====================================================

  double get fontScale {
    switch (_fontSize) {
      case FontSizePreset.compact:
        return 0.90;

      case FontSizePreset.large:
        return 1.20;

      case FontSizePreset.defaultSize:
        return 1.0;
    }
  }

  // =====================================================
  // INTENSITY VALUES
  // =====================================================

  double get glowIntensity {
    switch (_intensity) {
      case GalaxyIntensity.minimal:
        return 0.05;

      case GalaxyIntensity.standard:
        return 0.80;

      case GalaxyIntensity.ultra:
        return 1.45;
    }
  }

  int get starDensity {
    switch (_intensity) {
      case GalaxyIntensity.minimal:
        return 60;

      case GalaxyIntensity.standard:
        return 400;

      case GalaxyIntensity.ultra:
        return 900;
    }
  }

  double get blurSigma {
    if (_reduceMotion) {
      return 0;
    }

    switch (_intensity) {
      case GalaxyIntensity.minimal:
        return 4;

      case GalaxyIntensity.standard:
        return 15;

      case GalaxyIntensity.ultra:
        return 28;
    }
  }

  double get orbIntensity {
    switch (_intensity) {
      case GalaxyIntensity.minimal:
        return 0.08;

      case GalaxyIntensity.standard:
        return 0.18;

      case GalaxyIntensity.ultra:
        return 0.35;
    }
  }

  double get nebulaOpacity {
    switch (_intensity) {
      case GalaxyIntensity.minimal:
        return 0.04;

      case GalaxyIntensity.standard:
        return 0.12;

      case GalaxyIntensity.ultra:
        return 0.22;
    }
  }

  // =====================================================
  // SETTERS
  // =====================================================

  Future<void> setDarkMode(
    bool value,
  ) async {
    _isDarkMode = value;

    notifyListeners();

    await _saveSettings();
  }

  Future<void> setFontSize(
    FontSizePreset value,
  ) async {
    _fontSize = value;

    notifyListeners();

    await _saveSettings();
  }

  Future<void> setFontStyle(
    FontPreset value,
  ) async {
    _fontStyle = value;

    notifyListeners();

    await _saveSettings();
  }

  Future<void> setIntensity(
    GalaxyIntensity value,
  ) async {
    _intensity = value;

    notifyListeners();

    await _saveSettings();
  }

  Future<void> setReduceMotion(
    bool value,
  ) async {
    _reduceMotion = value;

    notifyListeners();

    await _saveSettings();
  }

  Future<void> setHighContrast(
    bool value,
  ) async {
    _highContrast = value;

    notifyListeners();

    await _saveSettings();
  }
}
