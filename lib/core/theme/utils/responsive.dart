import 'package:flutter/material.dart';

/// Breakpoints for device categories
enum DeviceType { mobile, tablet, desktop }

/// Central responsive utility — use anywhere via `context.responsive`
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  DeviceType get deviceType {
    if (screenWidth < 600) return DeviceType.mobile;
    if (screenWidth < 1024) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Responsive value: pick one based on device type
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  // ── Responsive Spacing ────────────────────────────────────────────
  double get spacingXS => responsive(mobile: 8.0, tablet: 10.0, desktop: 12.0);
  double get spacingSM => responsive(mobile: 12.0, tablet: 16.0, desktop: 20.0);
  double get spacingMD => responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0);
  double get spacingLG => responsive(mobile: 24.0, tablet: 32.0, desktop: 48.0);
  double get spacingXL => responsive(mobile: 32.0, tablet: 48.0, desktop: 64.0);

  // ── Responsive Padding ────────────────────────────────────────────
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: responsive(mobile: 20.0, tablet: 32.0, desktop: 48.0),
        vertical: responsive(mobile: 20.0, tablet: 28.0, desktop: 32.0),
      );

  EdgeInsets get cardPadding => EdgeInsets.all(
        responsive(mobile: 16.0, tablet: 22.0, desktop: 28.0),
      );

  // ── Responsive Font Sizes ─────────────────────────────────────────
  double get fontXS => responsive(mobile: 11.0, tablet: 12.0, desktop: 13.0);
  double get fontSM => responsive(mobile: 13.0, tablet: 14.0, desktop: 15.0);
  double get fontMD => responsive(mobile: 15.0, tablet: 16.0, desktop: 17.0);
  double get fontLG => responsive(mobile: 18.0, tablet: 20.0, desktop: 22.0);
  double get fontXL => responsive(mobile: 22.0, tablet: 26.0, desktop: 30.0);
  double get fontDisplay => responsive(mobile: 28.0, tablet: 34.0, desktop: 42.0);

  // ── Max content width ─────────────────────────────────────────────
  double get maxContentWidth =>
      responsive(mobile: double.infinity, tablet: 680.0, desktop: 860.0);
}
