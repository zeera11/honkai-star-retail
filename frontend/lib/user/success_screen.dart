import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/app_fonts.dart';

import '../providers/cart_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/galaxy_ui_helper.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    final inventory = context.read<InventoryProvider>();

    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppTheme.hsrCyan : AppColors.lBlue;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "TRANSACTION SUCCESS",
      showBackButton: false,
      useScroll: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSuccessIcon(
              isDark,
              accent,
            ),
            const SizedBox(height: 42),
            Text(
              'PAYMENT_CONFIRMED',
              textAlign: TextAlign.center,
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white : AppTheme.stellarText,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Interastral synchronization completed successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(
                color: isDark ? const Color(0xFF8FA8D8) : AppColors.lTextSub,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            _buildReceiptCard(
              cart.orderId ?? 'HSR-X7',
              isDark,
              accent,
              settings,
            ),
            const SizedBox(height: 58),
            _buildReturnButton(
              context,
              cart,
              inventory,
              isDark,
              accent,
              settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(
    bool isDark,
    Color accent,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF00FF88).withOpacity(
                  isDark ? 0.22 : 0.12,
                ),
                Colors.transparent,
              ],
            ),
          ),
        ),
        if (!isDark)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.lCyan.withOpacity(0.12),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 12,
              sigmaY: 12,
            ),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDark
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(
                            0.92,
                          ),
                          AppColors.lBgNebula.withOpacity(0.9),
                        ],
                      ),
                color: isDark ? Colors.white.withOpacity(0.05) : null,
                border: Border.all(
                  color: const Color(0xFF00FF88).withOpacity(0.28),
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF88).withOpacity(
                      isDark ? 0.18 : 0.12,
                    ),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.checkCircle2,
                color: Color(0xFF00D97E),
                size: 72,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptCard(
    String orderId,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.94),
                  AppColors.lBgNebula.withOpacity(0.92),
                  AppColors.lPurple.withOpacity(0.05),
                ],
              ),
        color: isDark ? Colors.white.withOpacity(0.04) : null,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: accent.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(
              isDark ? 0.08 : 0.10,
            ),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'TRANSACTION_ID',
            style: AppFonts.orbitron(
              preset: settings.fontStyle,
              color: isDark ? Colors.white24 : AppColors.lTextSub,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            orderId,
            textAlign: TextAlign.center,
            style: AppFonts.orbitron(
              preset: settings.fontStyle,
              color: isDark ? accent : AppColors.lBlue,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  accent.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.shieldCheck,
                color: Color(0xFF00D97E),
                size: 16,
              ),
              const SizedBox(width: 10),
              Text(
                'ORDER_SYNC_COMPLETE',
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: const Color(0xFF00D97E).withOpacity(0.72),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReturnButton(
    BuildContext context,
    CartProvider cart,
    InventoryProvider inventory,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return GestureDetector(
      onTap: () {
        for (var cartItem in cart.cart) {
          inventory.reduceStock(
            cartItem.item.id,
            cartItem.qty,
          );
        }

        cart.clearCart();

        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  colors: [
                    AppColors.lBlue,
                    AppColors.lPurple,
                    AppColors.lIndigoDeep,
                  ],
                ),
          color: isDark ? Colors.white.withOpacity(0.05) : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? accent.withOpacity(0.28) : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(
                isDark ? 0.14 : 0.30,
              ),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'RETURN_TO_HOME',
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
