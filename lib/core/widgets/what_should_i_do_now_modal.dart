import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WhatShouldIDoNowModal extends StatefulWidget {
  const WhatShouldIDoNowModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const WhatShouldIDoNowModal(),
    );
  }

  @override
  State<WhatShouldIDoNowModal> createState() => _WhatShouldIDoNowModalState();
}

class _WhatShouldIDoNowModalState extends State<WhatShouldIDoNowModal> {
  String selectedCategory = 'Work';

  final List<Map<String, dynamic>> categories = [
    {'label': 'Work', 'icon': Icons.business_center_rounded},
    {'label': 'Relationship', 'icon': Icons.favorite_rounded},
    {'label': 'Study', 'icon': Icons.menu_book_rounded},
    {'label': 'Financial', 'icon': Icons.account_balance_wallet_rounded},
    {'label': 'Personal', 'icon': Icons.person_rounded},
    {'label': 'Travel', 'icon': Icons.flight_takeoff_rounded},
  ];

  Map<String, dynamic> getStatus(String cat) {
    switch (cat) {
      case 'Work':
        return {
          'status': 'NOW (Highly Favorable)',
          'color': AppColors.success,
          'icon': Icons.play_circle_fill_rounded,
          'window': 'Current Golden Window: 11:15 AM – 1:20 PM',
          'reason': 'Sun-Mercury conjunction in 10th Karma house heightens persuasive authority.',
        };
      case 'Financial':
        return {
          'status': 'WAIT (Rahu Kaal)',
          'color': AppColors.warning,
          'icon': Icons.pause_circle_filled_rounded,
          'window': 'Rahu Kaal: 1:30 PM – 3:00 PM',
          'reason': 'Avoid making large investments or digital transactions during Rahu Kaal window.',
        };
      default:
        return {
          'status': 'BETTER TIME COMING',
          'color': AppColors.primary,
          'icon': Icons.schedule_rounded,
          'window': 'Optimal Window: 4:30 PM – 6:00 PM',
          'reason': 'Moon transition into Rohini Nakshatra creates favorable alignment in early evening.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = getStatus(selectedCategory);
    final Color statusColor = info['color'] as Color;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withOpacity(0.95),
            border: const Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.explore_rounded, color: AppColors.primary, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'What should I do right now?',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Categories Selector
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((c) {
                    final isSel = selectedCategory == c['label'];
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(c['icon'] as IconData, size: 14, color: isSel ? Colors.black : AppColors.primary),
                          const SizedBox(width: 6),
                          Text(c['label'] as String),
                        ],
                      ),
                      selected: isSel,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceHighlightDark,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.black : AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => selectedCategory = c['label'] as String);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Status Result Box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(info['icon'] as IconData, color: statusColor, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              info['status'] as String,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: statusColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        info['window'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        info['reason'] as String,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimaryDark, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}
