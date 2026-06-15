// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:honkai_star_retail/core/utils/currency_formatter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/app_colors.dart';
import '../core/app_fonts.dart';
import '../providers/cart_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/galaxy_ui_helper.dart';

import 'qr_screen.dart';
import 'va_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppTheme.hsrCyan : AppTheme.stellarPrimary;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "INTERASTRAL BILLING",
      useScroll: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              children: [
                _buildSectionHeader(
                  "PAYMENT_PROTOCOL_V2",
                  isDark,
                  accent,
                  settings,
                ),
                const SizedBox(height: 18),
                _buildPaymentHUDOption(
                  context,
                  label: 'QRIS INSTANT',
                  sub: 'Scan and pay via Interastral Network',
                  icon: LucideIcons.qrCode,
                  type: 'qris',
                  isActive: cart.selectedPayment == 'qris',
                  isDark: isDark,
                  accent: accent,
                  settings: settings,
                ),
                const SizedBox(height: 18),
                _buildPaymentHUDOption(
                  context,
                  label: 'VIRTUAL ACCOUNT',
                  sub: 'Direct bank transfer authorization',
                  icon: LucideIcons.creditCard,
                  type: 'va',
                  isActive: cart.selectedPayment == 'va',
                  isDark: isDark,
                  accent: accent,
                  settings: settings,
                ),
                const SizedBox(height: 22),
                _buildInfoNotice(isDark, accent),
              ],
            ),
          ),
          _buildFinalSummary(
            context,
            cart,
            isDark,
            accent,
            settings,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 16,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (!isDark)
                const BoxShadow(
                  color: AppColors.lGlowCyan,
                  blurRadius: 12,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: isDark ? Colors.white30 : AppColors.lTextSub,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHUDOption(
    BuildContext context, {
    required String label,
    required String sub,
    required IconData icon,
    required String type,
    required bool isActive,
    required bool isDark,
    required Color accent,
    required SettingsProvider settings,
  }) {
    return GestureDetector(
      onTap: () => context.read<CartProvider>().setPayment(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutQuart,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isActive
                      ? [
                          accent.withOpacity(0.12),
                          const Color(0xFF101E42),
                          const Color(0xFF16244F),
                        ]
                      : [
                          const Color(0xCC101E42),
                          const Color(0xCC16244F),
                        ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isActive
                      ? [
                          Colors.white.withOpacity(0.96),
                          AppColors.lBgNebula.withOpacity(0.88),
                          accent.withOpacity(0.08),
                        ]
                      : [
                          Colors.white.withOpacity(0.88),
                          AppColors.lBgFrost.withOpacity(0.72),
                          const Color(0xFFEFF5FF).withOpacity(0.60),
                        ],
                ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isActive
                ? accent.withOpacity(0.60)
                : (isDark
                    ? Colors.white10
                    : AppColors.lBorder.withOpacity(0.40)),
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(
                isActive ? (isDark ? 0.18 : 0.10) : 0.04,
              ),
              blurRadius: isActive ? 28 : 14,
              spreadRadius: -6,
              offset: const Offset(0, 12),
            ),
            if (!isDark)
              BoxShadow(
                color: Colors.white.withOpacity(0.72),
                blurRadius: 10,
                spreadRadius: -4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Stack(
          children: [
            // SHIMMER
            if (!isDark)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.12),
                          Colors.transparent,
                          accent.withOpacity(0.03),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            Row(
              children: [
                // ICON MODULE
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withOpacity(0.18),
                        accent.withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: accent.withOpacity(0.12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(
                          isActive ? 0.16 : 0.06,
                        ),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: isActive
                        ? accent
                        : (isDark
                            ? const Color(0xFF6078AA)
                            : AppColors.lTextDim),
                    size: 23,
                  ),
                ),

                const SizedBox(width: 16),

                // TEXTS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.stellarText,
                                fontWeight: FontWeight.w900,
                                fontSize: 12.6,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: accent.withOpacity(0.20),
                                ),
                              ),
                              child: Text(
                                'ACTIVE',
                                style: AppFonts.orbitron(
                                  preset: settings.fontStyle,
                                  color: accent,
                                  fontSize: 6.8,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        sub,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.exo2(
                          color: isDark
                              ? const Color(0xFF9FB3DB)
                              : AppColors.lTextSub,
                          fontSize: 11,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoNotice(
    bool isDark,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.88),
                  AppColors.lBgNebula.withOpacity(0.82),
                ],
              ),
        color: isDark ? Colors.white.withOpacity(0.03) : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.lBorder.withOpacity(0.5),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.lGlowBlue.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.info,
            color: accent.withOpacity(0.55),
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Your transaction is encrypted by Interastral Banking protocol.",
              style: GoogleFonts.exo2(
                color: isDark ? const Color(0xFF4A6090) : AppColors.lTextSub,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSummary(
    BuildContext context,
    CartProvider cart,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(34),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 24,
          sigmaY: 24,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            28,
          ),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0D1B3E),
                      Color(0xFF101E42),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.94),
                      AppColors.lBgNebula.withOpacity(0.86),
                      const Color(0xFFEAF1FF).withOpacity(0.72),
                    ],
                  ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(34),
            ),
            border: Border.all(
              color: accent.withOpacity(0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(
                  isDark ? 0.18 : 0.10,
                ),
                blurRadius: 42,
                spreadRadius: -10,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // LIGHT SHIMMER
              if (!isDark)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(34),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'INTERASTRAL BILLING',
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                shadows: [
                                  if (!isDark)
                                    Shadow(
                                      color: const Color(0xFFFFD86B)
                                          .withOpacity(0.22),
                                      blurRadius: 18,
                                    ),
                                ],
                                color: isDark
                                    ? Colors.white30
                                    : AppColors.lTextSub,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.2,
                              ),
                            ),
                            const SizedBox(height: 5),
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
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ITEMS CHIP
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accent.withOpacity(0.14),
                              accent.withOpacity(0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accent.withOpacity(0.12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${cart.cartCount}',
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                color: accent,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ITEMS',
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                color: accent.withOpacity(0.7),
                                fontSize: 7,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // FINAL BUTTON
                  GestureDetector(
                    onTap: () {
                      cart.prepareOrder();

                      if (cart.selectedPayment == 'qris') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QRScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VAScreen(),
                          ),
                        );
                      }
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
                            offset: const Offset(
                              0,
                              16,
                            ),
                          ),
                        ],
                      ),
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
                            'AUTHORIZE PAYMENT',
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
