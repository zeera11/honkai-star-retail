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
import '../api/api.dart';

import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppTheme.hsrCyan : AppTheme.stellarPrimary;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "Interastral Cart",
      useScroll: false,
      child: Stack(
        children: [
          // LIGHT MODE ATMOSPHERE
          if (!isDark) ...[
            Positioned(
              top: -120,
              right: -80,
              child: _buildLightOrb(
                const Color(0xFF87D7FF),
                320,
              ),
            ),
            Positioned(
              bottom: -180,
              left: -120,
              child: _buildLightOrb(
                const Color(0xFFD8B7FF),
                360,
              ),
            ),
          ],

          Column(
            children: [
              Expanded(
                child: cartProvider.cart.isEmpty
                    ? _buildEmptyState(
                        isDark,
                        accent,
                        settings,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          18,
                          18,
                          24,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartProvider.cart.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return _buildCartHUDCard(
                            context,
                            cartProvider.cart[index],
                            isDark,
                            accent,
                            settings,
                          );
                        },
                      ),
              ),
              if (cartProvider.cart.isNotEmpty)
                _buildPaymentFooter(
                  context,
                  cartProvider,
                  isDark,
                  accent,
                  settings,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLightOrb(
    Color color,
    double size,
  ) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.14),
              blurRadius: 140,
              spreadRadius: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartHUDCard(
    BuildContext context,
    CartItem cartItem,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    final themeColor = cartItem.item.category == 'RESOURCE'
        ? AppTheme.hsrCyan
        : AppTheme.hsrPurple;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF131F46),
                  Color(0xFF182754),
                  Color(0xFF0E1633),
                ],
                stops: [0.0, 0.48, 1.0],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.90),
                  const Color(0xFFF6F9FF).withOpacity(0.82),
                  const Color(0xFFE9F1FF).withOpacity(0.70),
                ],
              ),
        border: Border.all(
          color: themeColor.withOpacity(
            isDark ? 0.24 : 0.14,
          ),
          width: 1.1,
        ),
        backgroundBlendMode: BlendMode.srcOver,
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(
              isDark ? 0.12 : 0.10,
            ),
            blurRadius: 30,
            spreadRadius: -10,
            offset: const Offset(
              0,
              16,
            ),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.70),
              blurRadius: 10,
              spreadRadius: -4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Stack(
            children: [
              // LIGHT SHIMMER
              if (!isDark)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.14),
                            Colors.transparent,
                            themeColor.withOpacity(0.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // ATMOSPHERIC GLOW
              Positioned(
                bottom: -20,
                right: -16,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withOpacity(
                          isDark ? 0.20 : 0.14,
                        ),
                        blurRadius: 60,
                      ),
                    ],
                  ),
                ),
              ),
