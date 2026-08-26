import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Standard animation constants and helper extensions for AstroSaathi.
class AppAnimations {
  // ── Durations ─────────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration entrance = Duration(milliseconds: 600);
  static const Duration staggerDelay = Duration(milliseconds: 80);

  // ── Curves ────────────────────────────────────────────────────────
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve entranceCurve = Curves.easeOutQuart;
}

/// Extension on Widget for common AstroSaathi animations.
extension AstroAnimations on Widget {
  /// Fade + slide up entrance animation.
  Widget fadeSlideUp({
    Duration? delay,
    Duration? duration,
  }) {
    return animate(
      delay: delay ?? Duration.zero,
    )
        .fadeIn(
          duration: duration ?? AppAnimations.entrance,
          curve: AppAnimations.entranceCurve,
        )
        .slideY(
          begin: 0.08,
          end: 0,
          duration: duration ?? AppAnimations.entrance,
          curve: AppAnimations.entranceCurve,
        );
  }

  /// Scale-in entrance animation.
  Widget scaleIn({
    Duration? delay,
    Duration? duration,
  }) {
    return animate(
      delay: delay ?? Duration.zero,
    )
        .fadeIn(
          duration: duration ?? AppAnimations.normal,
          curve: AppAnimations.defaultCurve,
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: duration ?? AppAnimations.normal,
          curve: AppAnimations.bounceCurve,
        );
  }

  /// Fade-in only entrance.
  Widget fadeInOnly({
    Duration? delay,
    Duration? duration,
  }) {
    return animate(
      delay: delay ?? Duration.zero,
    ).fadeIn(
      duration: duration ?? AppAnimations.entrance,
      curve: AppAnimations.defaultCurve,
    );
  }
}
