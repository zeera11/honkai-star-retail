import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:honkai_star_retail/core/utils/currency_formatter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'event_collection_screen.dart';
import '../api/api.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/app_fonts.dart';

import '../models/item_model.dart';
import '../models/settings_model.dart';

import '../providers/cart_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';

import '../widgets/galaxy_ui_helper.dart';

import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'profile_page.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String _activeCategory = 'ALL';

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final cart = context.watch<CartProvider>();
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final filteredItems = inventory.items.where((item) {
      // ONLY MAIN SHOP ITEMS
      final isNormalItem = item.eventTag == null;

      // SEARCH
      final matchesSearch = item.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      // CATEGORY
      bool matchesCategory = true;

      if (_activeCategory == 'RESOURCE') {
        matchesCategory = item.category.toUpperCase() == 'RESOURCE';
      }

      if (_activeCategory == 'LIGHT CONE') {
        matchesCategory = item.category.toUpperCase() == 'LIGHT CONE';
      }

      return isNormalItem && matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) {
        if (_activeCategory == 'ALL') {
          return (a.id % 7).compareTo(b.id % 7);
        }

        return 0;
      });

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "HONKAI STAR RETAIL",
      showBackButton: false,
      actions: [
        _buildHeaderAction(
          icon: LucideIcons.user,
          isDark: isDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfilePage(),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        _buildCartAction(
          context,
          cart.cartCount,
          isDark,
        ),
        const SizedBox(width: 10),
      ],
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: _buildWelcomeSection(isDark, settings),
            ),
            if (!inventory.isLoading)
              FadeIn(
                delay: const Duration(
                  milliseconds: 300,
                ),
                child: _buildFeaturedCarousel(
                  isDark,
                ),
              ),
            FadeInUp(
              duration: const Duration(
                milliseconds: 600,
              ),
              delay: const Duration(
                milliseconds: 400,
              ),
              child: _buildSearchBar(
                isDark,
              ),
            ),
            FadeInUp(
              duration: const Duration(
                milliseconds: 600,
              ),
              delay: const Duration(
                milliseconds: 500,
              ),
              child: _buildFilterTabs(
                isDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildMarketplaceGrid(
              filteredItems,
              isDark,
              settings,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDark, dynamic settings) {
    final accent = isDark ? AppTheme.hsrCyan : AppTheme.stellarPrimary;

    final user = context.watch<AuthProvider>().currentUser;

    final username = user?.trailblazerId.toUpperCase() ?? "TRAILBLAZER";

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        12,
        24,
        4,
      ),
      child: Stack(
        children: [
          // ATMOSPHERIC GLOW
          if (!isDark)
            Positioned(
              top: -20,
              left: -10,
              child: IgnorePointer(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lBlue.withOpacity(0.16),
                        blurRadius: 80,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP STATUS
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
                      'INTERASTRAL_CONNECTION_STABLE',
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

              const SizedBox(height: 14),

              // MAIN TITLE
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: isDark
                        ? [
                            Colors.white,
                            const Color(0xFFB8D6FF),
                          ]
                        : [
                            const Color(0xFF17325E),
                            const Color(0xFF456DAB),
                          ],
                  ).createShader(bounds);
                },
                child: Text(
                  'WELCOME, $username',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    height: 1,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // SUBTITLE
              Text(
                'Authorized Interastral Marketplace Access',
                style: GoogleFonts.exo2(
                  color: isDark
                      ? const Color(0xFF9CB7EA)
                      : AppTheme.stellarText.withOpacity(0.68),
                  fontSize: 11.2,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCarousel(
    bool isDark,
  ) {
    final settings = context.watch<SettingsProvider>();

    final bool isUltra = settings.intensity == GalaxyIntensity.ultra;

    final banners = [
      {
        'image': 'assets/images/banner_firefly.jpg',
        'title': 'FIREFLY WARP EVENT',
        'subtitle': 'Limited anti-entropy combat relics are now synchronized →',
        'category': 'LIGHT CONE',
        'eventTag': 'firefly',
        'eventTitle': 'COMBUSTION OVERDRIVE',
        'eventDesc':
            'Experimental combustion-type synchronization relics and SAM combat archives connected to Firefly operations have entered temporary circulation.',
      },
      {
        'image': 'assets/images/banner_kafka.jpg',
        'title': 'KAFKA COLLECTION',
        'subtitle': 'Forbidden Stellaron resonance archives unlocked →',
        'category': 'LIGHT CONE',
        'eventTag': 'kafka',
        'eventTitle': 'NIHILITY SIGNAL CASCADE',
        'eventDesc':
            'Psychological warfare relics, Nihility Light Cones, and emotionally destabilizing combat archives are currently active across the network.',
      },
      {
        'image': 'assets/images/banner_jingliu.jpg',
        'title': 'JINGLIU FROSTBOUND',
        'subtitle': 'Cryogenic sword resonance relics detected →',
        'category': 'LIGHT CONE',
        'eventTag': 'jingliu',
        'eventTitle': 'FROSTMOON RESONANCE',
        'eventDesc':
            'Ancient sword memories, frost-infused relic technology, and forbidden Luofu combat techniques have resurfaced within the archive network.',
      },
      {
        'image': 'assets/images/banner_aventurine.jpg',
        'title': 'AVENTURINE HIGH ROLLER',
        'subtitle': 'Strategic IPC vault assets now entering circulation →',
        'category': 'RESOURCE',
        'eventTag': 'aventurine',
        'eventTitle': 'STRATEGIC FORTUNE VAULT',
        'eventDesc':
            'IPC-grade preservation equipment, probability-enhanced relic assets, and luxury strategic materials are temporarily available.',
      },
    ];
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
        bottom: 18,
      ),
      child: CarouselSlider.builder(
        itemCount: banners.length,
        options: CarouselOptions(
          height: isUltra ? 172 : 154,
          enlargeCenterPage: true,
          autoPlay: true,
          enableInfiniteScroll: true,
          pauseAutoPlayOnTouch: true,
          viewportFraction: 0.90,
          autoPlayCurve: Curves.easeOutQuart,
          autoPlayAnimationDuration: Duration(
            milliseconds: isUltra ? 1200 : 850,
          ),
        ),
        itemBuilder: (context, index, realIndex) {
          final banner = banners[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventCollectionScreen(
                    title: banner['title'] as String,
                    bannerImage: banner['image'] as String,
                    eventTag: banner['eventTag'] as String,
                    eventTitle: banner['eventTitle'] as String,
                    eventDesc: banner['eventDesc'] as String,
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark
                      ? AppTheme.hsrCyan.withOpacity(0.18)
                      : AppColors.lBorderGlow.withOpacity(0.40),
                  width: 0.9,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppTheme.hsrCyan.withOpacity(0.10)
                        : AppColors.lCyan.withOpacity(0.24),
                    blurRadius: isDark ? 12 : 38,
                    spreadRadius: isDark ? 0 : -6,
                    offset: const Offset(0, 12),
                  ),
                  if (!isDark)
                    BoxShadow(
                      color: AppColors.lPurple.withOpacity(0.14),
                      blurRadius: 40,
                      spreadRadius: -8,
                      offset: const Offset(0, 18),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // IMAGE
                    Image.asset(
                      banner['image'] as String,
                      fit: BoxFit.cover,
                    ),

                    // MAIN OVERLAY
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF050816).withOpacity(0.82),
                                  const Color(0xFF050816).withOpacity(0.34),
                                ]
                              : [
                                  const Color(0xFFEDF6FF).withOpacity(0.08),
                                  Colors.white.withOpacity(0.02),
                                ],
                        ),
                      ),
                    ),

                    // ATMOSPHERIC COLOR LAYER
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  AppTheme.hsrCyan.withOpacity(0.025),
                                  Colors.transparent,
                                  AppTheme.hsrPurple.withOpacity(0.10),
                                ]
                              : [
                                  AppColors.lCyan.withOpacity(0.20),
                                  Colors.white.withOpacity(0.02),
                                  AppColors.lPurple.withOpacity(0.22),
                                ],
                        ),
                      ),
                    ),

                    // DEPTH OVERLAY
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? [
                                    Colors.black.withOpacity(0.12),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.30),
                                  ]
                                : [
                                    Colors.white.withOpacity(0.08),
                                    Colors.transparent,
                                    const Color(0xFFBCD9FF).withOpacity(0.14),
                                  ],
                          ),
                        ),
                      ),
                    ),

                    // LIGHT MODE SHIMMER
                    if (!isDark)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.14),
                                Colors.transparent,
                                Colors.white.withOpacity(0.02),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // CONTENT
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        22,
                        24,
                        22,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 225,
                            child: Text(
                              banner['title'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFFF6FBFF),
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(
                                      isDark ? 0.55 : 0.18,
                                    ),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 235,
                            child: Text(
                              banner['subtitle'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.exo2(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.white.withOpacity(0.94),
                                fontSize: 11.2,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                                shadows: [
                                  if (!isDark)
                                    Shadow(
                                      color: Colors.black.withOpacity(0.10),
                                      blurRadius: 8,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // EVENT LABEL
                    Positioned(
                      top: 16,
                      right: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withOpacity(0.28)
                                  : Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.white.withOpacity(0.28),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.sparkles,
                                  size: 11,
                                  color: isDark
                                      ? AppTheme.hsrCyan
                                      : const Color(0xFFFFF4CC),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'EVENT',
                                  style: AppFonts.orbitron(
                                    preset: settings.fontStyle,
                                    color: isDark
                                        ? AppTheme.hsrCyan
                                        : const Color(0xFFFFF4CC),
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    final settings = context.watch<SettingsProvider>();

    final isUltra = settings.intensity == GalaxyIntensity.ultra;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        24,
        2,
        24,
        4,
      ),
      child: Stack(
        children: [
          // ATMOSPHERIC GLOW
          if (!isDark)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lCyan.withOpacity(
                        isUltra ? 0.18 : 0.10,
                      ),
                      blurRadius: isUltra ? 46 : 26,
                      spreadRadius: -8,
                    ),
                  ],
                ),
              ),
            ),

          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: isDark ? 4 : 22,
                sigmaY: isDark ? 10 : 22,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                height: 46,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF0A1230).withOpacity(0.92),
                            const Color(0xFF101E42).withOpacity(0.88),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.86),
                            const Color(0xFFF5F8FF).withOpacity(0.76),
                            const Color(0xFFE9F0FF).withOpacity(0.68),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.border
                        : AppColors.lBorderGlow.withOpacity(0.26),
                    width: 1.2,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.white.withOpacity(0.70),
                        blurRadius: 10,
                        spreadRadius: -4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),

                    Icon(
                      LucideIcons.search,
                      color: isDark ? const Color(0xFF6C86BC) : AppColors.lBlue,
                      size: 18,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        style: AppFonts.orbitron(
                          preset: settings.fontStyle,
                          color: isDark ? Colors.white : AppTheme.stellarText,
                          fontSize: 10.8,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          hintText: 'SCAN INTERASTRAL ARCHIVES...',
                          hintStyle: AppFonts.orbitron(
                            preset: settings.fontStyle,
                            color: isDark
                                ? const Color(0xFF4A6090)
                                : AppColors.lTextDim,
                            fontSize: 9.6,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    // RIGHT GLOW CHIP
                    if (!isDark)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lCyan,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lCyan.withOpacity(0.42),
                              blurRadius: 10,
                            ),
                          ],
                        ),
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

  Widget _buildFilterTabs(bool isDark) {
    final settings = context.watch<SettingsProvider>();

    final isUltra = settings.intensity == GalaxyIntensity.ultra;

    final tabs = [
      'ALL',
      'RESOURCE',
      'LIGHT CONE',
    ];

    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        itemCount: tabs.length,
        itemBuilder: (
          context,
          index,
        ) {
          final cat = tabs[index];

          final isSel = _activeCategory == cat;

          final color = isDark
              ? AppTheme.hsrCyan
              : (cat == 'LIGHT CONE' ? AppColors.lPurple : AppColors.lBlue);

          return GestureDetector(
            onTap: () {
              setState(() {
                _activeCategory = cat;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutQuart,
              margin: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              decoration: BoxDecoration(
                gradient: isSel
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                color.withOpacity(0.12),
                                AppTheme.hsrDeepSpace,
                              ]
                            : [
                                Colors.white.withOpacity(0.92),
                                color.withOpacity(0.18),
                              ],
                      )
                    : null,
                color: isSel
                    ? null
                    : (isDark
                        ? Colors.white.withOpacity(0.01)
                        : Colors.white.withOpacity(0.22)),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSel
                      ? color.withOpacity(0.85)
                      : (isDark
                          ? Colors.white10
                          : AppColors.lBorder.withOpacity(0.48)),
                  width: isSel ? 1.5 : 1,
                ),
                boxShadow: [
                  if (isSel)
                    BoxShadow(
                      color: color.withOpacity(
                        isUltra ? 0.34 : 0.18,
                      ),
                      blurRadius: isUltra ? 30 : 18,
                      spreadRadius: -4,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                cat,
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: isSel
                      ? color
                      : (isDark ? const Color(0xFF8FA8D8) : AppColors.lTextSub),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarketplaceGrid(
    List<Item> items,
    bool isDark,
    dynamic settings,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          "NO_DATA_FOUND",
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: Colors.white24,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.79,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemCount: items.length,
      itemBuilder: (
        context,
        index,
      ) {
        return FadeInUp(
          duration: const Duration(
            milliseconds: 500,
          ),
          delay: Duration(
            milliseconds: 120 * (index % 4),
          ),
          child: _ProductCard(
            item: items[index],
            isDark: isDark,
          ),
        );
      },
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 280,
        ),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    Colors.white.withOpacity(
                      0.06,
                    ),
                    Colors.white.withOpacity(
                      0.03,
                    ),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(
                      0.90,
                    ),
                    const Color(
                      0xFFEAF2FF,
                    ).withOpacity(
                      0.75,
                    ),
                  ],
                ),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white10
                : AppColors.lBorderGlow.withOpacity(
                    0.25,
                  ),
          ),
        ),
        child: Icon(
          icon,
          color: isDark ? AppTheme.hsrCyan : AppColors.lBlue,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildCartAction(
    BuildContext context,
    int count,
    bool isDark,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildHeaderAction(
          icon: LucideIcons.shoppingCart,
          isDark: isDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartScreen(),
              ),
            );
          },
        ),
        if (count > 0)
          Positioned(
            right: -4,
            top: -4,
            child: ZoomIn(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.hsrDanger,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Item item;
  final bool isDark;

  const _ProductCard({
    required this.item,
    required this.isDark,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isDown = false;

  bool _isHover = false;

  void _addToCart(BuildContext context, dynamic settings) {
    context.read<CartProvider>().addToCart(
          widget.item,
          1,
        );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1800),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 16,
              sigmaY: 16,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isDark
                      ? [
                          const Color(0xFF13234A).withOpacity(0.94),
                          const Color(0xFF1B2F61).withOpacity(0.90),
                        ]
                      : [
                          Colors.white.withOpacity(0.88),
                          const Color(0xFFEAF3FF).withOpacity(0.76),
                          const Color(0xFFDCEBFF).withOpacity(0.64),
                        ],
                ),
                border: Border.all(
                  color: AppTheme.hsrCyan.withOpacity(0.24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.hsrCyan.withOpacity(0.18),
                    blurRadius: 28,
                    spreadRadius: -4,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.hsrCyan.withOpacity(0.22),
                          AppTheme.hsrPurple.withOpacity(0.045),
                        ],
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.shoppingCart,
                      size: 16,
                      color: AppTheme.hsrCyan,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      '${widget.item.name} added to cart',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color:
                            widget.isDark ? Colors.white : AppTheme.stellarText,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final bool isUltra = settings.intensity == GalaxyIntensity.ultra;

    final themeColor = widget.item.category == 'RESOURCE'
        ? AppTheme.hsrCyan
        : AppTheme.hsrPurple;

    // Star color for 5-star in Light Mode - deeper amber/gold
    final rarityColor = widget.item.rarity == '5-star'
        ? (widget.isDark ? const Color(0xFFFFD84D) : const Color(0xFFF5A623))
        : widget.item.rarity == '4-star'
            ? const Color(0xFFB889FF)
            : const Color(0xFF6EC8FF);

    // PASTEL COLORS FOR LIGHT MODE LABELS
    // LC (Light Cone) - Soft pastel purple
    // RES (Resource) - Soft pastel blue
    final labelBgLightMode = widget.item.label == 'LC'
        ? const Color(0xFFC4B5FD).withOpacity(0.85) // Soft pastel purple
        : const Color(0xFFA5F3FC).withOpacity(0.85); // Soft pastel cyan/blue

    return MouseRegion(
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isDown = true),
        onTapUp: (_) => setState(() => _isDown = false),
        onTapCancel: () => setState(() => _isDown = false),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                item: widget.item,
              ),
            ),
          );
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: _isDown ? 0.975 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutQuart,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: widget.isDark
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF101A3A),
                        Color(0xFF15224D),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.84),
                        const Color(0xFFF6F9FF).withOpacity(0.76),
                        const Color(0xFFE8EEFF).withOpacity(0.64),
                      ],
                    ),
              border: Border.all(
                color: _isHover
                    ? themeColor.withOpacity(
                        widget.isDark ? 0.55 : 0.40,
                      )
                    : (widget.isDark
                        ? Colors.white10
                        : Colors.white.withOpacity(0.52)),
                width: _isHover ? 1.4 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeColor.withOpacity(
                    _isHover
                        ? (widget.isDark ? 0.20 : 0.22)
                        : (widget.isDark ? 0.10 : 0.12),
                  ),
                  blurRadius: _isHover ? 38 : 12,
                  spreadRadius: -8,
                  offset: const Offset(0, 14),
                ),
                if (!widget.isDark)
                  BoxShadow(
                    color: AppColors.lPurple.withOpacity(
                      _isHover ? 0.14 : 0.08,
                    ),
                    blurRadius: 44,
                    spreadRadius: -10,
                    offset: const Offset(0, 22),
                  ),
                if (!widget.isDark)
                  BoxShadow(
                    color: AppColors.lBlue.withOpacity(
                      _isHover ? 0.10 : 0.05,
                    ),
                    blurRadius: 28,
                    spreadRadius: -8,
                    offset: const Offset(0, 14),
                  ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      12,
                      12,
                      4,
                    ),
                    child: Stack(
                      children: [
                        // GLASS IMAGE AREA
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : Colors.white.withOpacity(0.72),
                            ),
                            boxShadow: [
                              if (!widget.isDark)
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.68),
                                  blurRadius: 10,
                                  spreadRadius: -4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                            gradient: widget.isDark
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      themeColor.withOpacity(
                                        _isHover ? 0.16 : 0.08,
                                      ),
                                      Colors.transparent,
                                    ],
                                  )
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      themeColor.withOpacity(
                                        _isHover ? 0.18 : 0.11,
                                      ),
                                      Colors.white.withOpacity(0.05),
                                      Colors.transparent,
                                    ],
                                  ),
                          ),
                        ),

                        // LOWER ATMOSPHERIC FADE
                        if (!widget.isDark)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    themeColor.withOpacity(0.06),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // HOLOGRAM SHIMMER
                        if (!widget.isDark)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.18),
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.02),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // MAIN GLOW
                        Positioned(
                          bottom: -14,
                          right: -14,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _isHover ? 1 : 0.55,
                            child: Container(
                              width: isUltra ? 115 : 90,
                              height: isUltra ? 115 : 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(
                                      widget.isDark ? 0.18 : 0.20,
                                    ),
                                    blurRadius: 48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // HOLOGRAPHIC RING
                        if (!widget.isDark)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Center(
                                child: Container(
                                  width: _isHover ? 122 : 108,
                                  height: _isHover ? 122 : 108,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: themeColor.withOpacity(
                                        _isHover ? 0.18 : 0.10,
                                      ),
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // IMAGE
                        Center(
                          child: widget.item.imagePath != null && widget.item.imagePath!.isNotEmpty
                              ? Hero(
                                  tag: 'item-${widget.item.id}',
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 260),
                                    scale: _isHover ? 1.06 : 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: widget.item.imagePath!.startsWith('assets/')
                                          ? Image.asset(
                                              widget.item.imagePath!,
                                              fit: BoxFit.contain,
                                              filterQuality: FilterQuality.high,
                                            )
                                          : Image.network(
                                              widget.item.imagePath!.startsWith('http')
                                                  ? widget.item.imagePath!
                                                  : '${Api.baseUrl}/${widget.item.imagePath!}',
                                              fit: BoxFit.contain,
                                              filterQuality: FilterQuality.high,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Text(
                                                widget.item.emoji,
                                                style: const TextStyle(fontSize: 42),
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                              : Text(
                                  widget.item.emoji,
                                  style: const TextStyle(
                                    fontSize: 42,
                                  ),
                                ),
                        ),

                        // UPDATED LABEL - PASTEL COLORS FOR LIGHT MODE
                        Positioned(
                          top: 12,
                          right: 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  // Dark mode: keep original dark style
                                  color: widget.isDark
                                      ? Colors.black.withOpacity(0.24)
                                      : labelBgLightMode,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: widget.isDark
                                        ? Colors.white10
                                        : Colors.white.withOpacity(0.45),
                                    width: 0.8,
                                  ),
                                  boxShadow: [
                                    if (!widget.isDark)
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                  ],
                                ),
                                child: Text(
                                  widget.item.label,
                                  style: AppFonts.orbitron(
                                    preset: settings.fontStyle,
                                    color: widget.isDark
                                        ? Colors.white70
                                        : const Color(
                                            0xFF1A2A4A), // Dark text for contrast on pastel
                                    fontSize: 7,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
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
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.orbitron(
                          preset: settings.fontStyle,
                          color: widget.isDark
                              ? Colors.white.withOpacity(0.94)
                              : AppTheme.stellarText,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.8,
                          letterSpacing: 0.4,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
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
                                  color: rarityColor.withOpacity(
                                    widget.isDark ? 0.22 : 0.35,
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
                                    widget.isDark ? 0.38 : 0.45,
                                  ),
                                  blurRadius: widget.isDark ? 10 : 12,
                                ),
                                if (!widget.isDark &&
                                    widget.item.rarity == '5-star')
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isDark
                                      ? AppTheme.hsrGold.withOpacity(0.12)
                                      : const Color(0xFFFFD86B)
                                          .withOpacity(0.26),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.isDark
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
                                  color: widget.isDark
                                      ? AppTheme.hsrGold
                                      : const Color(0xFFE0A92B),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                CurrencyFormatter.format(widget.item.price),
                                style: AppFonts.orbitron(
                                  preset: settings.fontStyle,
                                  color: widget.isDark
                                      ? AppTheme.hsrGold
                                      : const Color(0xFFB8860B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    if (!widget.isDark)
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
                          GestureDetector(
                            onTap: () {
                              _addToCart(context, settings);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    themeColor.withOpacity(
                                      _isHover ? 0.32 : 0.18,
                                    ),
                                    themeColor.withOpacity(
                                      _isHover ? 0.16 : 0.08,
                                    ),
                                  ],
                                ),
                                border: Border.all(
                                  color: themeColor.withOpacity(0.30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(
                                      _isHover ? 0.24 : 0.12,
                                    ),
                                    blurRadius: _isHover ? 24 : 12,
                                    spreadRadius: -4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                LucideIcons.plus,
                                size: 14,
                                color: themeColor,
                              ),
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
      ),
    );
  }
}
