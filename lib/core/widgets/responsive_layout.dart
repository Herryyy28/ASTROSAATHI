import 'package:flutter/material.dart';

/// A wrapper widget that constrains the maximum width of the content 
/// on large screens (tablets, desktop web) to make it look like a mobile app layout,
/// while allowing the background to fill the screen.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 550, // Standard max width for mobile-proportioned view
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: child,
      ),
    );
  }
}
