import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/galaxy_ui_helper.dart';
import 'login_page.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final accent = isDark ? AppTheme.hsrCyan : AppTheme.stellarPrimary;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: 'Honkai Star Retail',
      showBackButton: false,
      useScroll: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(isDark, accent),
              const SizedBox(height: 50),

              // ── App Title ─────────────────────────────────────────────
              Text(
                'HONKAI STAR',
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  color: isDark ? Colors.white : AppColors.lTextMain,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'RETAIL TERMINAL',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  color: accent,
                  letterSpacing: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 80),

              // ── Enter Button ──────────────────────────────────────────
              _buildStartButton(context, isDark, accent),
              const SizedBox(height: 24),

              // ── Status ────────────────────────────────────────────────
              _buildSystemStatus(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark, Color accent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: accent.withOpacity(isDark ? 0.15 : 0.20),
                  blurRadius: 80,
                  spreadRadius: 10),
            ],
          ),
        ),
        // Glass circle
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isDark
                ? null
                : const RadialGradient(
                    colors: [
                      AppColors.lBgFrost,
                      AppColors.lBgAtmo,
                    ],
                  ),
            color: isDark ? Colors.white.withOpacity(0.04) : null,
            border: Border.all(color: accent.withOpacity(0.35), width: 1.5),
            boxShadow: [
              BoxShadow(color: accent.withOpacity(0.20), blurRadius: 30),
              if (!isDark)
                const BoxShadow(
                    color: Colors.white, blurRadius: 6, offset: Offset(0, -2)),
            ],
          ),
          child: Icon(LucideIcons.sparkles,
              size: 52, color: isDark ? AppTheme.hsrGold : AppColors.lGold),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, bool isDark, Color accent) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPage())),
      child: Container(
        height: 66,
        width: double.infinity,
        decoration: isDark
            ? BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accent.withOpacity(0.5), width: 1.5),
              )
            : AppTheme.lightButton(radius: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ENTER TERMINAL',
              style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 3),
            ),
            const SizedBox(width: 16),
            const Icon(LucideIcons.chevronRight, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatus(bool isDark) {
    return Column(
      children: [
        Text(
          'PROTOCOL: ACTIVE',
          style: GoogleFonts.orbitron(
            color: isDark ? Colors.green.withOpacity(0.5) : AppColors.lSuccess,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'SECURE CONNECTION ESTABLISHED',
          style: GoogleFonts.exo2(
            color: isDark ? Colors.white24 : AppColors.lTextDim,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
