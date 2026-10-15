import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

class DailyGuidanceHero extends StatefulWidget {
  const DailyGuidanceHero({
    super.key,
    required this.date,
    required this.insight,
    required this.clarityPercent,
    this.bestWindowStart,
    this.bestWindowEnd,
    this.focus,
    this.onGuidanceTap,
  });

  final DateTime date;
  final String? insight;
  final int? clarityPercent;
  final String? bestWindowStart;
  final String? bestWindowEnd;
  final String? focus;
  final VoidCallback? onGuidanceTap;

  @override
  State<DailyGuidanceHero> createState() => _DailyGuidanceHeroState();
}

class _DailyGuidanceHeroState extends State<DailyGuidanceHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _motionConfigured = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_motionConfigured) return;
    _motionConfigured = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, .52, curve: Curves.easeOutCubic),
    );
    final contentAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.12, .64, curve: Curves.easeOutCubic),
    );
    final ringAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.13, 1, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: cardAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, .035),
          end: Offset.zero,
        ).animate(cardAnimation),
        child: RepaintBoundary(
          child: Container(
            constraints: const BoxConstraints(minHeight: 264),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondaryBackground,
                  AppColors.softLavender,
                  AppColors.highlightSurface,
                ],
              ),
              border: Border.all(
                color: AppColors.surfaceLight.withValues(alpha: .72),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryLightMode.withValues(alpha: .08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ExcludeSemantics(
                    child: FadeTransition(
                      opacity: contentAnimation,
                      child: CustomPaint(
                        painter: _CelestialHeroPainter(
                          reveal: contentAnimation,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: FadeTransition(
                    opacity: contentAnimation,
                    child: LayoutBuilder(
                      builder: (context, constraints) => _HeroContent(
                        date: widget.date,
                        insight: widget.insight,
                        clarityPercent: widget.clarityPercent,
                        bestWindowStart: widget.bestWindowStart,
                        bestWindowEnd: widget.bestWindowEnd,
                        focus: widget.focus,
                        onGuidanceTap: widget.onGuidanceTap,
                        ringAnimation: ringAnimation,
                        isCompact: constraints.maxWidth < 346,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({
    required this.date,
    required this.insight,
    required this.clarityPercent,
    required this.bestWindowStart,
    required this.bestWindowEnd,
    required this.focus,
    required this.onGuidanceTap,
    required this.ringAnimation,
    required this.isCompact,
  });

  final DateTime date;
  final String? insight;
  final int? clarityPercent;
  final String? bestWindowStart;
  final String? bestWindowEnd;
  final String? focus;
  final VoidCallback? onGuidanceTap;
  final Animation<double> ringAnimation;
  final bool isCompact;

  bool get _hasWindow =>
      bestWindowStart?.trim().isNotEmpty == true &&
      bestWindowEnd?.trim().isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final stackSummary = isCompact || textScale > 1.18;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('EEEE • d MMMM').format(date).toUpperCase(),
                style: const TextStyle(
                  fontSize: 10.5,
                  height: 1.2,
                  letterSpacing: 1.25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const ExcludeSemantics(
              child: Icon(
                Icons.dark_mode_outlined,
                size: 20,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (stackSummary) ...[
          _EditorialCopy(insight: insight),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: _ClarityRing(
              percent: clarityPercent,
              animation: ringAnimation,
            ),
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _EditorialCopy(insight: insight)),
              const SizedBox(width: 18),
              _ClarityRing(percent: clarityPercent, animation: ringAnimation),
            ],
          ),
        if (_hasWindow || focus?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_hasWindow)
                _HeroCapsule(
                  icon: Icons.auto_awesome_outlined,
                  label: 'Best window',
                  value: '$bestWindowStart – $bestWindowEnd',
                ),
              if (focus?.trim().isNotEmpty == true)
                _HeroCapsule(
                  icon: Icons.adjust_rounded,
                  label: 'Focus today',
                  value: focus!.trim(),
                ),
            ],
          ),
        ],
        if (onGuidanceTap != null) ...[
          const SizedBox(height: 20),
          _GuidanceButton(onPressed: onGuidanceTap!),
        ],
      ],
    );
  }
}

class _EditorialCopy extends StatelessWidget {
  const _EditorialCopy({required this.insight});

  final String? insight;

  @override
  Widget build(BuildContext context) {
    final hasInsight = insight?.trim().isNotEmpty == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your day\nin the stars',
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            height: 1.02,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryLightMode,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          hasInsight
              ? insight!.trim()
              : 'Personal guidance is unavailable right now.',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.42,
            fontWeight: hasInsight ? FontWeight.w400 : FontWeight.w500,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class _ClarityRing extends StatelessWidget {
  const _ClarityRing({required this.percent, required this.animation});

  final int? percent;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final normalized = percent?.clamp(0, 100);
    final label = normalized == null
        ? 'Daily clarity unavailable'
        : 'Daily clarity, $normalized percent';

    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.2,
          child: SizedBox.square(
            dimension: 98,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final visiblePercent = normalized == null
                    ? null
                    : (normalized * animation.value).round();
                return CustomPaint(
                  painter: _ClarityRingPainter(
                    progress: normalized == null
                        ? null
                        : normalized / 100 * animation.value,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (visiblePercent != null)
                          Text(
                            '$visiblePercent%',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 25,
                              height: 1,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryLightMode,
                            ),
                          )
                        else
                          const Icon(
                            Icons.more_horiz_rounded,
                            size: 25,
                            color: AppColors.primaryLightMode,
                          ),
                        const SizedBox(height: 3),
                        Text(
                          visiblePercent == null
                              ? 'Clarity\nunavailable'
                              : 'Clarity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: visiblePercent == null ? 8.5 : 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ClarityRingPainter extends CustomPainter {
  const _ClarityRingPainter({required this.progress});

  final double? progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - 10) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = AppColors.surfaceLight.withValues(alpha: .82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    if (progress == null) return;
    final clamped = progress!.clamp(0.0, 1.0);
    if (clamped <= 0) return;
    final progressPaint = Paint()
      ..shader = const SweepGradient(
        colors: [AppColors.secondary, AppColors.actionPurple, AppColors.pink],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * clamped,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ClarityRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _HeroCapsule extends StatelessWidget {
  const _HeroCapsule({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 48),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: AppColors.surfaceLight.withValues(alpha: .74),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.surfaceLight.withValues(alpha: .9)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: AppColors.secondary),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 8.5,
                height: 1.15,
                letterSpacing: .8,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 190),
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _GuidanceButton extends StatefulWidget {
  const _GuidanceButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_GuidanceButton> createState() => _GuidanceButtonState();
}

class _GuidanceButtonState extends State<_GuidanceButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'View today’s guidance',
    child: AnimatedScale(
      scale: _pressed ? .98 : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Material(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onPressed,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          borderRadius: BorderRadius.circular(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 46),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'View today’s guidance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surfaceLight,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: AppColors.surfaceLight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _CelestialHeroPainter extends CustomPainter {
  const _CelestialHeroPainter({required this.reveal}) : super(repaint: reveal);

  final Animation<double> reveal;

  @override
  void paint(Canvas canvas, Size size) {
    final value = reveal.value;
    final linePaint = Paint()
      ..color = AppColors.primaryLightMode.withValues(alpha: .055 * value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final pointPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: .075 * value)
      ..style = PaintingStyle.fill;

    final wheelCenter = Offset(size.width * .92, size.height * .2);
    final wheelRadius = math.min(size.width, size.height) * .34;
    canvas.drawCircle(wheelCenter, wheelRadius, linePaint);
    canvas.drawCircle(wheelCenter, wheelRadius * .72, linePaint);
    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final inner =
          wheelCenter +
          Offset(math.cos(angle), math.sin(angle)) * wheelRadius * .72;
      final outer =
          wheelCenter + Offset(math.cos(angle), math.sin(angle)) * wheelRadius;
      canvas.drawLine(inner, outer, linePaint);
    }

    final orbitRect = Rect.fromCenter(
      center: Offset(size.width * .58, size.height * .77),
      width: size.width * .92,
      height: size.height * .37,
    );
    canvas.drawArc(
      orbitRect,
      math.pi * .9,
      math.pi * .88 * value,
      false,
      linePaint,
    );

    final points = <Offset>[
      Offset(size.width * .08, size.height * .2),
      Offset(size.width * .18, size.height * .12),
      Offset(size.width * .13, size.height * .29),
      Offset(size.width * .76, size.height * .74),
      Offset(size.width * .88, size.height * .68),
    ];
    for (final point in points) {
      canvas.drawCircle(point, 2.2, pointPaint);
    }
    canvas.drawLine(points[0], points[1], linePaint);
    canvas.drawLine(points[0], points[2], linePaint);

    _drawStar(canvas, Offset(size.width * .7, size.height * .12), 5, linePaint);
    _drawStar(
      canvas,
      Offset(size.width * .92, size.height * .58),
      4,
      linePaint,
    );
    _drawStar(
      canvas,
      Offset(size.width * .12, size.height * .68),
      3.5,
      linePaint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawLine(
      center - Offset(radius, 0),
      center + Offset(radius, 0),
      paint,
    );
    canvas.drawLine(
      center - Offset(0, radius),
      center + Offset(0, radius),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CelestialHeroPainter oldDelegate) => false;
}

class DailyGuidanceHeroSkeleton extends StatelessWidget {
  const DailyGuidanceHeroSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Loading daily guidance',
    child: ExcludeSemantics(
      child: Container(
        constraints: const BoxConstraints(minHeight: 264),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              AppColors.secondaryBackground,
              AppColors.softLavender,
              AppColors.highlightSurface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SkeletonBlock(width: 138, height: 10),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBlock(width: 160, height: 25),
                      SizedBox(height: 8),
                      _SkeletonBlock(width: 126, height: 25),
                      SizedBox(height: 16),
                      _SkeletonBlock(height: 12),
                      SizedBox(height: 7),
                      _SkeletonBlock(width: 145, height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 98,
                  height: 98,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceLight, width: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _SkeletonBlock(width: 182, height: 48, radius: 16),
            const SizedBox(height: 20),
            const _SkeletonBlock(width: 190, height: 46, radius: 24),
          ],
        ),
      ),
    ),
  );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    this.width = double.infinity,
    required this.height,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surfaceLight.withValues(alpha: .7),
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
