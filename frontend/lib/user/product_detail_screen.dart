import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:honkai_star_retail/core/utils/currency_formatter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../core/app_theme.dart';
import '../core/app_colors.dart';
import '../core/app_fonts.dart';
import '../models/item_model.dart';
import '../models/settings_model.dart';

import '../providers/cart_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/galaxy_ui_helper.dart';

import 'cart_screen.dart';
import '../api/api.dart';

class ProductDetailScreen extends StatefulWidget {
  final Item item;

  const ProductDetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool get isPhone => MediaQuery.of(context).size.width < 430;
  bool get isCompact => MediaQuery.of(context).size.height < 940;

  bool get isEventItem {
    const validEvents = ['aventurine', 'firefly', 'jingliu', 'kafka'];
    return validEvents.contains(widget.item.eventTag);
  }

  Color get eventColor {
    switch (widget.item.eventTag) {
      case 'aventurine':
        return const Color(0xFFFFD54F);
      case 'firefly':
        return const Color(0xFF62F3B1);
      case 'jingliu':
        return const Color(0xFF9ED0FF);
      case 'kafka':
        return const Color(0xFFA56BFF);
      default:
        return AppTheme.hsrCyan;
    }
  }

  String get eventLabel {
    switch (widget.item.eventTag) {
      case 'aventurine':
        return 'STRATEGIC FORTUNE VAULT';
      case 'firefly':
        return 'COMBUSTION OVERDRIVE';
      case 'jingliu':
        return 'FROSTMOON RESONANCE';
      case 'kafka':
        return 'NIHILITY SIGNAL CASCADE';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  late final TextEditingController _qtyController;
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final cart = context.watch<CartProvider>();

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "INTERASTRAL ARCHIVE",
      subtitle: "CELESTIAL_TERMINAL_V4.2",
      showBackButton: true,
      actions: [
        _buildCartButton(
          context,
          isDark,
          cart.cartCount,
        ),
        const SizedBox(width: 10),
      ],
      child: Stack(
        children: [
          if (!isDark) ...[
            Positioned(
              top: -120,
              right: -80,
              child: _LightOrb(
                size: 320,
                color: const Color(0xFF87D7FF).withOpacity(0.16),
              ),
            ),
            Positioned(
              bottom: -180,
              left: -120,
              child: _LightOrb(
                size: 360,
                color: const Color(0xFFD8B7FF).withOpacity(0.14),
              ),
            ),
          ],
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              18,
              6,
              18,
              24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 520,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDashboardSection(
                      isDark,
                      settings,
                    ),
                    const SizedBox(height: 18),
                    _buildPremiumImageCard(
                      isDark,
                      settings,
                      isCompact,
                    ),
                    const SizedBox(height: 8),
                    _buildProductInfo(
                      isDark,
                      isCompact,
                      settings,
                    ),
                    const SizedBox(height: 8),
                    _buildDescriptionGlassBox(
                      isDark,
                      settings,
                    ),
                    const SizedBox(height: 8),
                    _buildQuantityControl(
                      isDark,
                      settings,
                    ),
                    const SizedBox(height: 10),
                    _buildPriceSummary(
                      isDark,
                      settings,
                    ),
                    const SizedBox(height: 10),
                    _buildDualActionButtons(
                      context,
                      isDark,
                      settings,
                    ),
                    SizedBox(
                      height: isCompact ? 8 : 26,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Galaxy Background
  // ─────────────────────────────────────────────────────────────────────────────

  // ─────────────────────────────────────────────────────────────────────────────
  // HEADER – Clean dashboard section (no duplicate title)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildDashboardSection(
    bool isDark,
    SettingsProvider settings,
  ) {
    final accent = isDark ? AppTheme.hsrCyan : AppColors.lBlue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        6,
        4,
        6,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STATUS ROW
          Row(
            children: [
              Container(
                width: 18,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: accent,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(
                        isDark ? 0.45 : 0.28,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'PRODUCT_OVERVIEW',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: accent.withOpacity(
                      isDark ? 0.72 : 0.82,
                    ),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),
        ],
      ),
    );
  }

  Widget _buildCartButton(BuildContext context, bool isDark, int count) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const CartScreen())),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.white.withOpacity(0.03)
                    ])
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.90),
                        const Color(0xFFEAF2FF).withOpacity(0.75)
                      ],
                    ),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? Colors.white10
                    : AppColors.lBorderGlow.withOpacity(0.25),
              ),
            ),
            child: Icon(LucideIcons.shoppingCart,
                color: isDark ? AppTheme.hsrCyan : AppColors.lBlue, size: 18),
          ),
          if (count > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                    color: AppTheme.hsrDanger, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text('$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Premium Image Card
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildPremiumImageCard(
      bool isDark, SettingsProvider settings, bool isCompact) {
    final ultra = settings.intensity == GalaxyIntensity.ultra;
    final adaptiveColor = isEventItem
        ? eventColor
        : widget.item.category == 'RESOURCE'
            ? (isDark ? AppTheme.hsrCyan : AppColors.lBlue)
            : (isDark ? AppTheme.hsrPurple : AppColors.lPurple);

    final rarityColorForStars = widget.item.rarity == '5-star'
        ? (isDark ? const Color(0xFFFFD84D) : const Color(0xFFF5A623))
        : widget.item.rarity == '4-star'
            ? const Color(0xFFB889FF)
            : const Color(0xFF6EC8FF);

    return Container(
      height: isPhone ? 220 : (isCompact ? 250 : 290),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : adaptiveColor.withOpacity(0.14)),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF101A38),
                  Color(0xFF16244D),
                  Color(0xFF0C132B)
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF8FBFF).withOpacity(0.94),
                  const Color(0xFFEAF2FF).withOpacity(0.78),
                  adaptiveColor.withOpacity(0.08),
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: adaptiveColor
                .withOpacity(isDark ? (ultra ? 0.18 : 0.12) : 0.10),
            blurRadius: ultra ? 60 : 38,
            spreadRadius: -12,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isDark)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.03),
                      Colors.transparent,
                      Colors.black.withOpacity(0.18)
                    ],
                  ),
                ),
              ),
            ),
          if (!isDark)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.transparent,
                      adaptiveColor.withOpacity(0.03)
                    ],
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: isCompact ? 160 : 190,
                height: isCompact ? 160 : 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: adaptiveColor.withOpacity(isDark ? 0.14 : 0.10),
                      width: 1.4),
                  boxShadow: [
                    BoxShadow(
                        color: adaptiveColor.withOpacity(isDark ? 0.10 : 0.04),
                        blurRadius: 40)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: adaptiveColor.withOpacity(isDark ? 0.22 : 0.10),
                      blurRadius: 120,
                      spreadRadius: 10)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 180,
                height: 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: adaptiveColor.withOpacity(isDark ? 0.22 : 0.12),
                        blurRadius: 100,
                        spreadRadius: 10)
                  ],
                ),
              ),
            ),
          ),

          // RARITY SECTION
          Positioned(
            top: 16,
            left: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.item.rarity == '5-star'
                    ? 5
                    : widget.item.rarity == '4-star'
                        ? 4
                        : 3,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: rarityColorForStars
                              .withOpacity(isDark ? 0.22 : 0.35),
                          blurRadius: 10)
                    ],
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: rarityColorForStars,
                    shadows: [
                      Shadow(
                          color: rarityColorForStars
                              .withOpacity(isDark ? 0.38 : 0.45),
                          blurRadius: isDark ? 10 : 12),
                      if (!isDark && widget.item.rarity == '5-star')
                        const Shadow(
                          color: Color(0xFFFFD180),
                          blurRadius: 16,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // CATEGORY
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withOpacity(0.22)
                    : Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: adaptiveColor.withOpacity(0.18)),
              ),
              child: Text(
                widget.item.category,
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: adaptiveColor,
                  fontSize: 7.2,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          // LIMITED BADGE
          if (isEventItem)
            Positioned(
              bottom: 18,
              right: 18,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                      colors: [eventColor, eventColor.withOpacity(0.72)]),
                  boxShadow: [
                    BoxShadow(
                        color: eventColor.withOpacity(0.35),
                        blurRadius: 26,
                        spreadRadius: -4)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.clock3,
                        color: Colors.white, size: 13),
                    const SizedBox(width: 8),
                    Text(
                      'LIMITED EVENT',
                      style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color: Colors.white,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // IMAGE
          Center(
            child: Hero(
              tag: 'item-${widget.item.id}',
              child: widget.item.imagePath != null && widget.item.imagePath!.isNotEmpty
                  ? TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.96, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOut,
                      builder: (context, scale, child) =>
                          Transform.scale(scale: scale, child: child),
                      child: Padding(
                        padding: EdgeInsets.all(isCompact ? 18 : 22),
                        child: widget.item.imagePath!.startsWith('assets/')
                            ? Image.asset(widget.item.imagePath!,
                                height: isCompact ? 150 : 180,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high)
                            : Image.network(
                                widget.item.imagePath!.startsWith('http')
                                    ? widget.item.imagePath!
                                    : '${Api.baseUrl}/${widget.item.imagePath!}',
                                height: isCompact ? 150 : 180,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(widget.item.emoji,
                                        style: TextStyle(fontSize: isCompact ? 90 : 120)),
                              ),
                      ),
                    )
                  : Text(widget.item.emoji,
                      style: TextStyle(fontSize: isCompact ? 90 : 120)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(
      bool isDark, bool isCompact, SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.item.name.toUpperCase(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: isDark ? Colors.white : AppColors.lTextMain,
            fontSize: isCompact ? 22 : 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            height: 1.08,
          ),
        ),
        if (isEventItem) ...[
          const SizedBox(height: 12),
          // ENHANCED EVENT LABEL CONTAINER - BETTER CONTRAST FOR LIGHT MODE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              // Light mode: solid pastel background with higher opacity for better contrast
              // Dark mode: keep original gradient style
              color: isDark ? null : eventColor.withOpacity(0.15),
              gradient: isDark
                  ? LinearGradient(colors: [
                      eventColor.withOpacity(0.22),
                      eventColor.withOpacity(0.08)
                    ])
                  : null,
              border: Border.all(
                color: isDark
                    ? eventColor.withOpacity(0.45)
                    : eventColor.withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                    color: eventColor.withOpacity(isDark ? 0.22 : 0.18),
                    blurRadius: 22,
                    spreadRadius: -6),
                if (!isDark)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.sparkles,
                  color: eventColor,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  eventLabel,
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    // Light mode: darker color for contrast on pastel background
                    color: isDark ? eventColor : const Color(0xFF1A2A4A),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INTERASTRAL PRICE',
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: isDark
                        ? Colors.white.withOpacity(0.46)
                        : AppColors.lTextSub,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  CurrencyFormatter.format(widget.item.price),
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: isDark ? AppTheme.hsrGold : const Color(0xFFE0B100),
                    fontSize: isCompact ? 34 : 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                    height: 1,
                    shadows: [
                      Shadow(
                          color: isDark
                              ? AppTheme.hsrGold.withOpacity(0.55)
                              : const Color(0xFFFFD84D).withOpacity(0.35),
                          blurRadius: 24),
                      const Shadow(
                        color: Color(0xFFFFC933),
                        blurRadius: 52,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildStockBadge(isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildStockBadge(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 14 : 16, vertical: isCompact ? 10 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF102C36), const Color(0xFF163847)]
              : [const Color(0xFFDDF8F1), const Color(0xFFC8F0E5)],
        ),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3DD6BE).withOpacity(0.45)
              : const Color(0xFF3DD6BE).withOpacity(0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF3DD6BE).withOpacity(0.12)
                : const Color(0xFF6FE7D2).withOpacity(0.10),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        'STOCK: ${widget.item.stock}',
        style: TextStyle(
          color: isDark ? const Color(0xFF7FFFE1) : const Color(0xFF4B9B8A),
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          fontSize: isCompact ? 11 : 12,
        ),
      ),
    );
  }

  Widget _buildDescriptionGlassBox(bool isDark, SettingsProvider settings) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: isDark ? 12 : 24, sigmaY: isDark ? 12 : 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(colors: [
                    Colors.white.withOpacity(0.04),
                    Colors.white.withOpacity(0.02)
                  ])
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF9FBFF).withOpacity(0.82),
                      AppColors.lPurple.withOpacity(0.08)
                    ],
                  ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: isDark
                    ? Colors.white10
                    : AppColors.lPurple.withOpacity(0.14)),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                    color: AppColors.lBlue.withOpacity(0.08),
                    blurRadius: 26,
                    spreadRadius: -10,
                    offset: const Offset(0, 14)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppTheme.hsrCyan.withOpacity(0.10)
                          : AppColors.lPurple.withOpacity(0.10),
                    ),
                    child: Icon(LucideIcons.fileText,
                        color: isDark ? AppTheme.hsrCyan : AppColors.lPurple,
                        size: 14),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ARCHIVE DESCRIPTION',
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: isDark ? Colors.white38 : AppColors.lTextSub,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.item.desc,
                style: GoogleFonts.exo2(
                    color:
                        isDark ? const Color(0xFFB8C7E6) : AppColors.lTextMid,
                    fontSize: 11.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl(bool isDark, SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]
              : [Colors.white, const Color(0xFFF6FAFF)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? Colors.white10 : Colors.white.withOpacity(0.55)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
                color: AppColors.lBlue.withOpacity(0.06),
                blurRadius: 20,
                spreadRadius: -6,
                offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Text(
            'QUANTITY',
            style: AppFonts.orbitron(
              preset: settings.fontStyle,
              color: isDark ? Colors.white70 : AppColors.lTextSub,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
          const Spacer(),
          _qtyBtn(LucideIcons.minus, () {
            setState(() {
              _qty = _qty > 1 ? _qty - 1 : 1;
              _qtyController.text = _qty.toString();
            });
          }, isDark),
          const SizedBox(width: 14),
          Container(
            width: 58,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark
                      ? Colors.white12
                      : AppColors.lBlue.withOpacity(0.12)),
            ),
            child: TextField(
              controller: _qtyController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              cursorColor: isDark ? AppTheme.hsrCyan : AppColors.lBlue,
              style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: isDark ? Colors.white : AppColors.lTextMain,
                  fontSize: 17,
                  fontWeight: FontWeight.w900),
              decoration: const InputDecoration(
                  border: InputBorder.none, isCollapsed: true),
              onChanged: (value) {
                if (value.isEmpty) return;
                final parsed = int.tryParse(value);
                if (parsed == null) {
                  _qtyController.text = _qty.toString();
                  _qtyController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _qtyController.text.length));
                  return;
                }
                if (parsed < 1)
                  _qty = 1;
                else if (parsed > widget.item.stock)
                  _qty = widget.item.stock;
                else
                  _qty = parsed;
                _qtyController.text = _qty.toString();
                _qtyController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _qtyController.text.length));
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 14),
          _qtyBtn(LucideIcons.plus, () {
            setState(() {
              if (_qty < widget.item.stock) _qty++;
              _qtyController.text = _qty.toString();
            });
          }, isDark),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              isDark ? const Color(0xFF1B2755).withOpacity(0.75) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: isDark ? Colors.white12 : Colors.white.withOpacity(0.55)),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                  color: AppColors.lBlue.withOpacity(0.08),
                  blurRadius: 18,
                  spreadRadius: -4),
          ],
        ),
        child: Icon(icon,
            color: isDark ? AppTheme.hsrCyan : AppColors.lBlue, size: 18),
      ),
    );
  }

  Widget _buildPriceSummary(bool isDark, SettingsProvider settings) {
    final total = CurrencyFormatter.format(widget.item.price * _qty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
            color:
                isDark ? Colors.white10 : AppTheme.hsrGold.withOpacity(0.14)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
                color: AppTheme.hsrGold.withOpacity(0.08),
                blurRadius: 24,
                spreadRadius: -8,
                offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ESTIMATED COST',
            style: AppFonts.orbitron(
              preset: settings.fontStyle,
              color: isDark ? Colors.white38 : AppColors.lTextSub,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
          Text(
            total,
            style: AppFonts.orbitron(
              preset: settings.fontStyle,
              color: isDark ? AppTheme.hsrGold : const Color(0xFFE0B100),
              fontWeight: FontWeight.w900,
              fontSize: isCompact ? 22 : 26,
              letterSpacing: -0.6,
              shadows: [
                Shadow(
                  color: isDark
                      ? AppTheme.hsrGold.withOpacity(0.42)
                      : const Color(0xFFFFD84D).withOpacity(0.28),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualActionButtons(
      BuildContext context, bool isDark, SettingsProvider settings) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: GestureDetector(
            onTap: () {
              context.read<CartProvider>().addToCart(widget.item, _qty);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF101E42) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: isDark
                              ? AppTheme.hsrCyan.withOpacity(0.20)
                              : AppColors.lBlue.withOpacity(0.14)),
                    ),
                    child: Text(
                      'Transferred to Interastral Cart',
                      style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color: isDark ? Colors.white : AppColors.lTextMain,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: (isDark ? AppTheme.hsrCyan : AppColors.lBlue)
                          .withOpacity(isDark ? 0.12 : 0.08),
                      blurRadius: 24,
                      spreadRadius: -8,
                      offset: const Offset(0, 10)),
                ],
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: isDark ? AppTheme.hsrCyan : AppColors.lBlue,
                    width: 1.8),
              ),
              alignment: Alignment.center,
              child: Text(
                '+ ADD TO CART',
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: isDark ? AppTheme.hsrCyan : AppColors.lBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1.8,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 6,
          child: GestureDetector(
            onTap: () {
              context.read<CartProvider>().addToCart(widget.item, _qty);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen()));
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: isDark
                        ? [AppTheme.hsrCyan, AppTheme.hsrPurple]
                        : [AppColors.lBlue, AppColors.lPurple]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: (isDark ? AppTheme.hsrCyan : AppColors.lBlue)
                          .withOpacity(0.35),
                      blurRadius: 30,
                      spreadRadius: -4,
                      offset: const Offset(0, 12)),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'BUY NOW',
                    style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 2),
                  ),
                  const SizedBox(width: 12),
                  const Icon(LucideIcons.arrowRight,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// Supporting classes (_StarField, _StarPainter, _LightOrb, _GridPainter)
// ---------------------------------------------------------------------

class _LightOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _LightOrb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: color,
                  blurRadius: size * 0.65,
                  spreadRadius: size * 0.12)
            ],
          ),
        ),
      );
}
