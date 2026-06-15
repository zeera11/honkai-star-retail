// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:honkai_star_retail/core/utils/currency_formatter.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../api/api.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/app_fonts.dart';

import '../models/item_model.dart';
import '../models/settings_model.dart';

// ignore: unused_import
import '../providers/inventory_provider.dart';
import '../providers/settings_provider.dart';

import '../data/events/firefly_event_items.dart';
import '../data/events/kafka_event_items.dart';
import '../data/events/jingliu_event_items.dart';
import '../data/events/aventurine_event_items.dart';

import 'product_detail_screen.dart';

class EventCollectionScreen extends StatelessWidget {
  final String title;
  final String bannerImage;
  final String eventTag;
  final String eventTitle;
  final String eventDesc;

  const EventCollectionScreen({
    super.key,
    required this.title,
    required this.bannerImage,
    required this.eventTag,
    required this.eventTitle,
    required this.eventDesc,
  });

  List<Item> _getEventItems() {
    switch (eventTag) {
      case 'firefly':
        return fireflyEventItems;

      case 'kafka':
        return kafkaEventItems;

      case 'jingliu':
        return jingliuEventItems;

      case 'aventurine':
        return aventurineEventItems;

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final isUltra = settings.intensity == GalaxyIntensity.ultra;

    final List<Item> eventItems = _getEventItems();

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(isDark),

          // LIGHT MODE ATMOSPHERE
          if (!isDark) ...[
            Positioned(
              top: -120,
              right: -40,
              child: _buildLightOrb(
                const Color(0xFF8FD3FF),
                260,
              ),
            ),
            Positioned(
              bottom: -160,
              left: -60,
              child: _buildLightOrb(
                const Color(0xFFD9B8FF),
                320,
              ),
            ),
            Positioned(
              top: 220,
              left: -70,
              child: _buildLightOrb(
                const Color(0xFFFFF2B6),
                220,
              ),
            ),
          ],

          SafeArea(
            child: Column(
              children: [
                _buildHeader(
                  context,
                  isDark,
                  settings,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        FadeInDown(
                          duration: const Duration(
                            milliseconds: 700,
                          ),
                          child: _buildBanner(
                            isDark,
                            isUltra,
                            eventItems.length,
                            settings,
                          ),
                        ),
                        const SizedBox(height: 22),
                        FadeInUp(
                          duration: const Duration(
                            milliseconds: 700,
                          ),
                          child: _buildEventInfo(
                            isDark,
                            settings,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildGrid(
                          context,
                          eventItems,
                          isDark,
                          settings,
                        ),
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _accentColor() {
    switch (eventTag) {
      // FIREFLY
      case 'firefly':
        return const Color(0xFFFF8A4E);

      // KAFKA
      case 'kafka':
        return const Color(0xFFC86BFF);

      // JINGLIU
      case 'jingliu':
        return const Color(0xFF9EDCFF);

      // AVENTURINE
      case 'aventurine':
        return const Color(0xFFFFD86B);

      default:
        return AppTheme.hsrCyan;
    }
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
              color: color.withOpacity(0.16),
              blurRadius: 140,
              spreadRadius: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    final accent = _accentColor();

    Color secondaryAccent;

    switch (eventTag) {
      case 'firefly':
        secondaryAccent = const Color(0xFFFF5A36);
        break;

      case 'kafka':
        secondaryAccent = const Color(0xFF6E3DFF);
        break;

      case 'jingliu':
        secondaryAccent = const Color(0xFFBFE9FF);
        break;

      case 'aventurine':
        secondaryAccent = const Color(0xFF72FFD2);
        break;

      default:
        secondaryAccent = accent;
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF02050D),
                      const Color(0xFF081225),
                      secondaryAccent.withOpacity(0.12),
                    ]
                  : [
                      const Color(0xFFF8FBFF),
                      const Color(0xFFEEF5FF),
                      const Color(0xFFE5F0FF),
                      const Color(0xFFFDFEFF),
                    ],
            ),
          ),
        ),

        // STAR PARTICLES DARK MODE
        if (isDark)
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.10,
                // child: Image.asset(
                //   'assets/images/stars_bg.png',
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          ),

        // DARK MODE GLOWS
        if (isDark) ...[
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.18),
                    blurRadius: 140,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.12),
                    blurRadius: 160,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
        ],

        // LIGHT MODE GRID TEXTURE
        if (!isDark)
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              // child: Image.asset(
              //   'assets/images/grid_overlay.png',
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    SettingsProvider settings,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 12,
                  sigmaY: 12,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.70),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark
                          ? Colors.white10
                          : Colors.white.withOpacity(0.55),
                    ),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: AppColors.lBlue.withOpacity(0.10),
                          blurRadius: 24,
                          spreadRadius: -4,
                        ),
                    ],
                  ),
                  child: Icon(
                    LucideIcons.arrowLeft,
                    size: 18,
                    color: isDark ? AppTheme.hsrCyan : AppColors.lBlue,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'LIMITED EVENT ARCHIVE',
              overflow: TextOverflow.ellipsis,
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white : AppTheme.stellarText,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(
    bool isDark,
    bool isUltra,
    int totalItems,
    SettingsProvider settings,
  ) {
    final accent = _accentColor();

    return Container(
      height: isUltra ? 240 : 210,
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(
              isDark ? 0.24 : 0.18,
            ),
            blurRadius: 48,
            spreadRadius: -10,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              bannerImage,
              fit: BoxFit.cover,
            ),

            // DARK OVERLAY
            if (isDark)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF020617).withOpacity(0.88),
                      const Color(0xFF050816).withOpacity(0.34),
                    ],
                  ),
                ),
              ),

            // LIGHT OVERLAY - IMPROVED (less washed out)
            if (!isDark)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFFEDF5FF).withOpacity(0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

            // CINEMATIC LOWER FADE
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(
                        isDark ? 0.34 : 0.10,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // LIGHT MODE SHIMMER - REDUCED OPACITY
            if (!isDark)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.05), // Reduced from 0.14
                          Colors.transparent,
                          accent.withOpacity(0.06),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // DIAGONAL HOLOGRAM
            if (!isDark)
              Positioned(
                top: -30,
                left: -80,
                child: IgnorePointer(
                  child: Transform.rotate(
                    angle: -0.34,
                    child: Container(
                      width: 220,
                      height: 420,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // ATMOSPHERIC GLOW
            Positioned(
              right: -50,
              top: -20,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(
                        isDark ? 0.24 : 0.16,
                      ),
                      blurRadius: 120,
                      spreadRadius: 12,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // LIMITED CHIP - IMPROVED CONTRAST
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 12,
                        sigmaY: 12,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accent.withOpacity(0.18),
                          ),
                        ),
                        child: Text(
                          'LIMITED EVENT',
                          style: AppFonts.orbitron(
                            preset: settings.fontStyle,
                            color: isDark
                                ? accent
                                : const Color(0xFF8A5E00), // Better contrast
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // TITLE
                  SizedBox(
                    width: 220,
                    child: Text(
                      title,
                      style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color: isDark ? Colors.white : const Color(0xFF17325E),
                        fontSize: 20,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ITEM COUNT
                  Text(
                    '$totalItems synchronized archives available',
                    style: GoogleFonts.exo2(
                      color: isDark ? Colors.white70 : const Color(0xFF35527F),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfo(
    bool isDark,
    SettingsProvider settings,
  ) {
    final accent = _accentColor();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.92),
                        const Color(0xFFF4F8FF).withOpacity(0.82),
                        const Color(0xFFE9F1FF).withOpacity(0.70),
                      ],
                    ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: accent.withOpacity(0.16),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: accent.withOpacity(0.10),
                    blurRadius: 34,
                    spreadRadius: -8,
                    offset: const Offset(0, 18),
                  ),
              ],
            ),
            child: Stack(
              children: [
                // LIGHT MODE SHIMMER
                if (!isDark)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.14),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withOpacity(0.12),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.16),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Icon(
                            LucideIcons.sparkles,
                            size: 13,
                            color: isDark
                                ? accent
                                : const Color(0xFF9A6A00), // Better contrast
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            eventTitle,
                            style: AppFonts.orbitron(
                              preset: settings.fontStyle,
                              color: isDark
                                  ? accent
                                  : const Color(0xFF9A6A00), // Better contrast
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      eventDesc,
                      style: GoogleFonts.exo2(
                        color: isDark
                            ? const Color(0xFFB8C7E6)
                            : AppColors.lTextSub,
                        fontSize: 12.6,
                        height: 1.72,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<Item> items,
    bool isDark,
    SettingsProvider settings,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        18,
        4,
        18,
        18,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.74,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        final themeColor = item.category == 'LIGHT CONE'
            ? AppTheme.hsrPurple
            : AppTheme.hsrCyan;

        final rarityColor = item.rarity == '5-star'
            ? const Color(0xFFFFD66B)
            : item.rarity == '4-star'
                ? const Color(0xFFB889FF)
                : const Color(0xFF6EC8FF);

        return FadeInUp(
          delay: Duration(milliseconds: 60 * index),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(
                    item: item,
                  ),
                ),
              );
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: isDark
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF101A3A),
                          Color(0xFF16244D),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.98),
                          const Color(0xFFF9FBFF).withOpacity(0.96),
                          const Color(0xFFEAF2FF).withOpacity(0.88),
                        ],
                      ),
                border: Border.all(
                  color: themeColor.withOpacity(
                    isDark ? 0.18 : 0.20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(
                      isDark ? 0.10 : 0.12,
                    ),
                    blurRadius: 28,
                    spreadRadius: -10,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Stack(
                        children: [
                          // LIGHT MODE SHEEN
                          // DARK MODE ATMOSPHERIC TOP LIGHT
                          if (isDark)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withOpacity(0.045),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.10),
                                      ],
                                      stops: const [
                                        0.0,
                                        0.45,
                                        1.0,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: Container(
                              width: 85,
                              height: 85,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(
                                      0.20,
                                    ),
                                    blurRadius: 38,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // UPDATED RARITY STARS - MATCHING HOME SCREEN
                          Positioned(
                            top: 2,
                            left: 2,
                            child: Row(
                              children: List.generate(
                                item.rarity.startsWith('5')
                                    ? 5
                                    : item.rarity.startsWith('4')
                                        ? 4
                                        : 3,
                                (index) => Container(
                                  margin: const EdgeInsets.only(right: 2),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: rarityColor.withOpacity(
                                          isDark ? 0.22 : 0.35,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: rarityColor,
                                    shadows: [
                                      Shadow(
                                        color: rarityColor.withOpacity(
                                          isDark ? 0.38 : 0.45,
                                        ),
                                        blurRadius: isDark ? 10 : 12,
                                      ),
                                      if (!isDark && item.rarity == '5-star')
                                        Shadow(
                                          color: const Color(0xFFFFD180)
                                              .withOpacity(0.38),
                                          blurRadius: 16,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // LIMITED BADGE
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    themeColor.withOpacity(0.90),
                                    themeColor.withOpacity(0.60),
                                  ],
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                ),
                              ),
                              child: Text(
                                'EVENT',
                                style: AppFonts.orbitron(
                                  preset: settings.fontStyle,
                                  color: Colors.white,
                                  fontSize: 6.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),

                          Center(
                            child: Hero(
                              tag: 'item-${item.id}',
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: item.imagePath != null && item.imagePath!.isNotEmpty
                                    ? (item.imagePath!.startsWith('assets/')
                                        ? Image.asset(
                                            item.imagePath!,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            item.imagePath!.startsWith('http')
                                                ? item.imagePath!
                                                : '${Api.baseUrl}/${item.imagePath!}',
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Text(item.emoji,
                                                    style: const TextStyle(fontSize: 42)),
                                          ))
                                    : Text(item.emoji,
                                        style: const TextStyle(fontSize: 42)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      0,
                      14,
                      14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.orbitron(
                            preset: settings.fontStyle,
                            color: isDark ? Colors.white : AppTheme.stellarText,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? AppTheme.hsrGold.withOpacity(0.12)
                                    : const Color(0xFFFFD86B).withOpacity(0.26),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? AppTheme.hsrGold.withOpacity(0.16)
                                        : const Color(0xFFFFD66B)
                                            .withOpacity(0.22),
                                    blurRadius: 10,
                                    spreadRadius: -2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                LucideIcons.badgeDollarSign,
                                size: 13,
                                color: isDark
                                    ? AppTheme.hsrGold
                                    : const Color(0xFFE0A92B),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              CurrencyFormatter.format(item.price),
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                color: isDark
                                    ? AppTheme.hsrGold
                                    : const Color(0xFFB8860B),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  if (!isDark)
                                    Shadow(
                                      color: const Color(0xFFFFE082)
                                          .withOpacity(0.36),
                                      blurRadius: 6,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
