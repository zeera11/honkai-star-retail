import 'dart:ui';

import '../api/api.dart';

// ignore: unused_import
import 'package:google_sign_in/google_sign_in.dart';
// ignore: unused_import
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';

import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/galaxy_ui_helper.dart';

import '../admin/admin_home_screen.dart';
import '../user/user_home_screen.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

    Future<void> testApi() async {
    try {
      final res = await Api.getItems();

      print("========== API SUCCESS ==========");
      print(res);
    } catch (e) {
      print("========== API ERROR ==========");
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _passController = TextEditingController();

  late AnimationController _shakeController;

  bool _obscureText = true;

  // Helper for responsive sizing
  double responsive(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 430);
  }

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    testApi();
  }

  @override
  void dispose() {
    _shakeController.dispose();

    _idController.dispose();
    _passController.dispose();

    super.dispose();
  }

  void _shake() {
    _shakeController.forward(from: 0.0);
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      _shake();
      return;
    }

    final auth = context.read<AuthProvider>();

    final error = await auth.login(
      _idController.text.trim(),
      _passController.text,
    );

    if (error != null) {
      _shake();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppTheme.hsrDanger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (!mounted) return;

      if (auth.userRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminHomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UserHomeScreen(),
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    final settings = context.read<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final accent = isDark ? AppColors.cyan : AppColors.deepSky;
    final r = responsive(context, 1);

    // Show Google Account Chooser Dialog
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final customEmailController = TextEditingController();
        final customNameController = TextEditingController();
        bool showCustomForm = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22 * r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    width: 340 * r,
                    padding: EdgeInsets.all(20 * r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22 * r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF10182D),
                                const Color(0xFF182445),
                                const Color(0xFF111A34),
                              ]
                            : [
                                const Color(0xFFF7FBFF),
                                const Color(0xFFEAF2FF),
                                const Color(0xFFF3EEFF),
                              ],
                      ),
                      border: Border.all(
                        color: accent.withOpacity(0.18),
                        width: 1.2,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            width: 32 * r,
                            height: 32 * r,
                          ),
                          SizedBox(height: 12 * r),
                          Text(
                            "CHOOSE AN ACCOUNT",
                            style: GoogleFonts.orbitron(
                              color: isDark ? Colors.white : AppTheme.stellarText,
                              fontSize: 14 * r,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            "to continue to Honkai Star Retail",
                            style: GoogleFonts.exo2(
                              color: isDark ? Colors.white54 : AppColors.lTextSub,
                              fontSize: 11 * r,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 18 * r),
                          if (!showCustomForm) ...[
                            // Simulated account list
                            _buildGoogleAccountTile(
                              r,
                              isDark,
                              accent,
                              "Google Trailblazer",
                              "google_trailblazer@gmail.com",
                              () => Navigator.pop(context, {
                                "name": "Google Trailblazer",
                                "email": "google_trailblazer@gmail.com"
                              }),
                            ),
                            SizedBox(height: 8 * r),
                            _buildGoogleAccountTile(
                              r,
                              isDark,
                              accent,
                              "March 7th",
                              "march7th@gmail.com",
                              () => Navigator.pop(context, {
                                "name": "March 7th",
                                "email": "march7th@gmail.com"
                              }),
                            ),
                            SizedBox(height: 8 * r),
                            _buildGoogleAccountTile(
                              r,
                              isDark,
                              accent,
                              "Dan Heng",
                              "danheng@gmail.com",
                              () => Navigator.pop(context, {
                                "name": "Dan Heng",
                                "email": "danheng@gmail.com"
                              }),
                            ),
                            SizedBox(height: 14 * r),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showCustomForm = true;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.userPlus, size: 14 * r, color: accent),
                                  SizedBox(width: 8 * r),
                                  Text(
                                    "Use another account",
                                    style: GoogleFonts.orbitron(
                                      color: accent,
                                      fontSize: 10 * r,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            // Custom account form
                            TextField(
                              controller: customNameController,
                              style: GoogleFonts.exo2(color: isDark ? Colors.white : Colors.black87),
                              decoration: InputDecoration(
                                labelText: "FULL NAME",
                                labelStyle: GoogleFonts.orbitron(color: accent, fontSize: 8.5 * r),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accent.withOpacity(0.35)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accent, width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 12 * r),
                            TextField(
                              controller: customEmailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.exo2(color: isDark ? Colors.white : Colors.black87),
                              decoration: InputDecoration(
                                labelText: "EMAIL ADDRESS",
                                labelStyle: GoogleFonts.orbitron(color: accent, fontSize: 8.5 * r),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accent.withOpacity(0.35)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accent, width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 20 * r),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showCustomForm = false;
                                    });
                                  },
                                  child: Text("BACK", style: GoogleFonts.orbitron(color: isDark ? Colors.white60 : Colors.black54, fontSize: 10 * r)),
                                ),
                                SizedBox(width: 12 * r),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * r)),
                                  ),
                                  onPressed: () {
                                    final email = customEmailController.text.trim();
                                    final name = customNameController.text.trim();
                                    if (email.isNotEmpty && name.isNotEmpty) {
                                      Navigator.pop(context, {
                                        "name": name,
                                        "email": email,
                                      });
                                    }
                                  },
                                  child: Text("SIGN IN", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 10 * r, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) return;

    final selectedEmail = result['email'];
    final selectedName = result['name'];

    final auth = context.read<AuthProvider>();
    final error = await auth.loginWithGoogle(
      email: selectedEmail,
      name: selectedName,
    );

    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.danger,
          ),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const UserHomeScreen(),
        ),
      );
    }
  }

  Widget _buildGoogleAccountTile(
    double r,
    bool isDark,
    Color accent,
    String name,
    String email,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14 * r, vertical: 10 * r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14 * r),
          color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
          border: Border.all(
            color: accent.withOpacity(0.12),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16 * r,
              backgroundColor: accent.withOpacity(0.15),
              child: Text(
                name[0].toUpperCase(),
                style: GoogleFonts.orbitron(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12 * r,
                ),
              ),
            ),
            SizedBox(width: 12 * r),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.exo2(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12 * r,
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.exo2(
                      color: isDark ? Colors.white38 : AppColors.lTextSub,
                      fontSize: 9.5 * r,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 14 * r, color: isDark ? Colors.white30 : Colors.black.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppColors.cyan : AppColors.deepSky;

    final isLoading = context.watch<AuthProvider>().isLoading;

    final size = MediaQuery.of(context).size;

    final isDesktop = size.width >= 900;

    final maxWidth = isDesktop ? 1100.0 : 460.0;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "Interastral Login",
      showBackButton: false,
      actions: [
        GestureDetector(
          onTap: () {
            settings.toggleTheme();
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withOpacity(0.15),
              ),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        Colors.white.withOpacity(0.06),
                        Colors.white.withOpacity(0.02),
                      ]
                    : [
                        Colors.white.withOpacity(0.92),
                        Colors.white.withOpacity(0.72),
                      ],
              ),
            ),
            child: Icon(
              isDark ? LucideIcons.sun : LucideIcons.moon,
              color: accent,
              size: 20,
            ),
          ),
        ),
      ],
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 22,
              vertical: isDesktop ? 24 : 10,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: isDesktop
                  ? Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 60,
                            ),
                            child: _buildDesktopHero(
                              isDark,
                              accent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildLoginPanel(
                            isDark,
                            accent,
                            isLoading,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildLogo(
                          isDark,
                          accent,
                        ),
                        const SizedBox(height: 4),
                        _buildLoginPanel(
                          isDark,
                          accent,
                          isLoading,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHero(
    bool isDark,
    Color accent,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(
          isDark,
          accent,
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: isDark
                  ? [
                      Colors.white,
                      const Color(0xFFC6D7FF),
                    ]
                  : [
                      const Color(0xFF6F92FF),
                      const Color(0xFF9A7CFF),
                    ],
            ).createShader(bounds);
          },
          child: Text(
            "INTERASTRAL\nMARKETPLACE",
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 420,
          child: Text(
            "Premium interastral inventory terminal designed for Trailblazer resource management across the galaxy network.",
            style: GoogleFonts.exo2(
              color: isDark
                  ? Colors.white.withOpacity(0.58)
                  : const Color(0xFF6981B2),
              fontSize: 15,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(
    bool isDark,
    Color accent,
  ) {
    final r = responsive(context, 1);

    return GestureDetector(
      onLongPress: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) {
            final emailController = TextEditingController(text: "admin@honkai.com");
            final passwordController = TextEditingController();
            String? errorMessage;
            bool isAuthenticating = false;

            return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22 * r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 18,
                        sigmaY: 18,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18 * r,
                          vertical: 16 * r,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28 * r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    const Color(0xFF10182D),
                                    const Color(0xFF182445),
                                    const Color(0xFF111A34),
                                  ]
                                : [
                                    const Color(0xFFF7FBFF),
                                    const Color(0xFFEAF2FF),
                                    const Color(0xFFF3EEFF),
                                  ],
                          ),
                          border: Border.all(
                            color: accent.withOpacity(0.18),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withOpacity(
                                isDark ? 0.14 : 0.06,
                              ),
                              blurRadius: 45,
                              spreadRadius: -10,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 62 * r,
                                height: 62 * r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      accent.withOpacity(0.22),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  LucideIcons.shieldAlert,
                                  color: accent,
                                  size: 34 * r,
                                ),
                              ),
                              SizedBox(height: 14 * r),
                              Text(
                                "IPC_OVERRIDE_PROTOCOL",
                                style: GoogleFonts.orbitron(
                                  color: accent.withOpacity(0.65),
                                  fontSize: 8 * r,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6 * r),
                              Text(
                                "ADMIN ACCESS",
                                style: GoogleFonts.orbitron(
                                  color: accent,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  fontSize: 12 * r,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14 * r,
                                  vertical: 12 * r,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18 * r),
                                  color: isDark
                                      ? Colors.white.withOpacity(0.03)
                                      : Colors.white.withOpacity(0.7),
                                  border: Border.all(
                                    color: accent.withOpacity(0.12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.scanFace,
                                      color: accent,
                                      size: 16 * r,
                                    ),
                                    SizedBox(width: 12 * r),
                                    Expanded(
                                      child: Text(
                                        "Restricted IPC administrative terminal detected. Credentials required for archive management access.",
                                        style: GoogleFonts.exo2(
                                          color: isDark
                                              ? Colors.white70
                                              : const Color(0xFF50658F),
                                          fontSize: 9 * r,
                                          height: 1.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 14 * r),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.exo2(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Admin Email",
                                      hintStyle: GoogleFonts.exo2(
                                        color: isDark ? Colors.white38 : Colors.black38,
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(left: 4 * r),
                                        child: Icon(
                                          LucideIcons.mail,
                                          color: accent,
                                          size: 20 * r,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: accent.withOpacity(0.35),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: accent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12 * r),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    style: GoogleFonts.exo2(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: GoogleFonts.exo2(
                                        color: isDark ? Colors.white38 : Colors.black38,
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(left: 4 * r),
                                        child: Icon(
                                          LucideIcons.lock,
                                          color: accent,
                                          size: 20 * r,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: accent.withOpacity(0.35),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: accent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (errorMessage != null) ...[
                                    SizedBox(height: 8 * r),
                                    Text(
                                      errorMessage!,
                                      style: GoogleFonts.exo2(
                                        color: AppTheme.hsrDanger,
                                        fontSize: 9.5 * r,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 20 * r),
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  height: 48 * r,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18 * r),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.hsrCyan,
                                        AppTheme.hsrPurple,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.hsrCyan.withOpacity(0.35),
                                        blurRadius: 18,
                                        spreadRadius: -8,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18 * r),
                                      ),
                                    ),
                                    onPressed: isAuthenticating
                                        ? null
                                        : () async {
                                            setState(() {
                                              isAuthenticating = true;
                                              errorMessage = null;
                                            });

                                            try {
                                              final auth = context.read<AuthProvider>();
                                              final error = await auth.login(
                                                emailController.text.trim(),
                                                passwordController.text,
                                              );

                                              if (error != null) {
                                                setState(() {
                                                  errorMessage = error;
                                                  isAuthenticating = false;
                                                });
                                              } else if (auth.userRole != 'admin') {
                                                await auth.logout();
                                                setState(() {
                                                  errorMessage = "Access Denied: Not an administrative account";
                                                  isAuthenticating = false;
                                                });
                                              } else {
                                                Navigator.pop(context, true);
                                              }
                                            } catch (e) {
                                              setState(() {
                                                errorMessage = "Connection error: $e";
                                                isAuthenticating = false;
                                              });
                                            }
                                          },
                                    child: isAuthenticating
                                        ? SizedBox(
                                            width: 18 * r,
                                            height: 18 * r,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                LucideIcons.shieldCheck,
                                                size: 18 * r,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 12 * r),
                                              Text(
                                                "AUTHORIZE",
                                                style: GoogleFonts.orbitron(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 2,
                                                  fontSize: 9.8 * r,
                                                ),
                                              ),
                                            ],
                                          ),
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
              },
            );
          },
        );

        if (result == true && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminHomeScreen(),
            ),
          );
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 900 ? 240 : 290 * r,
        height: MediaQuery.of(context).size.width > 900 ? 220 : 250 * r,
        child: Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              child: Container(
                width: 280 * r,
                height: 280 * r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isDark
                        ? [
                            AppTheme.hsrCyan.withOpacity(0.10),
                            AppTheme.hsrPurple.withOpacity(0.08),
                            Colors.transparent,
                          ]
                        : [
                            const Color(0xFF77C8FF).withOpacity(0.18),
                            const Color(0xFFA58BFF).withOpacity(0.14),
                            Colors.transparent,
                          ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'hsr-logo',
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(
                        isDark ? 0.12 : 0.08,
                      ),
                      blurRadius: 40,
                      spreadRadius: -10,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: isDesktop(context) ? 200 : 240 * r,
                  height: isDesktop(context) ? 200 : 240 * r,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  Widget _buildLoginPanel(
    bool isDark,
    Color accent,
    bool isLoading,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TERMINAL LABEL
          Text(
            "TERMINAL_LOGIN",
            style: GoogleFonts.orbitron(
              color: accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
              fontSize: responsive(context, 10),
            ),
          ),

          SizedBox(height: responsive(context, 14)),

          // MAIN TITLE
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: isDark
                    ? [
                        Colors.white,
                        const Color(0xFFC7D8FF),
                      ]
                    : [
                        const Color(0xFF27407A),
                        const Color(0xFF627DCA),
                      ],
              ).createShader(bounds);
            },
            child: Text(
              "HONKAI STAR RETAIL",
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: responsive(context, 24),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
                height: 1.1,
              ),
            ),
          ),

          SizedBox(height: responsive(context, 12)),

          // SUBTITLE
          Text(
            "Interastral Marketplace Access Terminal",
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
              color: isDark
                  ? Colors.white.withOpacity(0.58)
                  : const Color(0xFF6B84B5),
              fontSize: responsive(context, 11.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              height: 1.5,
            ),
          ),

          SizedBox(height: responsive(context, 28)),

          _buildFloatingField(
            isDark: isDark,
            child: _buildInputField(
              controller: _idController,
              label: "USERNAME / EMAIL",
              icon: LucideIcons.user,
              isDark: isDark,
              validator: (v) {
                if (v == null || v.trim().length < 4) {
                  return "Invalid credentials";
                }
                return null;
              },
            ),
          ),

          SizedBox(height: responsive(context, 14)),

          // PASSWORD FIELD - REDUCED HEIGHT
          _buildFloatingField(
            isDark: isDark,
            child: _buildInputField(
              controller: _passController,
              label: "PASSWORD",
              icon: LucideIcons.lock,
              isDark: isDark,
              isPassword: true,
              obscureText: _obscureText,
              onToggleVisibility: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              validator: (v) {
                if (v == null || v.length < 6) {
                  return "Minimum 6 characters";
                }
                return null;
              },
            ),
          ),

          SizedBox(height: responsive(context, 28)),

          // LOGIN BUTTON
          GestureDetector(
            onTap: isLoading ? null : _handleLogin,
            child: Container(
              height: responsive(context, 58),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    accent,
                    AppTheme.hsrPurple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.18),
                    blurRadius: 30,
                    spreadRadius: -10,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          LucideIcons.sparkles,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "INITIALIZE LOGIN",
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: responsive(context, 18)),

          _buildGoogleSection(
            isDark,
            accent,
            isLoading,
          ),

          SizedBox(height: responsive(context, 14)),

          _buildRegisterLink(
            accent,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingField({
    required Widget child,
    required bool isDark,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4, // Reduced from 8 to 4
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                      const Color(0xFF0A1230).withOpacity(0.3),
                    ]
                  : [
                      Colors.white.withOpacity(0.92),
                      const Color(0xFFF1F5FF).withOpacity(0.88),
                      const Color(0xFFE8F0FF).withOpacity(0.8),
                    ],
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white12
                  : const Color(0xFFC8D8FF).withOpacity(0.5),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : const Color(0xFF9FB6E8).withOpacity(0.06),
                blurRadius: 20,
                spreadRadius: -8,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.exo2(
        color: isDark ? Colors.white : const Color(0xFF1E3257),
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.orbitron(
          color: isDark ? const Color(0xFF8AA8E8) : const Color(0xFF6784B8),
          fontSize: 8.5,
          letterSpacing: 1.2,
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: isDark ? AppTheme.hsrCyan : const Color(0xFF5E8FFF),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
                  color: isDark ? Colors.white70 : const Color(0xFF6078A8),
                  size: 16,
                ),
                onPressed: onToggleVisibility,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            : null,
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.04)
            : const Color(0xFFF8FBFF).withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12, // Reduced from default
          horizontal: 12,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : const Color(0xFFB8C8F0),
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: accentColor(isDark),
            width: 1.5,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.hsrDanger,
            width: 1,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.hsrDanger,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Color accentColor(bool isDark) {
    return isDark ? AppTheme.hsrCyan : const Color(0xFF5E8FFF);
  }

  Widget _buildRegisterLink(
    Color accent,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "NEW_TRAILBLAZER?",
          style: GoogleFonts.exo2(
            color: isDark ? Colors.white38 : const Color(0xFF8B9CC0),
            fontSize: 10.5,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RegisterPage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "REGISTER ID",
            style: GoogleFonts.orbitron(
              color: accent,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSection(
    bool isDark,
    Color accent,
    bool isLoading,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : const Color(0xFFC8D8FF).withOpacity(0.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: Text(
                "OR CONTINUE WITH",
                style: GoogleFonts.orbitron(
                  color: isDark ? Colors.white38 : AppColors.lTextSub,
                  fontSize: 7.5,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : const Color(0xFFC8D8FF).withOpacity(0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: isLoading ? null : _handleGoogleLogin,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 56, // Reduced from 78
            height: 56, // Reduced from 78
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.03),
                        const Color(0xFF0A1230).withOpacity(0.2),
                      ]
                    : [
                        Colors.white,
                        const Color(0xFFF4F8FF),
                        const Color(0xFFE8F0FF),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white12
                    : const Color(0xFFC8D8FF).withOpacity(0.6),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? accent.withOpacity(0.08)
                      : accent.withOpacity(0.04),
                  blurRadius: 20,
                  spreadRadius: -6,
                  offset: const Offset(0, 10),
                ),
                if (!isDark)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/google_logo.png',
                width: 24, // Reduced from 32
                height: 24, // Reduced from 32
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "SECURE FEDERATED LOGIN",
          style: GoogleFonts.orbitron(
            color: isDark ? Colors.white60 : AppColors.lTextSub,
            fontSize: 8,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
