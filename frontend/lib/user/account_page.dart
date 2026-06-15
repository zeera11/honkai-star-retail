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

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _firstController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    final user = context.read<AuthProvider>().currentUser;

    _firstController = TextEditingController(text: user?.firstName);

    _emailController = TextEditingController(text: user?.email);
  }

  void _save() {
    context.read<AuthProvider>().updateProfile(
          trailblazerId: _firstController.text.trim(),
          firstName: _firstController.text.trim(),
          lastName: "",
          email: _emailController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Archive Synchronized"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppTheme.hsrCyan : AppTheme.stellarPrimary;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "ACCOUNT PROTOCOLS",
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildSectionLabel(
              "IDENTITY_RECORD",
              accent,
              settings,
            ),
            const SizedBox(height: 26),
            _buildTechnicalInput(
              controller: _firstController,
              label: "TRAILBLAZER_ID",
              icon: LucideIcons.user,
              isDark: isDark,
              accent: accent,
              settings: settings,
            ),
            const SizedBox(height: 22),
            _buildTechnicalInput(
              controller: _emailController,
              label: "COMM_CHANNEL_EMAIL",
              icon: LucideIcons.mail,
              isDark: isDark,
              accent: accent,
              settings: settings,
            ),
            const SizedBox(height: 34),
            _buildSectionLabel(
              "SECURITY_LAYER",
              accent,
              settings,
            ),
            const SizedBox(height: 20),
            _buildPasswordBox(
              isDark,
              accent,
              settings,
            ),
            const SizedBox(height: 50),
            _buildSaveButton(
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

  Widget _buildSectionLabel(
    String text,
    Color color,
    SettingsProvider settings,
  ) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: color.withOpacity(0.7),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicalInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    required Color accent,
    required SettingsProvider settings,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: isDark ? Colors.white24 : AppColors.lTextSub,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          decoration: BoxDecoration(
            gradient: isDark
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.92),
                      AppColors.lBgNebula.withOpacity(0.88),
                    ],
                  ),
            color: isDark ? Colors.white.withOpacity(0.04) : null,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isDark ? Colors.white10 : AppColors.lBorder.withOpacity(0.7),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: AppColors.lGlowBlue.withOpacity(0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              if (!isDark)
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.exo2(
              color: isDark ? Colors.white : AppTheme.stellarText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              icon: Icon(
                icon,
                color: accent.withOpacity(0.65),
                size: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordBox(
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.92),
                  AppColors.lBgNebula.withOpacity(0.88),
                ],
              ),
        color: isDark ? Colors.white.withOpacity(0.03) : null,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.lBorder.withOpacity(0.65),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.lGlowPurple.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ACCESS_KEY",
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: isDark ? Colors.white24 : AppColors.lTextSub,
                  fontSize: 8,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "••••••••••••",
                style: TextStyle(
                  color: isDark ? Colors.white54 : AppColors.lTextMain,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accent.withOpacity(0.18),
              ),
            ),
            child: Text(
              "RE-ENCRYPT",
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: accent,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    bool isDark,
    Color accent,
    SettingsProvider settings,
  ) {
    return GestureDetector(
      onTap: _save,
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    accent,
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
              color: accent.withOpacity(0.38),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'SYNCHRONIZE_DATA',
          style: AppFonts.orbitron(
            preset: settings.fontStyle,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
