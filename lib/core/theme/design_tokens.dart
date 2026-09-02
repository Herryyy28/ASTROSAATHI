import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized Spacing Scale for AstroSaathi (Single Source of Truth)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xl2 = 28.0;
  static const double xxxl = 32.0;
  static const double xl3 = 40.0;
  static const double giant = 48.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
}

/// Centralized Border Radius Scale for AstroSaathi (Single Source of Truth)
class AppRadius {
  static const double chip = 10.0;
  static const double button = 12.0;
  static const double input = 12.0;
  static const double card = 14.0;
  static const double modal = 16.0;
  static const double full = 999.0;

  static const double xs = 8.0;
  static const double sm = 10.0;
  static const double md = 12.0;
  static const double lg = 14.0;
  static const double xl = 16.0;
  static const double xl2 = 20.0;
  static const double xl3 = 24.0;
  static const double pill = 999.0;

  static BorderRadius get borderChip => BorderRadius.circular(chip);
  static BorderRadius get borderButton => BorderRadius.circular(button);
  static BorderRadius get borderInput => BorderRadius.circular(input);
  static BorderRadius get borderCard => BorderRadius.circular(card);
  static BorderRadius get borderModal => BorderRadius.circular(modal);
  static BorderRadius get borderFull => BorderRadius.circular(full);
  static BorderRadius get borderXL2 => BorderRadius.circular(xl2);
  static BorderRadius get borderXL3 => BorderRadius.circular(xl3);
  static BorderRadius get borderPill => BorderRadius.circular(pill);
}

/// Blinkit-Inspired Compact Typography Scale for AstroSaathi (Single Source of Truth)
class AppTypography {
  static TextStyle display({required Color color}) => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: color,
      );

  static TextStyle headline({required Color color}) => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
        color: color,
      );

  static TextStyle title({required Color color}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
        color: color,
      );

  static TextStyle body({required Color color}) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle label({required Color color}) => GoogleFonts.outfit(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.3,
        color: color,
      );

  static TextStyle caption({required Color color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: color,
      );
}
