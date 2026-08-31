import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../engine/models/astrology_validation.dart';

/// Small chip displaying calculations freshness metadata.
class DataFreshnessBadge extends StatelessWidget {
  final DataQualityMetadata? metadata;
  final String? timeString;

  const DataFreshnessBadge({
    super.key,
    this.metadata,
    this.timeString,
  });

  @override
  Widget build(BuildContext context) {
    final displayTime = metadata?.calculatedAt ?? timeString ?? 'Calculated recently';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              displayTime,
              style: GoogleFonts.outfit(
                color: AppColors.textTertiaryDark,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
