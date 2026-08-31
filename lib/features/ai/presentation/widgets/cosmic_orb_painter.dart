import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CosmicOrbWidget extends StatefulWidget {
  final bool isSpeaking;
  final double size;

  const CosmicOrbWidget({
    super.key,
    this.isSpeaking = false,
    this.size = 64,
  });

  @override
  State<CosmicOrbWidget> createState() => _CosmicOrbWidgetState();
}

class _CosmicOrbWidgetState extends State<CosmicOrbWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _OrbPainter(
              progress: _controller.value,
              isSpeaking: widget.isSpeaking,
            ),
          );
        },
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double progress;
  final bool isSpeaking;

  _OrbPainter({required this.progress, required this.isSpeaking});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.4;

    final pulseFactor = isSpeaking
        ? (sin(progress * 4 * pi) + 1) / 2 * 0.15 + 0.95
        : (sin(progress * 2 * pi) + 1) / 2 * 0.08 + 0.96;

    final currentRadius = radius * pulseFactor;

    // Outer aura glow
    final auraPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, currentRadius * 1.35, auraPaint);

    // Mid gold glow
    final goldGlow = Paint()
      ..color = AppColors.primary.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, currentRadius * 1.15, goldGlow);

    // Inner Core Gradient
    final coreGradient = RadialGradient(
      center: Alignment.topLeft,
      colors: const [
        AppColors.primaryLight,
        AppColors.secondary,
        AppColors.surfaceDark,
      ],
    ).createShader(Rect.fromCircle(center: center, radius: currentRadius));

    final corePaint = Paint()..shader = coreGradient;
    canvas.drawCircle(center, currentRadius, corePaint);

    // Swirling cosmic ring
    final ringPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * pi);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: currentRadius * 1.8, height: currentRadius * 0.8),
      ringPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) => true;
}
