import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/app_colors.dart';
import '../core/app_fonts.dart';

import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/galaxy_ui_helper.dart';

import '../auth/login_page.dart';
import 'account_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final user = auth.currentUser;

    final accent = isDark ? AppTheme.hsrCyan : AppTheme.stellarPrimary;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "USER PROFILE",
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildProfileHeader(
              isDark,
              accent,
              user?.firstName ?? 'TRAILBLAZER',
              user?.email ?? 'connection_error@galaxy.net',
              settings,
            ),
            const SizedBox(height: 40),
            _buildMenuSectionLabel(
              "ACCOUNT_MODULE",
              accent,
              settings,
            ),
            const SizedBox(height: 18),
            _buildProfileMenu(
              icon: LucideIcons.user2,
              title: "ACCOUNT_PROTOCOLS",
              subtitle: "Manage profile synchronization",
              isDark: isDark,
              accent: accent,
              settings: settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AccountPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildProfileMenu(
              icon: LucideIcons.settings2,
              title: "SYSTEM_SETTINGS",
              subtitle: "Visual & accessibility controls",
              isDark: isDark,
              accent: accent,
              settings: settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 45),
            _buildLogoutButton(
              context,
              isDark,
              settings,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    bool isDark,
    Color accent,
    String username,
    String email,
    SettingsProvider settings,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        28,
        24,
        26,
      ),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xCC101E42),
                  Color(0xCC16244F),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.96),
                  const Color(0xFFF4F8FF).withOpacity(0.90),
                  const Color(0xFFE7F0FF).withOpacity(0.78),
                ],
              ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: accent.withOpacity(
            isDark ? 0.14 : 0.12,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(
              isDark ? 0.14 : 0.10,
            ),
            blurRadius: 36,
            spreadRadius: -10,
            offset: const Offset(0, 18),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.82),
              blurRadius: 10,
              spreadRadius: -4,
              offset: const Offset(0, 2),
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
                    borderRadius: BorderRadius.circular(34),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // ATMOSPHERIC GLOW
          Positioned(
            top: -20,
            right: -30,
            child: IgnorePointer(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(
                        isDark ? 0.18 : 0.12,
                      ),
                      blurRadius: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              _buildAvatarHUD(isDark, accent),

              const SizedBox(height: 22),

              // STATUS LABEL
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withOpacity(0.12),
                      accent.withOpacity(0.04),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: accent.withOpacity(0.16),
                  ),
                ),
                child: Text(
                  'INTERASTRAL_MEMBER',
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: accent,
                    fontSize: 7.8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // USERNAME
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
                  username.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    height: 1,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // EMAIL
              Text(
                email,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.exo2(
                  color: isDark ? const Color(0xFF9CB7EA) : AppColors.lTextSub,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarHUD(
    bool isDark,
    Color accent,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // OUTER GLOW
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(
                  isDark ? 0.22 : 0.14,
                ),
                blurRadius: 80,
                spreadRadius: 6,
              ),
            ],
          ),
        ),

        // OUTER RING
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: accent.withOpacity(0.30),
              width: 2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.02),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        AppColors.lGlowBlue.withOpacity(0.14),
                      ],
                    ),
              border: Border.all(
                color: accent.withOpacity(0.14),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.82),
                    blurRadius: 8,
                    spreadRadius: -3,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Icon(
              LucideIcons.user,
              size: 70,
              color: accent,
            ),
          ),
        ),

        // ONLINE DOT
        Positioned(
          right: 18,
          bottom: 18,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.hsrSuccess,
              border: Border.all(
                color: isDark ? AppTheme.hsrDeepSpace : Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.hsrSuccess.withOpacity(0.42),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSectionLabel(
    String text,
    Color accent,
    SettingsProvider settings,
  ) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 2,
          color: accent,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: accent.withOpacity(0.65),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color accent,
    required SettingsProvider settings,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutQuart,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xCC101E42),
                    Color(0xCC16244F),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.94),
                    const Color(0xFFF5F8FF).withOpacity(0.84),
                    const Color(0xFFEAF1FF).withOpacity(0.72),
                  ],
                ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: accent.withOpacity(
              isDark ? 0.12 : 0.10,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(
                isDark ? 0.08 : 0.06,
              ),
              blurRadius: 24,
              spreadRadius: -8,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(0.16),
                    accent.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: accent.withOpacity(0.12),
                ),
              ),
              child: Icon(
                icon,
                color: accent,
                size: 22,
              ),
            ),

            const SizedBox(width: 16),

            // TEXTS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.orbitron(
                      preset: settings.fontStyle,
                      color: isDark ? Colors.white : AppTheme.stellarText,
                      fontSize: 11.8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.exo2(
                      color:
                          isDark ? const Color(0xFF9CB7EA) : AppColors.lTextSub,
                      fontSize: 11.2,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              LucideIcons.chevronRight,
              color: accent.withOpacity(0.62),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    bool isDark,
    SettingsProvider settings,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<AuthProvider>().logout();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
          (route) => false,
        );
      },
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.hsrDanger.withOpacity(
            isDark ? 0.10 : 0.08,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.hsrDanger.withOpacity(0.22),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.logOut,
              color: AppTheme.hsrDanger,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              "TERMINATE_SESSION",
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: AppTheme.hsrDanger,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
