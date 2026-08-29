import 'package:flutter/material.dart';
import '../theme/utils/responsive.dart';

/// A wrapper widget that constrains the maximum width of the content
/// on tablets and desktops, while allowing the background to fill the screen.
/// On mobile it is a transparent pass-through.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? context.maxContentWidth;

    if (context.isMobile) {
      // On mobile just pass through — no constraint needed
      return child;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}
