import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DailyCheckInWidget extends StatefulWidget {
  final String userName;

  const DailyCheckInWidget({
    super.key,
    this.userName = 'Herry',
  });

  @override
  State<DailyCheckInWidget> createState() => _DailyCheckInWidgetState();
}

class _DailyCheckInWidgetState extends State<DailyCheckInWidget> {
  String? selectedMood = 'Great';

  final List<Map<String, String>> moods = [
    {'emoji': '😊', 'label': 'Great'},
    {'emoji': '🙂', 'label': 'Good'},
    {'emoji': '😐', 'label': 'Okay'},
    {'emoji': '😔', 'label': 'Low'},
    {'emoji': '😤', 'label': 'Stressed'},
  ];

  String getGuidanceForMood(String mood) {
    switch (mood) {
      case 'Great':
        return '✦ High vitality day! Your Lagna Lord is energized by Jupiter. Perfect time to take bold steps.';
      case 'Good':
        return '✦ Favorable cosmic flow. Maintain focus during your golden window (11:15 AM - 1:20 PM).';
      case 'Okay':
        return '✦ Steady planetary alignment. Keep routine activities balanced and avoid rushed decisions.';
      case 'Low':
        return '✦ Moon is in a meditative phase today. Practice 108 Japa and take extra rest in the evening.';
      case 'Stressed':
        return '✦ Rahu transit influence active. Take 5 deep breaths, listen to Jupiter Beej Mantra, and postpone conflicts.';
      default:
        return '✦ Favorable cosmic flow today.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.goldSubtleGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Good Morning, ${widget.userName}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 14),

          // Mood Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((m) {
              final isSelected = selectedMood == m['label'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMood = m['label'];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.glassBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(m['emoji']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(
                        m['label']!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Dynamic Guidance Box
          if (selectedMood != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Text(
                getGuidanceForMood(selectedMood!),
                style: const TextStyle(fontSize: 12, color: AppColors.primaryLight, height: 1.3),
              ),
            ),
        ],
      ),
    );
  }
}
