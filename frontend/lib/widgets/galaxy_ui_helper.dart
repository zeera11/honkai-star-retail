import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';

import '../providers/settings_provider.dart';
import '../models/settings_model.dart';

class GalaxyScreenWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool useScroll;
  final bool isDark;

  const GalaxyScreenWrapper({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.useScroll = false,
    this.isDark = true,
    String? subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final isDarkNow = settings.isDarkMode;

    final accent = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: isDarkNow ? AppColors.cosmicInk : AppColors.lBgBase,
      body: Stack(
        children: [
          _buildBackground(
            isDarkNow,
            settings,
          ),
          if (settings.intensity != GalaxyIntensity.minimal)
            ..._buildAtmosphericLights(
              settings,
              context,
            ),
          RepaintBoundary(
            child: CustomPaint(
              painter: _CelestialPainter(
                color: isDarkNow ? AppTheme.hsrCyan : AppColors.lBlue,
                density: settings.starDensity,
                isDark: isDarkNow,
                glowIntensity: settings.glowIntensity,
                nebulaOpacity: settings.nebulaOpacity,
                ultraMode: settings.intensity == GalaxyIntensity.ultra,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          if (!isDarkNow)
            IgnorePointer(
              child: Transform.translate(
                offset: const Offset(
                  -120,
                  -40,
                ),
                child: Transform.rotate(
                  angle: -0.28,
                  child: Container(
                    width: 260,
                    height: 700,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(
                            0.14,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                if (title != null)
                  _buildAppBar(
                    context,
                    accent,
                    settings,
                  ),
                Expanded(
                  child: IgnorePointer(
                    ignoring: false,
                    child: useScroll
                        ? SingleChildScrollView(
                            physics: settings.reduceMotion
                                ? const ClampingScrollPhysics()
                                : const BouncingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height,
                              ),
                              child: child,
                            ),
                          )
                        : child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(
    bool isDark,
    SettingsProvider settings,
  ) {
    if (isDark) {
      return Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF020617),
                  Color(0xFF081225),
                  Color(0xFF0E1B38),
                  Color(0xFF1A1F4F),
                ],
              ),
            ),
          ),
          Positioned(
            top: -240,
            left: -180,
            child: IgnorePointer(
              child: Container(
                width: 520,
                height: 520,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.hsrCyan.withOpacity(
                        0.045,
                      ),
                      blurRadius: 220,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -260,
            right: -160,
            child: IgnorePointer(
              child: Container(
                width: 560,
                height: 560,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.hsrPurple.withOpacity(
                        0.06,
                      ),
                      blurRadius: 240,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(
                        0.18,
                      ),
                      Colors.transparent,
                      Colors.black.withOpacity(
                        0.24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Opacity(
              opacity: 0.018,
              child: CustomPaint(
                size: Size.infinite,
                painter: _GridPainter(),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEAF1FF),
                Color(0xFFDDE7FF),
                Color(0xFFD8DEFF),
                Color(0xFFF3F7FF),
              ],
            ),
          ),
        ),
        Positioned(
          top: -200,
          left: -160,
          child: IgnorePointer(
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF756BFF,
                    ).withOpacity(
                      0.14,
                    ),
                    blurRadius: 180,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -240,
          left: -120,
          child: IgnorePointer(
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lCyan.withOpacity(
                      0.16,
                    ),
                    blurRadius: 220,
                  ),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Opacity(
            opacity: 0.04,
            child: CustomPaint(
              size: Size.infinite,
              painter: _GridPainter(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAtmosphericLights(
    SettingsProvider settings,
    BuildContext context,
  ) {
    final ultra = settings.intensity == GalaxyIntensity.ultra;

    final opacity = settings.orbIntensity;

    return [
      Positioned(
        top: -180,
        right: -120,
        child: _GlowOrb(
          size: ultra ? 520 : 360,
          color: settings.isDarkMode
              ? AppTheme.hsrCyan.withOpacity(opacity)
              : AppColors.lCyan.withOpacity(
                  opacity * 1.08,
                ),
        ),
      ),
      Positioned(
        bottom: -220,
        left: -140,
        child: _GlowOrb(
          size: ultra ? 620 : 420,
          color: settings.isDarkMode
              ? AppTheme.hsrPurple.withOpacity(
                  opacity * 0.85,
                )
              : AppColors.lPurple.withOpacity(
                  opacity * 0.75,
                ),
        ),
      ),
    ];
  }

  Widget _buildAppBar(
    BuildContext context,
    Color accent,
    SettingsProvider settings,
  ) {
    final isDark = settings.isDarkMode;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(26),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: settings.blurSigma + 4,
          sigmaY: settings.blurSigma + 4,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.16)
                : Colors.white.withOpacity(0.42),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(26),
            ),
            border: Border(
              bottom: BorderSide(
                color: accent.withOpacity(
                  isDark ? 0.24 : 0.18,
                ),
              ),
            ),
          ),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: accent,
                    size: 18,
                  ),
                )
              else
                const SizedBox(
                  width: 48,
                ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title!.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                    Text(
                      isDark
                          ? 'CONNECTION_ESTABLISHED'
                          : 'CELESTIAL_TERMINAL_V4.2',
                      style: TextStyle(
                        color: accent.withOpacity(
                          0.52,
                        ),
                        fontSize: 7.5 * settings.fontScale,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.8,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions ??
                    [
                      const SizedBox(
                        width: 48,
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

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.7,
              spreadRadius: size * 0.12,
            ),
          ],
        ),
      ),
    );
  }
}

class _CelestialPainter extends CustomPainter {
  final Color color;
  final int density;
  final bool isDark;
  final double glowIntensity;
  final double nebulaOpacity;
  final bool ultraMode;

  _CelestialPainter({
    required this.color,
    required this.density,
    required this.isDark,
    required this.glowIntensity,
    required this.nebulaOpacity,
    required this.ultraMode,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rand = _SeededRandom(42);

    final starPaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(
              ultraMode ? 0.75 : 0.42,
            )
          : Colors.white.withOpacity(
              0.65,
            );

    final starCount = isDark ? density ~/ 1.4 : density ~/ 2;

    for (int i = 0; i < starCount; i++) {
      final x = rand.nextDouble() * size.width;

      final y = rand.nextDouble() * size.height;

      final radius = ultraMode ? 1.2 : 0.6;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return true;
  }
}

class _SeededRandom {
  int seed;

  _SeededRandom(this.seed);

  double nextDouble() {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;

    return seed / 0x7fffffff;
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = const Color(
        0xFF7A89B8,
      )
      ..strokeWidth = 0.6;

    const spacing = 38.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}
