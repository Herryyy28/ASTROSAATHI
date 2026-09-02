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
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.getGlassBorder(context)),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Interactive 108-Bead Japa Counter',
                      style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.getSurfaceSecondary(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.mantraText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.getPrimary(context),
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
                      style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TAP BEAD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.getPrimary(context),
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
            icon: Icon(Icons.refresh_rounded, size: 16, color: AppColors.getTextSecondary(context)),
            label: Text('Reset Count', style: TextStyle(color: AppColors.getTextSecondary(context), fontSize: 12)),
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
