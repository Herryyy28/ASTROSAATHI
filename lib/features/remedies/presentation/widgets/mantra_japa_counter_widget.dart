import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class MantraJapaCounterWidget extends StatefulWidget {
  final String mantraTitle;
  final String mantraText;

  const MantraJapaCounterWidget({
    super.key,
    required this.mantraTitle,
    required this.mantraText,
  });

  @override
  State<MantraJapaCounterWidget> createState() => _MantraJapaCounterWidgetState();
}

class _MantraJapaCounterWidgetState extends State<MantraJapaCounterWidget> {
  int count = 0;
  final int totalBeads = 108;
  bool isPlayingAudio = false;

  void _incrementCounter() {
    HapticFeedback.mediumImpact();
    setState(() {
      if (count < totalBeads) {
        count++;
      } else {
        count = 0; // reset loop
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlightDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mantraTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    const Text(
                      'Interactive 108-Bead Japa Counter',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isPlayingAudio = !isPlayingAudio;
                  });
                },
                icon: Icon(
                  isPlayingAudio ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.mantraText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryLight,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Interactive 108 Bead Ring
          GestureDetector(
            onTap: _incrementCounter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CustomPaint(
                    painter: _BeadPainter(count: count, total: totalBeads),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '/ $totalBeads Japa',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'TAP BEAD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              setState(() {
                count = 0;
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.textSecondaryDark),
            label: const Text('Reset Count', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _BeadPainter extends CustomPainter {
  final int count;
  final int total;

  _BeadPainter({required this.count, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.3;

    final beadPaintInactive = Paint()
      ..color = AppColors.glassBorder
      ..style = PaintingStyle.fill;

    final beadPaintActive = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.goldGlow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    const int displayBeads = 36; // Render 36 visual nodes representing 108

    for (int i = 0; i < displayBeads; i++) {
      final angle = (i * 2 * pi / displayBeads) - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      final isActive = (i / displayBeads) <= (count / total);

      if (isActive) {
        canvas.drawCircle(Offset(x, y), 5.5, glowPaint);
        canvas.drawCircle(Offset(x, y), 4.5, beadPaintActive);
      } else {
        canvas.drawCircle(Offset(x, y), 3.5, beadPaintInactive);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BeadPainter oldDelegate) => true;
}
