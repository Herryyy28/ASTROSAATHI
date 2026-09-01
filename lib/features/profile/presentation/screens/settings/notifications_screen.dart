import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _dailyHoroscope = true;
  bool _lunarPhases = true;
  bool _planetaryTransits = false;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryDark,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Customize your cosmic alerts',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textSecondaryDark,
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildToggle(
                    'Daily Horoscope',
                    'Get your morning cosmic reading',
                    _dailyHoroscope,
                    (val) => setState(() => _dailyHoroscope = val),
                  ),
                  Divider(color: AppColors.glassBorder),
                  _buildToggle(
                    'Lunar Phases',
                    'Alerts for Full Moon & New Moon',
                    _lunarPhases,
                    (val) => setState(() => _lunarPhases = val),
                  ),
                  Divider(color: AppColors.glassBorder),
                  _buildToggle(
                    'Planetary Transits',
                    'Major astrological shifts',
                    _planetaryTransits,
                    (val) => setState(() => _planetaryTransits = val),
                  ),
                  Divider(color: AppColors.glassBorder),
                  _buildToggle(
                    'App Updates',
                    'New features and improvements',
                    _appUpdates,
                    (val) => setState(() => _appUpdates = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondaryDark,
        ),
      ),
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withOpacity(0.3),
      inactiveThumbColor: AppColors.textTertiaryDark,
      inactiveTrackColor: AppColors.surfaceHighlightDark,
      contentPadding: EdgeInsets.zero,
    );
  }
}
