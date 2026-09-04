import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/premium_upgrade_modal.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Authentic Human-Crafted Tactile VIP Badge Button
/// Clean Material 3 design with natural touch response, gold badge accent, and haptics.
/// ─────────────────────────────────────────────────────────────────────────────
class VipBadgeButton extends ConsumerStatefulWidget {
  final bool compact;

  const VipBadgeButton({
    super.key,
    this.compact = false,
  });

  @override
  ConsumerState<VipBadgeButton> createState() => _VipBadgeButtonState();
}

class _VipBadgeButtonState extends ConsumerState<VipBadgeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionProvider);
    final isPremium = subState.isPremium;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        try {
          HapticFeedback.selectionClick();
        } catch (_) {}
        PremiumUpgradeModal.show(context);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 10 : 14,
            vertical: widget.compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            gradient: isPremium
                ? AppColors.goldGradient
                : LinearGradient(
                    colors: isLight
                        ? [const Color(0xFFFFF8EA), const Color(0xFFFEEDC9)]
                        : [const Color(0xFF2C2211), const Color(0xFF19130A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPremium ? const Color(0xFFFFD700) : AppColors.primary.withOpacity(0.6),
              width: isPremium ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(isPremium ? 0.35 : 0.15),
                blurRadius: isPremium ? 10 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Clean Crown Icon Badge
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPremium ? Colors.black.withOpacity(0.12) : const Color(0xFFFFD700).withOpacity(0.18),
                ),
                child: const Text(
                  '👑',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 6),

              // Crisp Label
              Text(
                isPremium ? 'VIP ACTIVE ✨' : 'UPGRADE VIP PRO',
                style: GoogleFonts.outfit(
                  fontSize: widget.compact ? 10.5 : 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: isPremium ? const Color(0xFF1B1403) : (isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