// TOP EDGE LIGHT
              Positioned(
                top: 0,
                left: 18,
                right: 18,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    Container(
                      width: 88,
                      height: 98,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: isDark
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(0.24),
                                  themeColor.withOpacity(0.06),
                                ],
                              )
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  themeColor.withOpacity(0.05),
                                ],
                              ),
                        border: Border.all(
                          color: isDark
                              ? Colors.white10
                              : Colors.white.withOpacity(0.60),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -14,
                            right: -14,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(0.18),
                                    blurRadius: 42,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: cartItem.item.imagePath != null && cartItem.item.imagePath!.isNotEmpty
                                ? Hero(
                                    tag: 'item-${cartItem.item.id}',
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: themeColor.withOpacity(
                                                isDark ? 0.22 : 0.08,
                                              ),
                                              blurRadius: 20,
                                              spreadRadius: -6,
                                            ),
                                          ],
                                        ),
                                        child: cartItem.item.imagePath!.startsWith('assets/')
                                            ? Image.asset(
                                                cartItem.item.imagePath!,
                                                fit: BoxFit.contain,
                                                filterQuality: FilterQuality.high,
                                              )
                                            : Image.network(
                                                cartItem.item.imagePath!.startsWith('http')
                                                    ? cartItem.item.imagePath!
                                                    : '${Api.baseUrl}/${cartItem.item.imagePath!}',
                                                fit: BoxFit.contain,
                                                filterQuality: FilterQuality.high,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Text(
                                                  cartItem.item.emoji,
                                                  style: const TextStyle(fontSize: 38),
                                                ),
                                              ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    cartItem.item.emoji,
                                    style: const TextStyle(
                                      fontSize: 38,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.orbitron(
                                        preset: settings.fontStyle,
                                        color: isDark
                                            ? Colors.white
                                            : AppTheme.stellarText,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11.8,
                                        height: 1.32,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: List.generate(
                                        int.parse(
                                          cartItem.item.rarity.split('-')[0],
                                        ),
                                        (index) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 2,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.hsrGold
                                                      .withOpacity(
                                                    0.30,
                                                  ),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.star_rounded,
                                              size: 12.5,
                                              color: AppTheme.hsrGold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    context.read<CartProvider>().removeItem(
                                          cartItem.item.id,
                                        ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.hsrDanger.withOpacity(0.16),
                                        AppTheme.hsrDanger.withOpacity(0.06),
                                      ],
                                    ),
                                    border: Border.all(
                                      color:
                                          AppTheme.hsrDanger.withOpacity(0.18),
                                    ),
                                  ),
                                  child: const Icon(
                                    LucideIcons.trash2,
                                    color: AppTheme.hsrDanger,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // PRICE + QTY
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark
                                          ? AppTheme.hsrGold.withOpacity(0.10)
                                          : const Color(0xFFFFE7A8)
                                              .withOpacity(0.62),
                                    ),
                                    child: Icon(
                                      LucideIcons.coins,
                                      size: 12,
                                      color: isDark
                                          ? AppTheme.hsrGold
                                          : const Color(0xFFE0AE2D),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    CurrencyFormatter.format(
                                      cartItem.item.price * cartItem.qty,
                                    ),
                                    style: AppFonts.orbitron(
                                      preset: settings.fontStyle,
                                      color: isDark
                                          ? AppTheme.hsrGold
                                          : const Color(0xFFE0AE2D),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      shadows: [
                                        Shadow(
                                          color: isDark
                                              ? AppTheme.hsrGold
                                                  .withOpacity(0.34)
                                              : const Color(0xFFFFD86B)
                                                  .withOpacity(0.24),
                                          blurRadius: 12,
                                        ),
                                        if (!isDark)
                                          Shadow(
                                            color: const Color(0xFFFFF2B3)
                                                .withOpacity(0.14),
                                            blurRadius: 26,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              _buildQtyControlHUD(
                                context,
                                cartItem,
                                isDark,
                                themeColor,
                                settings,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyControlHUD(
    BuildContext context,
    CartItem cartItem,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent.withOpacity(0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtySmallBtn(
            LucideIcons.minus,
            () => context.read<CartProvider>().updateQuantity(
                  cartItem.item.id,
                  -1,
                ),
            isDark,
            accent,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Text(
              '${cartItem.qty}',
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white : AppTheme.stellarText,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
          _qtySmallBtn(
            LucideIcons.plus,
            () => context.read<CartProvider>().updateQuantity(
                  cartItem.item.id,
                  1,
                ),
            isDark,
            accent,
          ),
        ],
      ),
    );
  }

  Widget _qtySmallBtn(
    IconData icon,
    VoidCallback onTap,
    bool isDark,
    Color accent,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.06),
                    Colors.white.withOpacity(0.02),
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFF8FBFF),
                    Color(0xFFEAF2FF),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white10
                : AppTheme.hologramCyan.withOpacity(0.16),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: AppTheme.hologramCyan.withOpacity(0.08),
                blurRadius: 12,
              ),
          ],
        ),
        child: Icon(
          icon,
          color: accent,
          size: 13,
        ),
      ),
    );
  }

  Widget _buildPaymentFooter(
    BuildContext context,
    CartProvider cart,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(36),
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
                      Color(0xEE0D1B3E),
                      Color(0xFF101E42),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.94),
                      const Color(0xFFF5F8FF).withOpacity(0.86),
                      const Color(0xFFEAF1FF).withOpacity(0.74),
                    ],
                  ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(36),
            ),
            border: Border.all(
              color: accent.withOpacity(0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(
                  isDark ? 0.16 : 0.10,
                ),
                blurRadius: 40,
                spreadRadius: -10,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INTERASTRAL TOTAL',
                        style: AppFonts.orbitron(
                          preset: settings.fontStyle,
                          color: isDark ? Colors.white30 : AppColors.lTextSub,
                          fontSize: 8.4,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.1,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accent.withOpacity(0.20),
                          accent.withOpacity(0.06),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.20),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.wallet,
                      color: accent,
                      size: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // CHECKOUT BUTTON - REDESIGNED
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CheckoutScreen(),
                  ),
                ),
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
                        'INITIALIZE CHECKOUT',
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
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(
                      0.16,
                    ),
                    accent.withOpacity(
                      0.04,
                    ),
                  ],
                ),
              ),
              child: Icon(
                LucideIcons.shoppingCart,
                color: accent.withOpacity(0.8),
                size: 52,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'CART_EMPTY_SIGNAL',
              textAlign: TextAlign.center,
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white38 : AppColors.lTextSub,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No synchronized interastral archives detected inside the terminal cart.',
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(
                color: isDark ? Colors.white24 : AppColors.lTextSub,
                fontSize: 12,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
