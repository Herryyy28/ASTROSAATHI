import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/design_tokens.dart';

/// Premium shimmer loading skeleton — fully theme-adaptive (Light & Dark).
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
    final surfaceColor = AppColors.getSurface(context);
    final elevatedColor = AppColors.getSurfaceElevated(context);
    final borderColor = AppColors.getBorder(context);
    final shimmerColor = AppColors.getBorder(context).withOpacity(0.8);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: AppRadius.borderCard,
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: AppSpacing.lg),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: elevatedColor,
                      borderRadius: AppRadius.borderInput,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 13,
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 40),
                          decoration: BoxDecoration(
                            color: elevatedColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 10,
                          width: 120,
                          decoration: BoxDecoration(
                            color: elevatedColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(
                  duration: 1500.ms,
                  color: shimmerColor,
                ),
          );
        }),
      ),
    );
  }
}

/// Full-screen centered shimmer loader for async data — theme-adaptive.
class FullScreenShimmerLoader extends StatelessWidget {
  const FullScreenShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: AppColors.getPrimary(context),
              strokeWidth: 2.5,
              strokeCap: StrokeCap.round,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: 2000.ms, curve: Curves.linear),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.getTextSecondary(context),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}
