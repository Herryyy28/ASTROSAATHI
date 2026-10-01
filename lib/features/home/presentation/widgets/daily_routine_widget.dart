import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/gamification_provider.dart';

class DailyRoutineWidget extends ConsumerWidget {
  const DailyRoutineWidget({super.key});

  static const List<Map<String, dynamic>> _routineTasks = [
    {'id': 'morning_insight', 'title': 'Read today\'s cosmic insight', 'xp': 5},
    {'id': 'japa108', 'title': 'Complete 108 Japa Mantra', 'xp': 15},
    {'id': 'muhurat_check', 'title': 'Check today\'s Abhijit Muhurat', 'xp': 5},
    {'id': 'baba_query', 'title': 'Consult Astro Baba for guidance', 'xp': 10},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gamificationProvider);
    final completedCount = _routineTasks
        .where((t) => gameState.completedTasksToday.contains(t['id']))
        .length;
    final progressPercentage = completedCount / _routineTasks.length;

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s 3-Minute Routine',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${gameState.karmaXp} Karma XP • Disciplined alignment',
                      style: TextStyle(fontSize: 11, color: AppColors.getTextSecondary(context)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Dynamic Streak Counter Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      '${gameState.streakDays} ${gameState.streakDays == 1 ? "Day" : "Days"}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.warning),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    minHeight: 6,
                    backgroundColor: AppColors.getSurfaceSecondary(context),
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$completedCount / ${_routineTasks.length}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Checklist Items
          ..._routineTasks.map((task) {
            final taskId = task['id'] as String;
            final isDone = gameState.completedTasksToday.contains(taskId);
            final xp = task['xp'] as int;

            return GestureDetector(
              onTap: () {
                if (!isDone) {
                  ref.read(gamificationProvider.notifier).completeTask(taskId, xp);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Task completed! +$xp Karma XP earned.',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Already completed for today! Keep up your streak 🔥'),
                      backgroundColor: AppColors.getSurface(context),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isDone ? AppColors.primary : AppColors.getTextMuted(context),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task['title'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDone ? AppColors.getTextPrimary(context) : AppColors.getTextSecondary(context),
                          decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.primary.withOpacity(0.15) : AppColors.getSurfaceSecondary(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+$xp XP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isDone ? AppColors.primary : AppColors.getTextMuted(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
