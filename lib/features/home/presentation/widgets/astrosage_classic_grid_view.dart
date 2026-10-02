import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../consult/presentation/screens/talk_to_ai_astrologers_screen.dart';
import '../../../kundli/presentation/screens/kundli_screen.dart';
import '../../../kundli/presentation/screens/new_kundli_input_screen.dart';
import '../../../matching/presentation/screens/matching_screen.dart';
import '../../../panchang/presentation/screens/monthly_panchang_screen.dart';
import '../../../reports/presentation/screens/predictions_reports_screen.dart';
import '../screens/main_screen.dart';

/// 3x4 Grid of Classic AstroSage Features matching Image 4
class AstrosageClassicGridView extends ConsumerWidget {
  final void Function(int tabIndex)? onSelectTab;

  const AstrosageClassicGridView({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final List<Map<String, dynamic>> items = [
      {
        'title': 'Kundli',
        'icon': Icons.grid_goldenratio_rounded,
        'color': const Color(0xFFFF9800),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(3);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewKundliInputScreen()),
            );
          }
        },
      },
      {
        'title': 'Matching',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFFFF5722),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MatchingScreen()),
          );
        },
      },
      {
        'title': 'Horoscope',
        'icon': Icons.balance_rounded,
        'color': const Color(0xFFFF9800),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(3);
          } else {
            ref.read(mainNavIndexProvider.notifier).state = 1;
          }
        },
      },
      {
        'title': 'Predictions',
        'icon': Icons.description_rounded,
        'color': const Color(0xFFFF6D00),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(1);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PredictionsReportsScreen()),
            );
          }
        },
      },
      {
        'title': 'Panchang',
        'icon': Icons.wb_sunny_rounded,
        'color': const Color(0xFFFF9800),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(2);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MonthlyPanchangScreen()),
            );
          }
        },
      },
      {
        'title': 'KP System',
        'icon': Icons.star_half_rounded,
        'color': const Color(0xFFFF5722),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(1);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PredictionsReportsScreen()),
            );
          }
        },
      },
      {
        'title': 'Lal Kitab',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFFE65100),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(1);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PredictionsReportsScreen()),
            );
          }
        },
      },
      {
        'title': 'Varshphal',
        'icon': Icons.calendar_month_rounded,
        'color': const Color(0xFFFF9800),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(1);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PredictionsReportsScreen()),
            );
          }
        },
      },
      {
        'title': 'Porutham',
        'icon': Icons.all_inclusive_rounded,
        'color': const Color(0xFFFF6D00),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MatchingScreen()),
          );
        },
      },
      {
        'title': 'Calendar 2026',
        'icon': Icons.event_note_rounded,
        'color': const Color(0xFFFF9800),
        'onTap': () {
          if (onSelectTab != null) {
            onSelectTab!(2);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MonthlyPanchangScreen()),
            );
          }
        },
      },
      {
        'title': 'AstroSaathi AI',
        'icon': Icons.psychology_rounded,
        'color': const Color(0xFFE65100),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TalkToAiAstrologersScreen()),
          );
        },
      },
      {
        'title': 'Astro Shop',
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFFFF5722),
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening AstroSaathi Vedic Gemstones & Yantra Mall...')),
          );
        },
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLight ? const Color(0xFFEEEEEE) : AppColors.borderDark,
          width: 1,
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.15,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: item['onTap'] as VoidCallback,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLight ? const Color(0xFFF5F5F5) : AppColors.borderDark,
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] as String,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
