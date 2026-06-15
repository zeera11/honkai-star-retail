import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../models/settings_model.dart';
import '../providers/settings_provider.dart';
import '../widgets/galaxy_ui_helper.dart';
import '../core/app_theme.dart';
import '../core/app_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final accent = Theme.of(context).primaryColor;
    final scale = settings.fontScale;

    return GalaxyScreenWrapper(
      title: "SYSTEM SETTINGS",
      useScroll: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildTechnicalHeader("APPEARANCE_MODULE", accent, scale, settings),
          _buildSettingCard(
            context,
            title: "Dark Space Mode",
            desc: isDark
                ? "High-contrast neon terminal active"
                : "Celestial luminous mode active",
            icon: isDark ? LucideIcons.moon : LucideIcons.sun,
            isDark: isDark,
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: accent,
              onChanged: (v) => settings.setDarkMode(v),
            ),
          ),
          const SizedBox(height: 32),
          _buildSubLabel("FONT_STYLE_PRESETS", isDark, scale, settings),
          _buildFontPresets(settings, accent, isDark),
          const SizedBox(height: 32),
          _buildSubLabel("TEXT_SCALE_CONFIG", isDark, scale, settings),
          _buildSegmentedFontSize(settings, accent, isDark),
          const SizedBox(height: 32),
          _buildSubLabel("GALAXY_VISUAL_INTENSITY", isDark, scale, settings),
          _buildSegmentedIntensity(settings, accent, isDark),
          const SizedBox(height: 40),
          _buildTechnicalHeader("ACCESSIBILITY_LAYER", accent, scale, settings),
          _buildSettingCard(
            context,
            title: "Reduce Motion",
            desc: "Dampens atmospheric shimmer & floating effects",
            icon: LucideIcons.zapOff,
            isDark: isDark,
            trailing: Switch.adaptive(
              value: settings.reduceMotion,
              activeColor: accent,
              onChanged: (v) => settings.setReduceMotion(v),
            ),
          ),
          _buildSettingCard(
            context,
            title: "High Contrast",
            desc: "Maximize legibility of interastral data",
            icon: LucideIcons.eye,
            isDark: isDark,
            trailing: Switch.adaptive(
              value: settings.highContrast,
              activeColor: accent,
              onChanged: (v) => settings.setHighContrast(v),
            ),
          ),
          const SizedBox(height: 60),
          _buildBuildInfo(isDark, scale, accent, settings),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTechnicalHeader(
      String title, Color accent, double scale, SettingsProvider settings) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Container(width: 4, height: 18 * scale, color: accent),
            const SizedBox(width: 14),
            Text(title,
                style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: accent)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubLabel(
      String text, bool isDark, double scale, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(text,
          style: AppFonts.orbitron(
              preset: settings.fontStyle,
              fontSize: 9 * scale,
              color: isDark
                  ? Colors.white24
                  : AppTheme.galaxyBlue.withOpacity(0.5),
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5)),
    );
  }

  Widget _buildSettingCard(BuildContext context,
      {required String title,
      required String desc,
      required IconData icon,
      required bool isDark,
      required Widget trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.glassDecoration(isDark),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppTheme.galaxyBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon,
                color: isDark ? AppTheme.hsrCyan : AppTheme.hologramCyan,
                size: 20),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(desc,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 10, height: 1.5)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildFontPresets(
      SettingsProvider settings, Color accent, bool isDark) {
    return Row(
      children: FontPreset.values.map((p) {
        bool isSel = settings.fontStyle == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => settings.setFontStyle(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSel
                    ? accent.withOpacity(0.18)
                    : (isDark
                        ? Colors.white.withOpacity(0.03)
                        : AppTheme.nebulaWhite.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isSel
                        ? accent
                        : (isDark
                            ? Colors.white12
                            : AppTheme.hologramCyan.withOpacity(0.2)),
                    width: isSel ? 1.5 : 1),
              ),
              alignment: Alignment.center,
              child: Text(p.name.toUpperCase(),
                  style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      fontSize: 9 * settings.fontScale,
                      fontWeight: FontWeight.w900,
                      color: isSel
                          ? accent
                          : (isDark
                              ? Colors.white24
                              : AppTheme.galaxyBlue.withOpacity(0.4)))),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSegmentedFontSize(
      SettingsProvider settings, Color accent, bool isDark) {
    return Row(
      children: FontSizePreset.values.map((p) {
        bool isSel = settings.fontSize == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => settings.setFontSize(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSel
                    ? accent.withOpacity(0.18)
                    : (isDark
                        ? Colors.white.withOpacity(0.03)
                        : AppTheme.nebulaWhite.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isSel
                        ? accent
                        : (isDark
                            ? Colors.white12
                            : AppTheme.hologramCyan.withOpacity(0.2)),
                    width: isSel ? 1.5 : 1),
              ),
              alignment: Alignment.center,
              child: Text(p.name.split('.').last.toUpperCase(),
                  style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      fontSize: 9 * settings.fontScale,
                      fontWeight: FontWeight.w900,
                      color: isSel
                          ? accent
                          : (isDark
                              ? Colors.white24
                              : AppTheme.galaxyBlue.withOpacity(0.4)))),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSegmentedIntensity(
      SettingsProvider settings, Color accent, bool isDark) {
    return Row(
      children: GalaxyIntensity.values.map((p) {
        bool isSel = settings.intensity == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => settings.setIntensity(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSel
                    ? accent.withOpacity(0.18)
                    : (isDark
                        ? Colors.white.withOpacity(0.03)
                        : AppTheme.nebulaWhite.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isSel
                        ? accent
                        : (isDark
                            ? Colors.white12
                            : AppTheme.hologramCyan.withOpacity(0.2)),
                    width: isSel ? 1.5 : 1),
              ),
              alignment: Alignment.center,
              child: Text(p.name.toUpperCase(),
                  style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      fontSize: 9 * settings.fontScale,
                      fontWeight: FontWeight.w900,
                      color: isSel
                          ? accent
                          : (isDark
                              ? Colors.white24
                              : AppTheme.galaxyBlue.withOpacity(0.4)))),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBuildInfo(
      bool isDark, double scale, Color accent, SettingsProvider settings) {
    return Center(
      child: Column(
        children: [
          Text("INTERASTRAL_RETAIL_PROTOCOL_v.4.2.1",
              style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  fontSize: 8 * scale,
                  color: isDark
                      ? Colors.white10
                      : AppTheme.galaxyBlue.withOpacity(0.2),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
                color: accent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accent.withOpacity(0.1))),
            child: Text("STEL_NET: STABLE | ENCRYPTION: G-256",
                style: GoogleFonts.exo2(
                    fontSize: 8 * scale,
                    color: isDark
                        ? Colors.white24
                        : AppTheme.galaxyBlue.withOpacity(0.4),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1)),
          ),
        ],
      ),
    );
  }
}
