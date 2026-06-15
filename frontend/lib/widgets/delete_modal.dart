import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_colors.dart';
// ignore: unused_import
import '../core/app_theme.dart';
import '../models/item_model.dart';
import '../api/api.dart';

class DeleteModal extends StatelessWidget {
  final Item item;
  final VoidCallback onConfirm;

  const DeleteModal({super.key, required this.item, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    // Detect theme from context
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          // Dark: original dark card. Light: luminous glass panel.
          gradient: isDark
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xF8F4F9FF), Color(0xEED8E8FF)],
                ),
          color: isDark ? AppColors.bg : null,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? AppColors.danger.withOpacity(0.3)
                : AppColors.lDanger.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: isDark
              ? const [BoxShadow(color: Colors.black54, blurRadius: 30)]
              : [
                  BoxShadow(
                      color: AppColors.lDanger.withOpacity(0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 8)),
                  const BoxShadow(
                      color: AppColors.lGlowCyan,
                      blurRadius: 16,
                      offset: Offset(0, 2)),
                  const BoxShadow(
                      color: Colors.white,
                      blurRadius: 2,
                      offset: Offset(0, 1)),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.danger.withOpacity(0.1)
                    : AppColors.lDanger.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(
                    color: (isDark ? AppColors.danger : AppColors.lDanger)
                        .withOpacity(0.3),
                    width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: (isDark ? AppColors.danger : AppColors.lDanger)
                          .withOpacity(0.15),
                      blurRadius: 20)
                ],
              ),
              child: Icon(LucideIcons.alertTriangle,
                  color:
                      isDark ? AppColors.danger : AppColors.lDanger,
                  size: 32),
            ),
            const SizedBox(height: 22),

            // ── Title ────────────────────────────────────────────────────────
            Text(
              'DELETE RESOURCE?',
              style: GoogleFonts.orbitron(
                color: isDark ? AppColors.textMain : AppColors.lTextMain,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 22),

            // ── Item Preview ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: isDark
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFFEEF4FF), Color(0xFFDDE8F8)]),
                color: isDark ? AppColors.card : null,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark
                        ? AppColors.border
                        : AppColors.lBorder,
                    width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.bg3
                          : AppColors.lBgFrost,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isDark
                              ? AppColors.border
                              : AppColors.lBorderSoft,
                          width: 1),
                    ),
                    child: Center(
                      child: item.imagePath != null && item.imagePath!.isNotEmpty
                          ? (item.imagePath!.startsWith('assets/')
                              ? Image.asset(item.imagePath!, fit: BoxFit.contain)
                              : Image.network(
                                  item.imagePath!.startsWith('http')
                                      ? item.imagePath!
                                      : '${Api.baseUrl}/${item.imagePath!}',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Text(item.emoji, style: const TextStyle(fontSize: 24)),
                                ))
                          : Text(item.emoji,
                              style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.name,
                      style: GoogleFonts.exo2(
                        color: isDark
                            ? AppColors.textMain
                            : AppColors.lTextMain,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── Warning text ─────────────────────────────────────────────────
            Text(
              'This action cannot be undone. The item will also be removed from any active user carts.',
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lTextSub,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // ── Buttons ──────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _ModalBtn(
                    label: 'NO',
                    isDark: isDark,
                    isPrimary: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ModalBtn(
                    label: 'YES, DELETE',
                    isDark: isDark,
                    isPrimary: true,
                    onTap: () {
                      onConfirm();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalBtn extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ModalBtn({
    required this.label,
    required this.isDark,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color dangerColor =
        isDark ? AppColors.danger : AppColors.lDanger;
    final Color cancelBg = isDark ? AppColors.bg3 : AppColors.lBgMist;
    final Color cancelText =
        isDark ? AppColors.textSecondary : AppColors.lTextSub;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: isPrimary
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [dangerColor, dangerColor.withOpacity(0.75)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: dangerColor.withOpacity(0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 4)),
                ],
              )
            : BoxDecoration(
                color: cancelBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark
                        ? AppColors.border
                        : AppColors.lBorder,
                    width: 1),
              ),
        child: Text(
          label,
          style: GoogleFonts.orbitron(
            color: isPrimary ? Colors.white : cancelText,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}