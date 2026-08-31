import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CosmicParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;

  const CosmicParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 28,
  });

  @override
  State<CosmicParticleBackground> createState() => _CosmicParticleBackgroundState();
}

class _CosmicParticleBackgroundState extends State<CosmicParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _particles = List.generate(widget.particleCount, (index) => _generateParticle());
  }

  _Particle _generateParticle() {
    return _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      radius: _random.nextDouble() * 2.0 + 0.8,
      speed: _random.nextDouble() * 0.04 + 0.01,
      opacity: _random.nextDouble() * 0.5 + 0.2,
      pulseSpeed: _random.nextDouble() * 2.5 + 0.8,
      color: _random.nextBool()
          ? AppColors.primary
          : (_random.nextBool() ? AppColors.secondary : AppColors.tertiary),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDark,
      child: Stack(
        children: [
          // ── Isolated 60 FPS Particle Background Canvas ─────────────────
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ParticlePainter(
                    particles: _particles,
                    progress: _controller.value,
                  ),
                );
              },
            ),
          ),

          // ── Screen Child UI Content (Isolated from particle repaints) ──
          widget.child,
        ],
      ),
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double opacity;
  final double pulseSpeed;
  final Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.pulseSpeed,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final double currentY = (particle.y - progress * particle.speed) % 1.0;
      final double posY = currentY * size.height;
      final double posX = particle.x * size.width;

      final double pulseOpacity =
          (sin(progress * 2 * pi * particle.pulseSpeed) + 1) / 2 * 0.4 + 0.3;
      final double finalOpacity = (particle.opacity * pulseOpacity).clamp(0.1, 0.85);

      final auraPaint = Paint()
        ..color = particle.color.withOpacity(finalOpacity * 0.25)
        ..style = PaintingStyle.fill;

      final corePaint = Paint()
        ..color = particle.color.withOpacity(finalOpacity)
        ..style = PaintingStyle.fill;

      final centerOffset = Offset(posX, posY);
      canvas.drawCircle(centerOffset, particle.radius * 2.2, auraPaint);
      canvas.drawCircle(centerOffset, particle.radius, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
