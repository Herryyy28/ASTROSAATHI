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
              ? const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFFFD700), Color(0xFFB8860B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    const Color(0xFF2A2010),
                    const Color(0xFF4A3B18).withOpacity(0.9),
                    AppColors.surfaceDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFFD700).withOpacity(isPremium ? 0.9 : 0.6),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(isPremium ? 0.4 : 0.25),
              blurRadius: isPremium ? 14 : 10,
              spreadRadius: isPremium ? 1 : 0,
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
                color: isPremium ? const Color(0xFF1A1200) : const Color(0xFFFFE899),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
