// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
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

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();

    final expiry = context.read<CartProvider>().qrExpiry;

    if (expiry != null) {
      _remaining = expiry.difference(DateTime.now());
    } else {
      _remaining = const Duration(minutes: 15);
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          final expiryDate = context.read<CartProvider>().qrExpiry;

          if (expiryDate != null) {
            setState(() {
              _remaining = expiryDate.difference(DateTime.now());

              if (_remaining.isNegative) {
                _timer.cancel();
              }
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return "00:00";

    String m = d.inMinutes.toString().padLeft(2, '0');

    String s = (d.inSeconds % 60).toString().padLeft(2, '0');

    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppTheme.hsrCyan : AppColors.lBlue;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "PAYMENT TERMINAL",
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildTechnicalHeader(
              accent,
              isDark,
              settings,
            ),
            const SizedBox(height: 14),
            Text(
              'QRIS_PROTOCOL_ACTIVE',
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white : AppTheme.stellarText,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            _buildQRCard(
              isDark,
              accent,
              settings,
            ),
            const SizedBox(height: 38),
            _buildTimerHUD(
              isDark,
              accent,
              settings,
            ),
            const SizedBox(height: 40),
            Text(
              'TOTAL_TRANSACTION_VALUE',
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white24 : AppColors.lTextSub,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            // UPDATED PRICE STYLE - MATCHING CART & CHECKOUT SCREENS
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
            const SizedBox(height: 50),
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

  Widget _buildTechnicalHeader(
    Color accent,
    bool isDark,
    SettingsProvider settings,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 14,
          height: 2,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'SECURE_ENCRYPTED_CHANNEL',
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: accent.withOpacity(0.65),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 14,
          height: 2,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }

  Widget _buildQRCard(
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: isDark
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.92),
                      AppColors.lBgNebula.withOpacity(0.88),
                      AppColors.lPurple.withOpacity(0.06),
                    ],
                  ),
            color: isDark ? Colors.white.withOpacity(0.03) : null,
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
                blurRadius: 34,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.95),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lGlowBlue.withOpacity(0.15),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.qrCode,
                  color: Colors.black,
                  size: 190,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'INTERASTRAL_PAYMENT_NODE_77',
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: isDark ? accent.withOpacity(0.55) : AppColors.lTextSub,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerHUD(
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppTheme.hsrDanger.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.hsrDanger.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.hsrDanger.withOpacity(0.08),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.timer,
            color: AppTheme.hsrDanger,
            size: 16,
          ),
          const SizedBox(width: 12),
          Text(
            'VALID_UNTIL: ${_formatDuration(_remaining)}',
            style: AppFonts.orbitron(
              preset: settings.fontStyle,
              color: AppTheme.hsrDanger,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED BUTTON - MATCHING CART & CHECKOUT SCREENS
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
              'VERIFY_TRANSACTION',
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
