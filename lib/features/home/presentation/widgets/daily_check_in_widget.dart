import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/gamification_provider.dart';
import '../../../../core/providers/profile_provider.dart';

class DailyCheckInWidget extends ConsumerStatefulWidget {
  final String? userName;

  const DailyCheckInWidget({
    super.key,
    this.userName,
  });

  @override
  ConsumerState<DailyCheckInWidget> createState() => _DailyCheckInWidgetState();
}

class _DailyCheckInWidgetState extends ConsumerState<DailyCheckInWidget> {
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

  void _onMoodSelected(String mood) {
    setState(() {
      selectedMood = mood;
    });

    final gameState = ref.read(gamificationProvider);
    final isNewCheckin = !gameState.completedTasksToday.contains('dailyCheckIn');
    ref.read(gamificationProvider.notifier).recordMood(mood);

    if (isNewCheckin && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Daily cosmic check-in logged! +5 Karma XP earned.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeProfile = ref.watch(activeProfileProvider);
    final displayName = (widget.userName != null && widget.userName!.isNotEmpty)
        ? widget.userName!
        : (activeProfile.name.isNotEmpty ? activeProfile.name : 'Seeker');

    final gameState = ref.watch(gamificationProvider);
    final isCheckedIn = gameState.completedTasksToday.contains('dailyCheckIn');
    final currentMood = gameState.todayMood ?? selectedMood ?? 'Great';

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? AppColors.surfaceLight : null,
        gradient: isLight ? null : AppColors.goldSubtleGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withOpacity(isLight ? 0.3 : 0.4)),
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
                  'Cosmic Flow, $displayName',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
              ),
              if (isCheckedIn)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Completed ✓',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isLight ? AppColors.textPrimaryLight : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isCheckedIn
                ? "Today's check-in completed ✓"
                : 'How is your energy feeling today?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCheckedIn ? FontWeight.w600 : FontWeight.normal,
              color: isCheckedIn ? AppColors.success : AppColors.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 16),

          // Mood Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((m) {
              final isSelected = currentMood == m['label'];
              return GestureDetector(
                onTap: () => _onMoodSelected(m['label']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.getSurface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.getBorder(context),
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
                          color: isSelected ? Colors.black : AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Dynamic Guidance Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isLight ? AppColors.getSurfaceSecondary(context) : AppColors.surfaceDark.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.getBorder(context)),
            ),
            child: Text(
              getGuidanceForMood(currentMood),
              style: TextStyle(
                fontSize: 12,
                color: isLight ? AppColors.getTextPrimary(context) : AppColors.primaryLight,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
