import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DailyRoutineWidget extends StatefulWidget {
  const DailyRoutineWidget({super.key});

  @override
  State<DailyRoutineWidget> createState() => _DailyRoutineWidgetState();
}

class _DailyRoutineWidgetState extends State<DailyRoutineWidget> {
  final Map<String, bool> tasks = {
    'Read today\'s cosmic insight': true,
    'Complete 108 Japa Mantra': true,
    'Check today\'s Abhijit Muhurat': true,
    'Ask Astro Baba one personal question': false,
  };

  int get completedCount => tasks.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    final progressPercentage = completedCount / tasks.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlightDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s 3-Minute Routine',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Daily practice build cosmic clarity',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                  ),
                ],
              ),

              // Streak Counter Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 4),
                    Text(
                      '12 Days',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.warning),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceDark,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$completedCount / ${tasks.length}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Checklist Items
          ...tasks.keys.map((taskKey) {
            final isDone = tasks[taskKey]!;
            return GestureDetector(
              onTap: () {
                setState(() {
                  tasks[taskKey] = !isDone;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isDone ? AppColors.primary : AppColors.textTertiaryDark,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        taskKey,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDone ? AppColors.textPrimaryDark : AppColors.textSecondaryDark,
                          decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
