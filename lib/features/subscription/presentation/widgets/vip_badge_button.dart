import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/premium_upgrade_modal.dart';

class VipBadgeButton extends ConsumerWidget {
  final bool compact;

  const VipBadgeButton({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subState = ref.watch(subscriptionProvider);
    final isPremium = subState.isPremium;

    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: () {
        PremiumUpgradeModal.show(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          gradient: isPremium
              ? AppColors.goldGradient
              : LinearGradient(
                  colors: [
                    isLight ? const Color(0xFFFFF7E6) : const Color(0xFF231E14),
                    isLight ? const Color(0xFFFEEDC9) : const Color(0xFF382F1B),
                    AppColors.getSurface(context),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(isPremium ? 0.8 : 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldGlow,
              blurRadius: isPremium ? 12 : 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '👑',
              style: TextStyle(fontSize: 14),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(duration: 1200.ms, begin: const Offset(1, 1), end: const Offset(1.15, 1.15)),
            const SizedBox(width: 6),
            Text(
              isPremium ? 'VIP ACTIVE' : 'UPGRADE VIP',
              style: GoogleFonts.outfit(
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: isPremium ? Colors.black : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
