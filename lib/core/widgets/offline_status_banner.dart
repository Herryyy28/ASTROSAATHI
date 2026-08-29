import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum SystemBannerType {
  offline,
  refreshFailed,
}

class OfflineStatusBanner extends StatelessWidget {
  final SystemBannerType type;
  final VoidCallback? onRetry;

  const OfflineStatusBanner({
    super.key,
    required this.type,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isOffline = type == SystemBannerType.offline;
    final icon = isOffline ? Icons.wifi_off_rounded : Icons.sync_problem_rounded;
    final message = isOffline
        ? "You're offline. Showing your last available data."
        : "Current astrology data could not be refreshed. Retry";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isOffline
            ? const Color(0x33FFB74D) // Subtle amber
            : const Color(0x33EF5350), // Subtle red
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOffline ? Colors.orange.withOpacity(0.4) : Colors.red.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isOffline ? Colors.orangeAccent : Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimaryDark,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null)
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 0.8),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.outfit(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
