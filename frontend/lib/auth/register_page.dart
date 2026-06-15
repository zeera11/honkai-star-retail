import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';

import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/galaxy_ui_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passController = TextEditingController();

  final _confirmController = TextEditingController();

  bool _hidePassword = true;

  bool _hideConfirm = true;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final error = await auth.register(
      email: _emailController.text,
      password: _passController.text,
      trailblazerId: _idController.text.trim().toLowerCase(),
      phone: _phoneController.text,
    );

    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Account Registered Successfully!",
            ),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final isDark = settings.isDarkMode;

    final accent = isDark ? AppColors.cyan : AppColors.deepSky;

    final isLoading = context.watch<AuthProvider>().isLoading;

    return GalaxyScreenWrapper(
      isDark: isDark,
      title: "Interastral Registry",
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 440,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildHeader(
                      isDark,
                      accent,
                    ),
                    const SizedBox(height: 26),
                    Container(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        22,
                      ),
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(
                                    0.05,
                                  ),
                                  Colors.white.withOpacity(
                                    0.02,
                                  ),
                                ],
                              )
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFF7FAFF),
                                  Color(0xFFEAF1FF),
                                  Color(0xFFE3ECFF),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(
                          26,
                        ),
                        border: Border.all(
                          color: isDark
                              ? Colors.white10
                              : const Color(0xFFBCD0F3).withOpacity(
                                  0.55,
                                ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withOpacity(
                              isDark ? 0.16 : 0.08,
                            ),
                            blurRadius: 30,
                            spreadRadius: -8,
                            offset: const Offset(
                              0,
                              16,
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSectionTitle(
                            "IDENTITY_RECORD",
                            accent,
                            isDark,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          _buildField(
                            _idController,
                            "USERNAME",
                            LucideIcons.user,
                            (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Username required";
                              }

                              final value = v.trim();

                              if (value.length < 4 || value.length > 20) {
                                return "Use 4-20 characters";
                              }

                              if (value.contains(' ')) {
                                return "Spaces are not allowed";
                              }

                              if (!RegExp(
                                r'^[a-zA-Z0-9_]+$',
                              ).hasMatch(value)) {
                                return "Only letters, numbers, and underscore";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                              ),
                              child: Text(
                                "Your public Interastral identity. Cannot be changed later.",
                                style: GoogleFonts.exo2(
                                  color: isDark
                                      ? const Color(
                                          0xFF8FA8D8,
                                        )
                                      : AppColors.textSecondary,
                                  fontSize: 11,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          _buildField(
                            _emailController,
                            "EMAIL",
                            LucideIcons.mail,
                            (v) {
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(v!)) {
                                return "Invalid email format";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildField(
                            _phoneController,
                            "PHONE NUMBER",
                            LucideIcons.phone,
                            (v) {
                              if (!RegExp(
                                r'^\d{10,}$',
                              ).hasMatch(v!)) {
                                return "Numbers only (min 10)";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          _buildSectionTitle(
                            "SECURITY_ENCRYPTION",
                            accent,
                            isDark,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          _buildField(
                            _passController,
                            "PASSWORD",
                            LucideIcons.lock,
                            (v) {
                              if (!RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
                              ).hasMatch(v!)) {
                                return "Need 8 chars, 1 Upper, 1 Lower, 1 Number";
                              }

                              return null;
                            },
                            isPass: true,
                            obscure: _hidePassword,
                            onToggle: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildField(
                            _confirmController,
                            "CONFIRM PASSWORD",
                            LucideIcons.shieldCheck,
                            (v) {
                              if (v != _passController.text) {
                                return "Codes do not match";
                              }

                              return null;
                            },
                            isPass: true,
                            obscure: _hideConfirm,
                            onToggle: () {
                              setState(() {
                                _hideConfirm = !_hideConfirm;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          _buildSubmitButton(
                            isLoading,
                            accent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    bool isDark,
    Color accent,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 240,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              IgnorePointer(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              accent.withOpacity(0.14),
                              AppColors.purple.withOpacity(
                                0.08,
                              ),
                              Colors.transparent,
                            ]
                          : [
                              const Color(0xFF79C8FF).withOpacity(0.16),
                              const Color(0xFFA58BFF).withOpacity(0.12),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: -5,
                  end: 5,
                ),
                duration: const Duration(
                  seconds: 4,
                ),
                curve: Curves.easeInOut,
                builder: (
                  context,
                  value,
                  child,
                ) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: child,
                  );
                },
                onEnd: () {
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(
                          isDark ? 0.18 : 0.08,
                        ),
                        blurRadius: 40,
                        spreadRadius: -6,
                      ),
                    ],
                  ),
                  child: Icon(
                    LucideIcons.sparkles,
                    color: accent,
                    size: 72,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: isDark
                  ? [
                      Colors.white,
                      const Color(0xFFC6D7FF),
                    ]
                  : [
                      const Color(0xFF729DFF),
                      const Color(0xFF9B7BFF),
                    ],
            ).createShader(bounds);
          },
          child: Text(
            "INTERASTRAL REGISTRY",
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.4,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: 320,
          child: Text(
            "Initialize new user id and synchronize your interastral marketplace credentials.",
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
              color: isDark
                  ? Colors.white.withOpacity(0.56)
                  : const Color(0xFF6A82B3),
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.orbitron(
            color: isDark ? color.withOpacity(0.72) : const Color(0xFF4569A5),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.4,
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    String? Function(String?) validator, {
    bool isPass = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.exo2(
        color: isDark ? Colors.white : const Color(0xFF1E3257),
        fontSize: 13,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.02) : const Color(0xFFF3F7FF),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : const Color(0xFF9CB8E8),
            width: 1.2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppColors.cyan : const Color(0xFF4D7BDB),
            width: 2,
          ),
        ),
        labelText: label,
        labelStyle: GoogleFonts.orbitron(
          color: isDark ? const Color(0xFF7D96C9) : const Color(0xFF5D79AD),
          fontSize: 10,
          letterSpacing: 1,
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: isDark ? const Color(0xFF8FA8D8) : const Color(0xFF4A6BA3),
        ),
        suffixIcon: isPass
            ? IconButton(
                icon: Icon(
                  obscure ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 18,
                ),
                onPressed: onToggle,
              )
            : null,
      ),
    );
  }

  Widget _buildSubmitButton(
    bool isLoading,
    Color accent,
  ) {
    return GestureDetector(
      onTap: isLoading ? null : _handleRegister,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent,
              AppColors.purple,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(
                0.30,
              ),
              blurRadius: 24,
              spreadRadius: -5,
              offset: const Offset(0, 10),
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
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "CREATE RECORD",
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
