import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Premium shimmer loading skeleton that replaces plain CircularProgressIndicator.
class ShimmerLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double spacing;

  const ShimmerLoader({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 80,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder, width: 0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlightDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 40),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceHighlightDark,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 10,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceHighlightDark,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(
                  duration: 1500.ms,
                  color: AppColors.glassBorder,
                ),
          );
        }),
      ),
    );
  }
}

/// Full-screen centered shimmer loader for async data.
class FullScreenShimmerLoader extends StatelessWidget {
  const FullScreenShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
              strokeCap: StrokeCap.round,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: 2000.ms, curve: Curves.linear),
          const SizedBox(height: 24),
          Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 14,
            ),
          ).animate().fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}
