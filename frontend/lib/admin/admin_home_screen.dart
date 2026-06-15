import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/app_fonts.dart';

import '../models/item_model.dart';

import '../providers/inventory_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/galaxy_ui_helper.dart';
import '../widgets/delete_modal.dart';

import '../auth/login_page.dart';
import '../user/display_settings_page.dart';

import 'add_resource_screen.dart';
import 'low_stock_screen.dart';
import 'update_resource_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  int? selectedItemId;
  String _searchQuery = "";
  String _activeCategory = "ALL";
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().loadItems();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final accent = isDark ? AppTheme.hsrCyan : AppColors.lBlue;

    final items = inventory.items;
    final isLoading = inventory.isLoading;

    final filteredItems = items.where((item) {
      final matchesCategory = _activeCategory == 'ALL' ||
          (_activeCategory == 'RESOURCE' && item.category == 'RESOURCE') ||
          (_activeCategory == 'LIGHT CONE' && item.category == 'LIGHT CONE') ||
          (_activeCategory == 'LIMITED EVENT' &&
              item.eventTag != null &&
              item.eventTag!.isNotEmpty);
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final resourceCount = items.where((i) => i.category == 'RESOURCE').length;
    final lowStockCount = items.where((i) => i.stock <= 5).length;

    return GalaxyScreenWrapper(
      useScroll: false,
      isDark: isDark,
      showBackButton: false,
      title: "IPC COMMAND",
      child: Stack(
        children: [
          // Atmospheric orbs
          Positioned(
            top: -180,
            right: -120,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) => Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(
                          isDark
                              ? 0.14 + (_pulseController.value * 0.03)
                              : 0.08,
                        ),
                        blurRadius: 160,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -220,
            left: -120,
            child: IgnorePointer(
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppTheme.hsrPurple.withOpacity(isDark ? 0.12 : 0.05),
                      blurRadius: 180,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              _buildHeader(isDark, accent, settings),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 140),
                  children: [
                    const SizedBox(height: 18),
                    _buildStatsSection(
                      isDark,
                      accent,
                      items.length,
                      resourceCount,
                      lowStockCount,
                      settings,
                    ),
                    const SizedBox(height: 24),
                    _buildSearchBar(isDark, accent),
                    const SizedBox(height: 20),
                    _buildFilterTabs(isDark, accent, settings),
                    const SizedBox(height: 16),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 42,
                                height: 42,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: accent,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "SYNCING INTERASTRAL ITEMS",
                                style: AppFonts.orbitron(
                                  preset: settings.fontStyle,
                                  color: accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (filteredItems.isEmpty)
                      _buildEmptyState(isDark, accent, settings)
                    else
                      _buildInventoryGrid(
                          filteredItems, isDark, accent, settings),
                  ],
                ),
              ),
            ],
          ),
          if (selectedItemId == null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: _buildFloatingAddButton(isDark, accent, settings),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Header (matches UserHomeScreen style)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDark, Color accent, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.white.withOpacity(0.72),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: accent.withOpacity(0.14)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.hsrDanger.withOpacity(0.12),
                      border: Border.all(
                          color: AppTheme.hsrDanger.withOpacity(0.2)),
                    ),
                    child: const Icon(LucideIcons.logOut,
                        color: AppTheme.hsrDanger, size: 18),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Horizontal line + title (like user home welcome section)
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
                                  color:
                                      accent.withOpacity(isDark ? 0.45 : 0.28),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'IPC_COMMAND_TERMINAL',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                color: accent.withOpacity(isDark ? 0.72 : 0.82),
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "LIVE INVENTORY MANAGEMENT",
                        style: GoogleFonts.exo2(
                          color: isDark ? Colors.white70 : AppColors.lTextSub,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DisplaySettingsPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: accent.withOpacity(0.08),
                      border: Border.all(color: accent.withOpacity(0.16)),
                    ),
                    child: Icon(LucideIcons.settings2, color: accent, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Stats Cards (redesigned with glass depth)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStatsSection(
    bool isDark,
    Color accent,
    int totalItems,
    int resourceCount,
    int lowStockCount,
    SettingsProvider settings,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              isDark,
              title: "ITEMS",
              value: totalItems.toString(),
              subtitle: "inventory entries",
              icon: LucideIcons.database,
              color: AppTheme.hsrCyan,
              settings: settings,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildStatCard(
              isDark,
              title: "ALERTS",
              value: lowStockCount.toString(),
              subtitle: "low stock warnings",
              icon: LucideIcons.alertTriangle,
              color: AppTheme.hsrDanger,
              settings: settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LowStockScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    bool isDark, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required SettingsProvider settings,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF141D36), color.withOpacity(0.08)]
                : [Colors.white.withOpacity(0.92), color.withOpacity(0.06)],
          ),
          border: Border.all(
              color: color.withOpacity(isDark ? 0.12 : 0.1), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.14 : 0.02),
              blurRadius: 16,
              spreadRadius: -8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color.withOpacity(isDark ? 0.12 : 0.08),
                border: Border.all(color: color.withOpacity(0.12)),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: isDark ? Colors.white : AppTheme.stellarText,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: color,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.exo2(
                      color: isDark ? Colors.white38 : AppColors.lTextSub,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight,
                color: color.withOpacity(0.5), size: 16),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Search Bar (matches user home search)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildSearchBar(bool isDark, Color accent) {
    final settings = context.watch<SettingsProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          if (!isDark)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lCyan.withOpacity(0.12),
                      blurRadius: 26,
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
                  sigmaX: isDark ? 4 : 22, sigmaY: isDark ? 10 : 22),
              child: Container(
                height: 48,
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
                        color: Colors.white.withOpacity(0.7),
                        blurRadius: 10,
                        spreadRadius: -4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: isDark ? Colors.white : AppTheme.stellarText,
                    fontSize: 10.8,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: 'SCAN INTERASTRAL ITEMS...',
                    hintStyle: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color:
                          isDark ? const Color(0xFF4A6090) : AppColors.lTextDim,
                      fontSize: 9.6,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 10),
                      child: Icon(LucideIcons.search, color: accent, size: 18),
                    ),
                    suffixIcon: !isDark
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            width: 8,
                            height: 8,
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
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Filter Tabs (matches user home filter tabs)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildFilterTabs(
      bool isDark, Color accent, SettingsProvider settings) {
    final filters = ["ALL", "RESOURCE", "LIGHT CONE", "LIMITED EVENT"];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = _activeCategory == filter;
          final chipAccent = switch (filter) {
            "RESOURCE" => AppTheme.hsrCyan,
            "LIGHT CONE" => AppTheme.hsrPurple,
            "LIMITED EVENT" => Colors.orange,
            _ => accent,
          };
          return GestureDetector(
            onTap: () => setState(() => _activeCategory = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: selected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                chipAccent.withOpacity(0.16),
                                chipAccent.withOpacity(0.08)
                              ]
                            : [
                                chipAccent.withOpacity(0.12),
                                chipAccent.withOpacity(0.04)
                              ],
                      )
                    : null,
                color: selected
                    ? null
                    : (isDark
                        ? const Color(0xFF121A31)
                        : const Color(0xFFF5F8FF)),
                border: Border.all(
                  color: selected
                      ? chipAccent.withOpacity(isDark ? 0.3 : 0.2)
                      : chipAccent.withOpacity(isDark ? 0.1 : 0.08),
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: chipAccent.withOpacity(isDark ? 0.08 : 0.04),
                          blurRadius: 12,
                          spreadRadius: -6,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          selected ? chipAccent : chipAccent.withOpacity(0.3),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                  color: chipAccent.withOpacity(0.5),
                                  blurRadius: 8)
                            ]
                          : [],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    filter,
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: selected
                          ? chipAccent
                          : (isDark ? Colors.white54 : AppColors.lTextSub),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Inventory Grid (redesigned cards to match user product cards)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildInventoryGrid(
    List<Item> items,
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.79,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final selected = selectedItemId == item.id;
        return _AdminItemCard(
          item: item,
          isDark: isDark,
          isSelected: selected,
          settings: settings,
          onTap: () =>
              setState(() => selectedItemId = selected ? null : item.id),
          onUpdate: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UpdateResourceScreen(item: item)),
          ),
          onDelete: () => showDialog(
            context: context,
            builder: (_) => DeleteModal(
              item: item,
              onConfirm: () {
                context.read<InventoryProvider>().deleteItem(item.id);
                setState(() => selectedItemId = null);
              },
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Floating Add Button (matches checkout button style)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildFloatingAddButton(
      bool isDark, Color accent, SettingsProvider settings) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AddResourceScreen())),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppTheme.hsrCyan, AppTheme.hsrPurple]
                : [AppColors.lBlue, AppColors.lPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.3),
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
            const Icon(LucideIcons.plus, color: Colors.white, size: 18),
            const SizedBox(width: 12),
            Text(
              "CREATE NEW ITEM",
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

  Widget _buildEmptyState(
      bool isDark, Color accent, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Icon(LucideIcons.packageX, color: accent, size: 48),
          const SizedBox(height: 24),
          Text(
            "NO ITEMS DETECTED",
            style: AppFonts.orbitron(
              preset: settings.fontStyle,
              color: isDark ? Colors.white70 : AppTheme.stellarText,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Admin Item Card (completely redesigned to match user product card)
// ─────────────────────────────────────────────────────────────────────────────
class _AdminItemCard extends StatelessWidget {
  final Item item;
  final bool isSelected;
  final bool isDark;
  final SettingsProvider settings;
  final VoidCallback onTap;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const _AdminItemCard({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.settings,
    required this.onTap,
    required this.onUpdate,
    required this.onDelete,
  });

  Color get themeColor =>
      item.category == 'RESOURCE' ? AppTheme.hsrCyan : AppTheme.hsrPurple;
  Color get rarityColor {
    switch (item.rarity) {
      case '5-star':
        return isDark ? const Color(0xFFFFD84D) : const Color(0xFFF5A623);
      case '4-star':
        return const Color(0xFFB889FF);
      default:
        return const Color(0xFF6EC8FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF101A3A), Color(0xFF15224D)],
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
            color: isSelected
                ? themeColor.withOpacity(isDark ? 0.55 : 0.4)
                : (isDark ? Colors.white10 : Colors.white.withOpacity(0.52)),
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(
                  isSelected ? (isDark ? 0.2 : 0.22) : (isDark ? 0.1 : 0.12)),
              blurRadius: isSelected ? 28 : 12,
              spreadRadius: -8,
              offset: const Offset(0, 14),
            ),
            if (!isDark) ...[
              BoxShadow(
                color: AppColors.lPurple.withOpacity(isSelected ? 0.14 : 0.08),
                blurRadius: 44,
                spreadRadius: -10,
                offset: const Offset(0, 22),
              ),
              BoxShadow(
                color: AppColors.lBlue.withOpacity(isSelected ? 0.1 : 0.05),
                blurRadius: 28,
                spreadRadius: -8,
                offset: const Offset(0, 14),
              ),
            ],
          ],
        ),
        child: Stack(
          children: [
            // Glass shimmer
            if (!isDark)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.12),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    child: Stack(
                      children: [
                        // Image container with glass effect
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : Colors.white.withOpacity(0.72),
                            ),
                            gradient: isDark
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      themeColor.withOpacity(0.08),
                                      Colors.transparent
                                    ],
                                  )
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      themeColor.withOpacity(0.11),
                                      Colors.white.withOpacity(0.05)
                                    ],
                                  ),
                          ),
                          child: Center(
                            child: item.imagePath != null
                                ? Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(item.imagePath!,
                                        fit: BoxFit.contain),
                                  )
                                : Text(item.emoji,
                                    style: const TextStyle(fontSize: 42)),
                          ),
                        ),
                        // Rarity badge (stars)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? Colors.black.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.7),
                              border: Border.all(
                                  color: themeColor.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                item.rarity == '5-star'
                                    ? 5
                                    : item.rarity == '4-star'
                                        ? 4
                                        : 3,
                                (i) => Icon(Icons.star_rounded,
                                    size: 10, color: rarityColor),
                              ),
                            ),
                          ),
                        ),
                        // Category/Event label (top-right)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? Colors.black.withOpacity(0.4)
                                  : const Color(0xFF4A6FA5).withOpacity(0.75),
                              border: Border.all(
                                  color: themeColor.withOpacity(0.2)),
                            ),
                            child: Text(
                              item.eventTag != null
                                  ? "EVENT"
                                  : (item.category == 'RESOURCE'
                                      ? "RES"
                                      : "LC"),
                              style: AppFonts.orbitron(
                                preset: settings.fontStyle,
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        // Stock indicator
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.8),
                              border: Border.all(
                                  color: themeColor.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(LucideIcons.package,
                                    size: 10, color: themeColor),
                                const SizedBox(width: 4),
                                Text(
                                  "${item.stock}",
                                  style: AppFonts.orbitron(
                                    preset: settings.fontStyle,
                                    color: themeColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.orbitron(
                          preset: settings.fontStyle,
                          color: isDark
                              ? Colors.white.withOpacity(0.94)
                              : AppTheme.stellarText,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "STOCK ${item.stock}",
                            style: AppFonts.orbitron(
                              preset: settings.fontStyle,
                              color: isDark
                                  ? AppTheme.hsrGold
                                  : const Color(0xFFB8860B),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (item.eventTag != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange.withOpacity(0.15),
                              ),
                              child: Text(
                                "LIMITED",
                                style: AppFonts.orbitron(
                                  preset: settings.fontStyle,
                                  color: Colors.orange,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w800,
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
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  children: [
                    _buildActionButton(
                        icon: LucideIcons.pencil,
                        color: AppTheme.hsrCyan,
                        onTap: onUpdate),
                    const SizedBox(width: 8),
                    _buildActionButton(
                        icon: LucideIcons.trash2,
                        color: AppTheme.hsrDanger,
                        onTap: onDelete),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 14),
      ),
    );
  }
}
