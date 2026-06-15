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

import 'update_resource_screen.dart';

class LowStockScreen extends StatelessWidget {
  const LowStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final items = context
        .watch<InventoryProvider>()
        .items
        .where((e) => e.stock <= 5)
        .toList();

    return GalaxyScreenWrapper(
      useScroll: true,
      title: "LOW STOCK ALERTS",
      child: Stack(
        children: [
          Positioned(
            top: -180,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppTheme.hsrDanger.withOpacity(isDark ? 0.16 : 0.08),
                      blurRadius: 180,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -220,
            left: -120,
            child: IgnorePointer(
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppTheme.hsrPurple.withOpacity(isDark ? 0.1 : 0.04),
                      blurRadius: 180,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHero(isDark, items.length, settings),
                const SizedBox(height: 24),
                ...items.map(
                    (item) => _buildItemCard(context, isDark, item, settings)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(bool isDark, int count, SettingsProvider settings) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF26111D),
                      const Color(0xFF171731),
                      const Color(0xFF0E1226)
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFFFF0F4),
                      const Color(0xFFFFE4EA)
                    ],
            ),
            border: Border.all(color: AppTheme.hsrDanger.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.hsrDanger.withOpacity(isDark ? 0.18 : 0.08),
                blurRadius: 30,
                spreadRadius: -8,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CRITICAL INVENTORY STATUS",
                      style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color: AppTheme.hsrDanger,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "$count items are currently operating below safe inventory threshold.",
                      style: GoogleFonts.exo2(
                        color: isDark ? Colors.white70 : AppColors.lTextSub,
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppTheme.hsrDanger.withOpacity(0.2),
                    Colors.transparent
                  ]),
                  border:
                      Border.all(color: AppTheme.hsrDanger.withOpacity(0.2)),
                ),
                child: const Icon(LucideIcons.alertTriangle,
                    color: AppTheme.hsrDanger, size: 36),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(
      BuildContext context, bool isDark, Item item, SettingsProvider settings) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UpdateResourceScreen(item: item)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02)
                  ]
                : [Colors.white.withOpacity(0.94), const Color(0xFFFFF7F8)],
          ),
          border: Border.all(color: AppTheme.hsrDanger.withOpacity(0.14)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.hsrDanger.withOpacity(isDark ? 0.12 : 0.04),
              blurRadius: 24,
              spreadRadius: -8,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.hsrDanger.withOpacity(0.1),
                    AppTheme.hsrPurple.withOpacity(0.04)
                  ],
                ),
                border: Border.all(color: AppTheme.hsrDanger.withOpacity(0.12)),
              ),
              child: item.imagePath != null
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(item.imagePath!, fit: BoxFit.contain))
                  : const Icon(LucideIcons.package, color: AppTheme.hsrDanger),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: isDark ? Colors.white : AppTheme.stellarText,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Remaining stock: ${item.stock}",
                    style: GoogleFonts.exo2(
                        color: AppTheme.hsrDanger, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tap to synchronize inventory item",
                    style: GoogleFonts.exo2(
                      color: isDark ? Colors.white38 : AppColors.lTextSub,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.hsrDanger.withOpacity(0.12),
              ),
              child: Column(
                children: [
                  const Icon(LucideIcons.arrowRight,
                      color: AppTheme.hsrDanger, size: 14),
                  const SizedBox(height: 4),
                  Text(
                    "EDIT",
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: AppTheme.hsrDanger,
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
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
}
