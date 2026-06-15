import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:honkai_star_retail/core/utils/currency_formatter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/app_fonts.dart';

import '../providers/cart_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/galaxy_ui_helper.dart';

import 'success_screen.dart';

class VAScreen extends StatelessWidget {
  const VAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppTheme.hsrCyan : AppColors.lBlue;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "BANKING TERMINAL",
      useScroll: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildSectionLabel(
              "CONNECTION_SECURE",
              accent,
              settings,
            ),
            const SizedBox(height: 14),
            Text(
              'VIRTUAL_ACCOUNT',
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white : AppTheme.stellarText,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 45),
            _buildVADisplay(
              context,
              cart.vaNumber ?? '---',
              isDark,
              accent,
              settings,
            ),
            const SizedBox(height: 34),
            _buildInfoBox(
              isDark,
              accent,
            ),
            const SizedBox(height: 40),
            Text(
              'AMOUNT_DUE',
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white24 : AppColors.lTextSub,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            // UPDATED PRICE STYLE - MATCHING CART, CHECKOUT & QR SCREENS
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFFFFF2B3),
                          const Color(0xFFFFD66B),
                        ]
                      : [
                          const Color(0xFFFFE082),
                          const Color(0xFFE0AE2D),
                        ],
                ).createShader(bounds);
              },
              child: Text(
                CurrencyFormatter.format(
                  cart.totalPrice,
                ),
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            const SizedBox(height: 60),
            _buildConfirmButton(
              context,
              isDark,
              accent,
              settings,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(
    String text,
    Color color,
    SettingsProvider settings,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 2,
          decoration: BoxDecoration(
            color: color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: color.withOpacity(0.6),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 10,
          height: 2,
          decoration: BoxDecoration(
            color: color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }

  Widget _buildVADisplay(
    BuildContext context,
    String va,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.95),
                  AppColors.lBgNebula.withOpacity(0.9),
                  AppColors.lPurple.withOpacity(0.06),
                ],
              ),
        color: isDark ? Colors.white.withOpacity(0.04) : null,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: accent.withOpacity(0.28),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(
              isDark ? 0.12 : 0.16,
            ),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.18)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accent.withOpacity(0.15),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "INTERASTRAL VA ID",
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: isDark ? Colors.white24 : AppColors.lTextSub,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  va,
                  textAlign: TextAlign.center,
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: isDark ? accent : AppColors.lBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: va),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'ID Copied to Clipboard',
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(0.14),
                    accent.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accent.withOpacity(0.35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.copy,
                    color: accent,
                    size: 15,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'COPY_ID',
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    bool isDark,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : accent.withOpacity(0.12),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.lGlowBlue.withOpacity(0.08),
              blurRadius: 22,
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.info,
            color: accent.withOpacity(0.65),
            size: 18,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Please complete the transfer using the ID above. Verification is automatic.",
              style: GoogleFonts.exo2(
                color: isDark ? Colors.white54 : AppColors.lTextSub,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED BUTTON - MATCHING CART, CHECKOUT & QR SCREENS
  Widget _buildConfirmButton(
    BuildContext context,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SuccessScreen(),
          ),
        );
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.hsrCyan,
                    AppTheme.hsrPurple,
                  ]
                : [
                    AppColors.lBlue,
                    AppColors.lPurple,
                    AppColors.lIndigoDeep,
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.30),
              blurRadius: 32,
              spreadRadius: -6,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.shieldCheck,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              'CHECK_PAYMENT_STATUS',
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
                fontSize: 10.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
