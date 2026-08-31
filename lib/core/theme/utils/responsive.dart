import 'package:flutter/material.dart';

/// Breakpoints for device categories
enum DeviceType { mobile, tablet, desktop }

/// Extended device classifications for precise layout targeting
enum SubDeviceType {
  smallMobile,     // 320px - 375px (iPhone SE, compact Androids)
  standardMobile,  // 376px - 412px (iPhone 14/15/16, Pixel, Galaxy S)
  largeMobile,     // 413px - 599px (iPhone Pro Max, Plus, Galaxy Ultra)
  smallTablet,     // 600px - 767px (Foldables, iPad Mini)
  standardTablet,  // 768px - 1023px (iPad Air, 10th Gen, Galaxy Tab)
  largeTablet,     // 1024px - 1280px (iPad Pro, Surface, 13" Laptops)
  desktop,         // 1281px+ (Desktops, 2K/4K Monitors)
}

/// Central responsive utility — use anywhere via `context.responsive`
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  DeviceType get deviceType {
    if (screenWidth < 600) return DeviceType.mobile;
    if (screenWidth < 1024) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  SubDeviceType get subDeviceType {
    if (screenWidth < 376) return SubDeviceType.smallMobile;
    if (screenWidth < 413) return SubDeviceType.standardMobile;
    if (screenWidth < 600) return SubDeviceType.largeMobile;
    if (screenWidth < 768) return SubDeviceType.smallTablet;
    if (screenWidth < 1024) return SubDeviceType.standardTablet;
    if (screenWidth <= 1280) return SubDeviceType.largeTablet;
    return SubDeviceType.desktop;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  bool get isSmallMobile => subDeviceType == SubDeviceType.smallMobile;
  bool get isStandardMobile => subDeviceType == SubDeviceType.standardMobile;
  bool get isLargeMobile => subDeviceType == SubDeviceType.largeMobile;
  bool get isSmallTablet => subDeviceType == SubDeviceType.smallTablet;
  bool get isStandardTablet => subDeviceType == SubDeviceType.standardTablet;
  bool get isLargeTablet => subDeviceType == SubDeviceType.largeTablet;

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

  /// Fine-grained responsive picker for detailed device categories
  T responsiveDetailed<T>({
    required T mobile,
    T? smallMobile,
    T? largeMobile,
    T? tablet,
    T? largeTablet,
    T? desktop,
  }) {
    switch (subDeviceType) {
      case SubDeviceType.smallMobile:
        return smallMobile ?? mobile;
      case SubDeviceType.standardMobile:
        return mobile;
      case SubDeviceType.largeMobile:
        return largeMobile ?? mobile;
      case SubDeviceType.smallTablet:
      case SubDeviceType.standardTablet:
        return tablet ?? mobile;
      case SubDeviceType.largeTablet:
        return largeTablet ?? tablet ?? desktop ?? mobile;
      case SubDeviceType.desktop:
        return desktop ?? largeTablet ?? tablet ?? mobile;
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
