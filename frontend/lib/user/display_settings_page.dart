import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/app_fonts.dart';
import '../providers/settings_provider.dart';
import '../widgets/galaxy_ui_helper.dart';

class DisplaySettingsPage extends StatelessWidget {
  const DisplaySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppTheme.hsrCyan : AppTheme.stellarPrimary;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "DISPLAY PROTOCOLS",
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              30,
            ),
            children: [
              _buildTechnicalLabel(
                "VISUAL_RESONANCE_SELECT",
                accent,
                settings,
              ),
              const SizedBox(height: 10),
              _buildThemeOption(
                title: "DARK_SPACE_MODE",
                desc: "Galaxy terminal & neon interface aesthetic",
                icon: LucideIcons.moon,
                isSelected: isDark,
                isDark: isDark,
                accent: accent,
                settings: settings,
                onTap: () => settings.setDarkMode(true),
              ),
              const SizedBox(height: 14),
              _buildThemeOption(
                title: "STELLAR_LIGHT_MODE",
                desc: "Clean interastral daylight visual protocol",
                icon: LucideIcons.sun,
                isSelected: !isDark,
                isDark: isDark,
                accent: accent,
                settings: settings,
                onTap: () => settings.setDarkMode(false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalLabel(
    String text,
    Color color,
    SettingsProvider settings,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
        bottom: 8,
      ),
      child: Text(
        text,
        style: AppFonts.orbitron(
          preset: settings.fontStyle,
          color: color.withOpacity(0.42),
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.4,
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String desc,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required Color accent,
    required SettingsProvider settings,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [
                          accent.withOpacity(0.10),
                          const Color(0xFF111D40),
                          const Color(0xFF172754),
                        ]
                      : [
                          const Color(0xCC101E42),
                          const Color(0xCC16244F),
                        ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [
                          Colors.white,
                          accent.withOpacity(0.05),
                        ]
                      : [
                          Colors.white,
                          const Color(0xFFF5F8FF),
                        ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? accent.withOpacity(0.75)
                : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(
                isSelected ? (isDark ? 0.16 : 0.08) : 0.03,
              ),
              blurRadius: isSelected ? 20 : 10,
              spreadRadius: -6,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(0.16),
                    accent.withOpacity(0.06),
                  ],
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? accent
                    : (isDark ? Colors.white30 : Colors.black38),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: isDark ? Colors.white : AppTheme.stellarText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.exo2(
                      color: isDark ? const Color(0xFF8FA8D8) : Colors.black45,
                      fontSize: 10.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: isSelected ? 1 : 0,
              child: Icon(
                LucideIcons.checkCircle2,
                color: accent,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
