import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CosmicNotification {
  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  static void showSuccess(
    BuildContext context, {
    String title = 'Success',
    required String message,
    IconData icon = Icons.verified_rounded,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      title: title,
      message: message,
      icon: icon,
      accentColor: const Color(0xFFFFD700),
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    String title = 'Notice',
    required String message,
    IconData icon = Icons.error_outline_rounded,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      title: title,
      message: message,
      icon: icon,
      accentColor: Colors.redAccent,
      duration: duration,
    );
  }

  static void show(
    BuildContext context, {
    String title = 'AstroSaathi',
    required String message,
    IconData icon = Icons.stars_rounded,
    Color accentColor = const Color(0xFFFFD700),
    Duration duration = const Duration(seconds: 3),
  }) {
    _dismissCurrent();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _TopAnimatedCosmicToast(
        title: title,
        message: message,
        icon: icon,
        accentColor: accentColor,
        onDismiss: () => _dismissEntry(entry),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _timer = Timer(duration, () {
      _dismissEntry(entry);
    });
  }

  static void _dismissCurrent() {
    _timer?.cancel();
    _timer = null;
    if (_currentEntry != null && _currentEntry!.mounted) {
      _currentEntry!.remove();
      _currentEntry = null;
    }
  }

  static void _dismissEntry(OverlayEntry entry) {
    if (_currentEntry == entry) {
      _currentEntry = null;
    }
    if (entry.mounted) {
      entry.remove();
    }
  }
}

class _TopAnimatedCosmicToast extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onDismiss;

  const _TopAnimatedCosmicToast({
    required this.title,
    required this.message,
    required this.icon,
    required this.accentColor,
    required this.onDismiss,
  });

  @override
  State<_TopAnimatedCosmicToast> createState() => _TopAnimatedCosmicToastState();
}

class _TopAnimatedCosmicToastState extends State<_TopAnimatedCosmicToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  void _dismissWithAnimation() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Positioned(
      top: topInset + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final yOffset = -65.0 * (1.0 - _slideAnimation.value);
            return Transform.translate(
              offset: Offset(0, yOffset),
              child: Opacity(
                opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up,
            onDismissed: (_) => widget.onDismiss(),
            child: GestureDetector(
              onTap: _dismissWithAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isLight
                          ? Colors.white.withOpacity(0.85)
                          : const Color(0xCC121824),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.accentColor.withOpacity(0.5),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.accentColor.withOpacity(0.22),
                          blurRadius: 20,
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                widget.accentColor.withOpacity(0.3),
                                widget.accentColor.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(color: widget.accentColor.withOpacity(0.5)),
                          ),
                          child: Icon(widget.icon, color: widget.accentColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.message,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.getTextSecondary(context),
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.getTextMuted(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
