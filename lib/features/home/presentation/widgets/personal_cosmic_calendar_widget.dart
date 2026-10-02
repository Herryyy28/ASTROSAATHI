import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../reminders/providers/reminder_provider.dart';
import 'add_event_modal.dart';

class CosmicCalendarDay {
  final DateTime date;
  final String dayName;
  final String dayNumber;
  final String energyLevel; // High, Auspicious, Neutral, Caution
  final Color badgeColor;
  final String nakshatra;
  final String yoga;
  final String transitHighlight;
  final String rahuKaal;
  final String bestWindow;
  final String recommendation;

  CosmicCalendarDay({
    required this.date,
    required this.dayName,
    required this.dayNumber,
    required this.energyLevel,
    required this.badgeColor,
    required this.nakshatra,
    required this.yoga,
    required this.transitHighlight,
    required this.rahuKaal,
    required this.bestWindow,
    required this.recommendation,
  });
}

class PersonalCosmicCalendarWidget extends ConsumerStatefulWidget {
  const PersonalCosmicCalendarWidget({super.key});

  @override
  ConsumerState<PersonalCosmicCalendarWidget> createState() => _PersonalCosmicCalendarWidgetState();
}

class _PersonalCosmicCalendarWidgetState extends ConsumerState<PersonalCosmicCalendarWidget> {
  int _selectedIndex = 3; // Default to Today (Index 3)

  List<CosmicCalendarDay> _buildDays(AppLanguage lang) {
    final now = DateTime.now();
    List<String> dayNames;
    if (lang == AppLanguage.hindi) {
      dayNames = ['à¤¸à¥‹à¤®', 'à¤®à¤‚à¤—à¤²', 'à¤¬à¥à¤§', 'à¤—à¥à¤°à¥', 'à¤¶à¥à¤•à¥à¤°', 'à¤¶à¤¨à¤¿', 'à¤°à¤µà¤¿'];
    } else if (lang == AppLanguage.gujarati) {
      dayNames = ['àª¸à«‹àª®', 'àª®àª‚àª—àª³', 'àª¬à«àª§', 'àª—à«àª°à«', 'àª¶à«àª•à«àª°', 'àª¶àª¨àª¿', 'àª°àªµàª¿'];
    } else {
      dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }

    return List.generate(7, (index) {
      final date = now.add(Duration(days: index - 3));
      final dayName = dayNames[date.weekday - 1];
      final dayNum = date.day.toString().padLeft(2, '0');

      if (lang == AppLanguage.hindi) {
        switch (index) {
          case 0:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'à¤¸à¤‚à¤¤à¥à¤²à¤¿à¤¤',
              badgeColor: AppColors.secondary,
              nakshatra: 'à¤ªà¥à¤·à¥à¤¯ à¤¨à¤•à¥à¤·à¤¤à¥à¤°',
              yoga: 'à¤¸à¤¿à¤¦à¥à¤§ à¤¯à¥‹à¤—',
              transitHighlight: 'à¤šà¤‚à¤¦à¥à¤°à¤®à¤¾ à¤•à¤¾ à¤•à¤°à¥à¤• à¤°à¤¾à¤¶à¤¿ à¤®à¥‡à¤‚ à¤ªà¥à¤°à¤µà¥‡à¤¶ • à¤­à¤¾à¤µà¤¨à¤¾à¤¤à¥à¤®à¤• à¤¸à¥à¤ªà¤·à¥à¤Ÿà¤¤à¤¾',
              rahuKaal: '07:30 AM - 09:00 AM',
              bestWindow: '10:15 AM - 12:30 PM',
              recommendation: 'à¤Ÿà¥€à¤® à¤¬à¥ˆà¤ à¤•à¥‹à¤‚ à¤”à¤° à¤¦à¥€à¤°à¥à¤˜à¤•à¤¾à¤²à¤¿à¤• à¤¯à¥‹à¤œà¤¨à¤¾à¤“à¤‚ à¤•à¥‡ à¤²à¤¿à¤ à¤†à¤¦à¤°à¥à¤¶ à¤¦à¤¿à¤¨à¥¤',
            );
          case 1:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'à¤¶à¥à¤­',
              badgeColor: AppColors.success,
              nakshatra: 'à¤…à¤¶à¥à¤²à¥‡à¤·à¤¾ à¤¨à¤•à¥à¤·à¤¤à¥à¤°',
              yoga: 'à¤…à¤®à¥ƒà¤¤ à¤¸à¤¿à¤¦à¥à¤§à¤¿ à¤¯à¥‹à¤—',
              transitHighlight: 'à¤¬à¥à¤§ à¤•à¤¾ 10à¤µà¥‡à¤‚ à¤­à¤¾à¤µ à¤®à¥‡à¤‚ à¤¸à¤‚à¤šà¤°à¤£ • à¤µà¤¾à¤•à¥ à¤šà¤¾à¤¤à¥à¤°à¥à¤¯',
              rahuKaal: '03:00 PM - 04:30 PM',
              bestWindow: '09:00 AM - 11:15 AM',
              recommendation: 'à¤…à¤¨à¥à¤¬à¤‚à¤§ à¤ªà¤° à¤¹à¤¸à¥à¤¤à¤¾à¤•à¥à¤·à¤°, à¤•à¥à¤²à¤¾à¤‡à¤‚à¤Ÿ à¤®à¥€à¤Ÿà¤¿à¤‚à¤— à¤”à¤° à¤¬à¤¾à¤¤à¤šà¥€à¤¤ à¤¨à¤¿à¤·à¥à¤ªà¤¾à¤¦à¤¿à¤¤ à¤•à¤°à¥‡à¤‚à¥¤',
            );
          case 2:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'à¤¸à¤¾à¤µà¤§à¤¾à¤¨à¥€',
              badgeColor: AppColors.error,
              nakshatra: 'à¤®à¤˜à¤¾ à¤¨à¤•à¥à¤·à¤¤à¥à¤°',
              yoga: 'à¤µà¥à¤¯à¤¤à¥€à¤ªà¤¾à¤¤ à¤¯à¥‹à¤—',
              transitHighlight: 'à¤®à¤‚à¤—à¤²-à¤°à¤¾à¤¹à¥ à¤¦à¥ƒà¤·à¥à¤Ÿà¤¿ • à¤‰à¤—à¥à¤° à¤Šà¤°à¥à¤œà¤¾',
              rahuKaal: '12:00 PM - 01:30 PM',
              bestWindow: '04:00 PM - 05:30 PM',
              recommendation: 'à¤¬à¤¡à¤¼à¥‡ à¤µà¤¿à¤¤à¥à¤¤à¥€à¤¯ à¤¨à¤¿à¤°à¥à¤£à¤¯à¥‹à¤‚ à¤¯à¤¾ à¤µà¤¿à¤µà¤¾à¤¦à¥‹à¤‚ à¤¸à¥‡ à¤¬à¤šà¥‡à¤‚à¥¤',
            );
          case 3:
            return CosmicCalendarDay(
              date: date,
              dayName: 'à¤†à¤œ',
              dayNumber: dayNum,
              energyLevel: 'à¤‰à¤šà¥à¤šà¤¤à¤® à¤Šà¤°à¥à¤œà¤¾ ✦',
              badgeColor: AppColors.primary,
              nakshatra: 'à¤ªà¥‚à¤°à¥à¤µà¤¾ à¤«à¤¾à¤²à¥à¤—à¥à¤¨à¥€ à¤¨à¤•à¥à¤·à¤¤à¥à¤°',
              yoga: 'à¤—à¤œà¤•à¥‡à¤¸à¤°à¥€ à¤¯à¥‹à¤— à¤¸à¤•à¥à¤°à¤¿à¤¯',
              transitHighlight: 'à¤—à¥à¤°à¥-à¤šà¤‚à¤¦à¥à¤° à¤¦à¥ƒà¤·à¥à¤Ÿà¤¿ • à¤µà¤¿à¤¤à¥à¤¤à¥€à¤¯ à¤µà¥ƒà¤¦à¥à¤§à¤¿ à¤¯à¥‹à¤—',
              rahuKaal: '01:30 PM - 03:00 PM',
              bestWindow: '08:45 AM - 11:30 AM',
              recommendation: 'à¤¨à¤¯à¥‡ à¤•à¤¾à¤°à¥à¤¯ à¤ªà¥à¤°à¤¾à¤°à¤‚à¤­ à¤•à¤°à¥‡à¤‚, à¤¸à¤‚à¤ªà¤¤à¥à¤¤à¤¿ à¤–à¤°à¥€à¤¦à¥‡à¤‚ à¤¯à¤¾ à¤ªà¤¦à¥‹à¤¨à¥à¤¨à¤¤à¤¿ à¤•à¥€ à¤¬à¤¾à¤¤ à¤•à¤°à¥‡à¤‚à¥¤',
            );
          case 4:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'à¤¶à¥à¤­',
              badgeColor: AppColors.success,
              nakshatra: 'à¤‰à¤¤à¥à¤¤à¤°à¤¾ à¤«à¤¾à¤²à¥à¤—à¥à¤¨à¥€',
              yoga: 'à¤¶à¥à¤­ à¤¯à¥‹à¤—',
              transitHighlight: 'à¤¶à¥à¤•à¥à¤° à¤•à¤¾ 11à¤µà¥‡à¤‚ à¤­à¤¾à¤µ à¤®à¥‡à¤‚ à¤¯à¥à¤¤à¤¿ • à¤¸à¤‚à¤¬à¤‚à¤§à¥‹à¤‚ à¤®à¥‡à¤‚ à¤ªà¥à¤°à¤—à¤¾à¤¢à¤¼à¤¤à¤¾',
              rahuKaal: '10:30 AM - 12:00 PM',
              bestWindow: '02:00 PM - 04:30 PM',
              recommendation: 'à¤ªà¤¾à¤°à¤¿à¤µà¤¾à¤°à¤¿à¤• à¤à¤µà¤‚ à¤¸à¤¾à¤®à¤¾à¤œà¤¿à¤• à¤•à¤¾à¤°à¥à¤¯à¥‹à¤‚ à¤•à¥‡ à¤²à¤¿à¤ à¤‰à¤¤à¥à¤¤à¤® à¤¸à¤®à¤¯à¥¤',
            );
          case 5:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'à¤¶à¤¾à¤‚à¤¤à¤¿à¤¦à¤¾à¤¯à¤•',
              badgeColor: AppColors.secondary,
              nakshatra: 'à¤¹à¤¸à¥à¤¤ à¤¨à¤•à¥à¤·à¤¤à¥à¤°',
              yoga: 'à¤¬à¥à¤°à¤¹à¥à¤® à¤¯à¥‹à¤—',
              transitHighlight: 'à¤¸à¥‚à¤°à¥à¤¯-à¤¶à¤¨à¤¿ à¤¦à¥ƒà¤·à¥à¤Ÿà¤¿ • à¤…à¤¨à¥à¤¶à¤¾à¤¸à¤¨ à¤à¤µà¤‚ à¤ªà¥à¤°à¤¤à¤¿à¤·à¥à¤ à¤¾',
              rahuKaal: '09:00 AM - 10:30 AM',
              bestWindow: '06:30 AM - 08:30 AM',
              recommendation: 'à¤†à¤§à¥à¤¯à¤¾à¤¤à¥à¤®à¤¿à¤• à¤¸à¤¾à¤§à¤¨à¤¾ à¤à¤µà¤‚ à¤§à¥à¤¯à¤¾à¤¨ à¤•à¥‡ à¤²à¤¿à¤ à¤…à¤¤à¥à¤¯à¤‚à¤¤ à¤‰à¤ªà¤¯à¥à¤•à¥à¤¤à¥¤',
            );
          default:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'à¤…à¤¨à¥à¤•à¥‚à¤²',
              badgeColor: AppColors.primary,
              nakshatra: 'à¤šà¤¿à¤¤à¥à¤°à¤¾ à¤¨à¤•à¥à¤·à¤¤à¥à¤°',
              yoga: 'à¤‡à¤¨à¥à¤¦à¥à¤° à¤¯à¥‹à¤—',
              transitHighlight: 'à¤šà¤‚à¤¦à¥à¤°à¤®à¤¾ à¤•à¤¾ à¤•à¤¨à¥à¤¯à¤¾ à¤°à¤¾à¤¶à¤¿ à¤®à¥‡à¤‚ à¤—à¥‹à¤šà¤°',
              rahuKaal: '04:30 PM - 06:00 PM',
              bestWindow: '11:00 AM - 01:00 PM',
              recommendation: 'à¤¸à¤ªà¥à¤¤à¤¾à¤¹ à¤•à¥‡ à¤•à¤¾à¤°à¥à¤¯à¥‹à¤‚ à¤•à¥€ à¤¸à¤®à¥€à¤•à¥à¤·à¤¾ à¤•à¤°à¥‡à¤‚ à¤à¤µà¤‚ à¤¨à¤ à¤²à¤•à¥à¤·à¥à¤¯ à¤¨à¤¿à¤°à¥à¤§à¤¾à¤°à¤¿à¤¤ à¤•à¤°à¥‡à¤‚à¥¤',
            );
        }
      } else if (lang == AppLanguage.gujarati) {
        switch (index) {
          case 0:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'àª¸àª‚àª¤à«àª²àª¿àª¤',
              badgeColor: AppColors.secondary,
              nakshatra: 'àªªà«àª·à«àª¯ àª¨àª•à«àª·àª¤à«àª°',
              yoga: 'àª¸àª¿àª¦à«àª§ àª¯à«‹àª—',
              transitHighlight: 'àªšàª‚àª¦à«àª°àª®àª¾àª¨à«àª‚ àª•àª°à«àª• àª°àª¾àª¶àª¿àª®àª¾àª‚ àªªà«àª°àªµà«‡àª¶ • àª­àª¾àªµàª¨àª¾àª¤à«àª®àª• àª¸à«àªªàª·à«àªŸàª¤àª¾',
              rahuKaal: '07:30 AM - 09:00 AM',
              bestWindow: '10:15 AM - 12:30 PM',
              recommendation: 'àªŸà«€àª® àª®à«€àªŸàª¿àª‚àª—à«àª¸ àª…àª¨à«‡ àª²àª¾àª‚àª¬àª¾ àª—àª¾àª³àª¾àª¨àª¾ àª†àª¯à«‹àªœàª¨ àª®àª¾àªŸà«‡ àª‰àª¤à«àª¤àª® àª¦àª¿àªµàª¸.',
            );
          case 1:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'àª¶à«àª­',
              badgeColor: AppColors.success,
              nakshatra: 'àª…àª¶à«àª²à«‡àª·àª¾ àª¨àª•à«àª·àª¤à«àª°',
              yoga: 'àª…àª®à«ƒàª¤ àª¸àª¿àª¦à«àª§àª¿ àª¯à«‹àª—',
              transitHighlight: 'àª¬à«àª§àª¨à«àª‚ 10àª®àª¾ àª¸à«àª¥àª¾àª¨àª®àª¾àª‚ àªªàª°àª¿àª­à«àª°àª®àª£ • àªµàª¾àª£à«€ àª²àª¾àª­',
              rahuKaal: '03:00 PM - 04:30 PM',
              bestWindow: '09:00 AM - 11:15 AM',
              recommendation: 'àª®àª¹àª¤à«àªµàª¨àª¾ àª•àª°àª¾àª° àª…àª¨à«‡ àª®à«€àªŸàª¿àª‚àª—à«àª¸ àªªà«‚àª°à«àª£ àª•àª°à«‹.',
            );
          case 2:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'àª¸àª¾àªµàª§àª¾àª¨à«€',
              badgeColor: AppColors.error,
              nakshatra: 'àª®àª˜àª¾ àª¨àª•à«àª·àª¤à«àª°',
              yoga: 'àªµà«àª¯àª¤à«€àªªàª¾àª¤ àª¯à«‹àª—',
              transitHighlight: 'àª®àª‚àª—àª³-àª°àª¾àª¹à« àª¦à«àª°àª·à«àªŸàª¿ • àª‰àª—à«àª° àªŠàª°à«àªœàª¾',
              rahuKaal: '12:00 PM - 01:30 PM',
              bestWindow: '04:00 PM - 05:30 PM',
              recommendation: 'àª®à«‹àªŸàª¾ àª¨àª¾àª£àª¾àª•à«€àª¯ àª¨àª¿àª°à«àª£àª¯à«‹ àª…àª¨à«‡ àª¦àª²à«€àª²à«‹ àªŸàª¾àª³à«‹.',
            );
          case 3:
            return CosmicCalendarDay(
              date: date,
              dayName: 'àª†àªœà«‡',
              dayNumber: dayNum,
              energyLevel: 'àª‰àªšà«àªšàª¤àª® àªŠàª°à«àªœàª¾ ✦',
              badgeColor: AppColors.primary,
              nakshatra: 'àªªà«‚àª°à«àªµàª¾ àª«àª¾àª²à«àª—à«àª¨à«€ àª¨àª•à«àª·àª¤à«àª°',
              yoga: 'àª—àªœàª•à«‡àª¸àª°à«€ àª¯à«‹àª— àª¸àª•à«àª°àª¿àª¯',
              transitHighlight: 'àª—à«àª°à«-àªšàª‚àª¦à«àª° àª¯à«‹àª— • àª¨àª¾àª£àª¾àª•à«€àª¯ àªµà«ƒàª¦à«àª§àª¿',
              rahuKaal: '01:30 PM - 03:00 PM',
              bestWindow: '08:45 AM - 11:30 AM',
              recommendation: 'àª¨àªµàª¾ àª•àª¾àª°à«àª¯à«‹àª¨à«‹ àªªà«àª°àª¾àª°àª‚àª­ àª•àª°à«‹ àª…àª¥àªµàª¾ àªªà«àª°àª®à«‹àª¶àª¨ àª…àª‚àª—à«‡ àªšàª°à«àªšàª¾ àª•àª°à«‹.',
            );
          case 4:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'àª¶à«àª­',
              badgeColor: AppColors.success,
              nakshatra: 'àª‰àª¤à«àª¤àª°àª¾ àª«àª¾àª²à«àª—à«àª¨à«€',
              yoga: 'àª¶à«àª­ àª¯à«‹àª—',
              transitHighlight: 'àª¶à«àª•à«àª°àª¨à«€ àª¯à«àª¤àª¿ • àª¸àª‚àª¬àª‚àª§à«‹àª®àª¾àª‚ àª®àª§à«àª°àª¤àª¾',
              rahuKaal: '10:30 AM - 12:00 PM',
              bestWindow: '02:00 PM - 04:30 PM',
              recommendation: 'àª•à«ŒàªŸà«àª‚àª¬àª¿àª• àª…àª¨à«‡ àª¸àª¾àª®àª¾àªœàª¿àª• àªªà«àª°àª¸àª‚àª—à«‹ àª®àª¾àªŸà«‡ àª‰àª¤à«àª¤àª®.',
            );
          case 5:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'àª¶àª¾àª‚àª¤àª¿àª¦àª¾àª¯àª•',
              badgeColor: AppColors.secondary,
              nakshatra: 'àª¹àª¸à«àª¤ àª¨àª•à«àª·àª¤à«àª°',
              yoga: 'àª¬à«àª°àª¹à«àª® àª¯à«‹àª—',
              transitHighlight: 'àª¸à«‚àª°à«àª¯-àª¶àª¨àª¿ àª¦à«àª°àª·à«àªŸàª¿ • àª…àª¨à«àª¶àª¾àª¸àª¨',
              rahuKaal: '09:00 AM - 10:30 AM',
              bestWindow: '06:30 AM - 08:30 AM',
              recommendation: 'àª†àª§à«àª¯àª¾àª¤à«àª®àª¿àª• àª¸àª¾àª§àª¨àª¾ àª…àª¨à«‡ àª§à«àª¯àª¾àª¨ àª®àª¾àªŸà«‡ àª…àª¨à«àª•à«‚àª³.',
            );
          default:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'àª…àª¨à«àª•à«‚àª³',
              badgeColor: AppColors.primary,
              nakshatra: 'àªšàª¿àª¤à«àª°àª¾ àª¨àª•à«àª·àª¤à«àª°',
              yoga: 'àª‡àª¨à«àª¦à«àª° àª¯à«‹àª—',
              transitHighlight: 'àªšàª‚àª¦à«àª°àª®àª¾àª¨à«àª‚ àª•àª¨à«àª¯àª¾ àª°àª¾àª¶àª¿àª®àª¾àª‚ àª—à«‹àªšàª°',
              rahuKaal: '04:30 PM - 06:00 PM',
              bestWindow: '11:00 AM - 01:00 PM',
              recommendation: 'àª…àª àªµàª¾àª¡àª¿àª¯àª¾àª¨àª¾ àª•àª¾àª°à«àª¯à«‹àª¨à«€ àª¸àª®à«€àª•à«àª·àª¾ àª•àª°à«‹ àª…àª¨à«‡ àª¨àªµàª¾ àª²àª•à«àª·à«àª¯à«‹ àª¨àª•à«àª•à«€ àª•àª°à«‹.',
            );
        }
      } else {
        switch (index) {
          case 0:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'Balanced',
              badgeColor: AppColors.secondary,
              nakshatra: 'Pushya Nakshatra',
              yoga: 'Siddha Yoga',
              transitHighlight: 'Moon enters Cancer • Emotional Clarity',
              rahuKaal: '07:30 AM - 09:00 AM',
              bestWindow: '10:15 AM - 12:30 PM',
              recommendation: 'Ideal day for team meetings and long-term planning.',
            );
          case 1:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'Auspicious',
              badgeColor: AppColors.success,
              nakshatra: 'Ashlesha Nakshatra',
              yoga: 'Amrit Siddhi Yoga',
              transitHighlight: 'Mercury Aspecting 10th House • Speech Luck',
              rahuKaal: '03:00 PM - 04:30 PM',
              bestWindow: '09:00 AM - 11:15 AM',
              recommendation: 'Execute contract signings, client pitches & negotiations.',
            );
          case 2:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'Caution',
              badgeColor: AppColors.error,
              nakshatra: 'Magha Nakshatra',
              yoga: 'Vyatipata Yoga',
              transitHighlight: 'Mars-Rahu Square Aspect • High Temperament',
              rahuKaal: '12:00 PM - 01:30 PM',
              bestWindow: '04:00 PM - 05:30 PM',
              recommendation: 'Avoid major financial commitments or heated arguments.',
            );
          case 3:
            return CosmicCalendarDay(
              date: date,
              dayName: 'TODAY',
              dayNumber: dayNum,
              energyLevel: 'Peak Energy ✦',
              badgeColor: AppColors.primary,
              nakshatra: 'Purva Phalguni Nakshatra',
              yoga: 'Gajakesari Yoga Active',
              transitHighlight: 'Jupiter Trine Moon • Peak Financial Alignment',
              rahuKaal: '01:30 PM - 03:00 PM',
              bestWindow: '08:45 AM - 11:30 AM',
              recommendation: 'Launch new initiatives, buy assets, or seek promotions.',
            );
          case 4:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'Auspicious',
              badgeColor: AppColors.success,
              nakshatra: 'Uttara Phalguni',
              yoga: 'Shubha Yoga',
              transitHighlight: 'Venus Conjunction in 11th House • Relationship Growth',
              rahuKaal: '10:30 AM - 12:00 PM',
              bestWindow: '02:00 PM - 04:30 PM',
              recommendation: 'Plan social gatherings, romantic dates or creative projects.',
            );
          case 5:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'Peaceful',
              badgeColor: AppColors.secondary,
              nakshatra: 'Hasta Nakshatra',
              yoga: 'Brahma Yoga',
              transitHighlight: 'Sun Trine Saturn • Discipline & Recognition',
              rahuKaal: '09:00 AM - 10:30 AM',
              bestWindow: '06:30 AM - 08:30 AM',
              recommendation: 'Great for spiritual practices, meditation & body detox.',
            );
          default:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'Favorable',
              badgeColor: AppColors.primary,
              nakshatra: 'Chitra Nakshatra',
              yoga: 'Indra Yoga',
              transitHighlight: 'Moon Transiting Virgo',
              rahuKaal: '04:30 PM - 06:00 PM',
              bestWindow: '11:00 AM - 01:00 PM',
              recommendation: 'Review weekly progress and set new milestones.',
            );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    final days = _buildDays(lang);
    final selectedDay = days[_selectedIndex];

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final l10n = AppLocalizations.of(context, ref);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cosmicCalendarTitle,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getDynamicTextPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.cosmicCalendarSub,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.getDynamicTextSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 10),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'AI Generated 7-Day Outlook',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selectedDay.badgeColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedDay.badgeColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  selectedDay.energyLevel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selectedDay.badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Horizontal 7-day strip
          SizedBox(
            height: 76,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 58,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.goldGradient : null,
                      color: isSelected ? null : AppColors.getGlassSurface(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.getGlassBorder(context),
                        width: isSelected ? 1.5 : 0.6,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.dayName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.black : AppColors.getTextSecondary(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day.dayNumber,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.black : AppColors.getTextPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.black : day.badgeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Selected Day Event Details Card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(_selectedIndex),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getGlassSurface(context).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.getGlassBorder(context), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transit Highlight
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDay.transitHighlight,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nakshatra & Yoga Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailChip('Nakshatra', selectedDay.nakshatra, Icons.star_half_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDetailChip('Yoga', selectedDay.yoga, Icons.spa_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Timing Windows (Best Window & Rahu Kaal)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('✦ Best Window', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(
                                selectedDay.bestWindow,
                                style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('âš ï¸ Rahu Kaal', style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(
                                selectedDay.rahuKaal,
                                style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Recommendation text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.getSurfaceSecondary(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedDay.recommendation,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.getTextSecondary(context),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Scheduled Personal Events Section
                  Consumer(
                    builder: (context, ref, _) {
                      final reminderState = ref.watch(reminderProvider);
                      final dayReminders = reminderState.reminders.where((r) {
                        return r.eventTime.day == selectedDay.date.day &&
                               r.eventTime.month == selectedDay.date.month &&
                               r.eventTime.year == selectedDay.date.year;
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'SCHEDULED PERSONAL EVENTS',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.getPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => AddEventModal.show(context, initialDate: selectedDay.date),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.getPrimary(context).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.getPrimary(context).withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_rounded, size: 12, color: AppColors.getPrimary(context)),
                                      const SizedBox(width: 2),
                                      Text(
                                        'Add Event',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getPrimary(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (dayReminders.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'No personal events scheduled for this day. Tap "+ Add Event" to analyze timing.',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.getTextMuted(context),
                                ),
                              ),
                            )
                          else
                            ...dayReminders.map((r) {
                              final isEnabled = r.reminderEnabled;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.getSurfaceElevated(context),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.getGlassBorder(context), width: 0.5),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: r.category.color.withValues(alpha: 0.18),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(r.category.icon, size: 14, color: r.category.color),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  r.title,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.getTextPrimary(context),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.getPrimary(context).withValues(alpha: 0.15),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '★ ${r.astroScore}/10',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.getPrimary(context),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            r.astroRecommendation,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.getTextSecondary(context),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        isEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                                        size: 18,
                                        color: isEnabled ? AppColors.getPrimary(context) : AppColors.getTextMuted(context),
                                      ),
                                      onPressed: () {
                                        ref.read(reminderProvider.notifier).toggleReminder(r.id);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ).fadeSlideUp(delay: 50.ms),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceSecondary(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.getGlassBorder(context), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 9, color: AppColors.getTextMuted(context))),
                Text(
                  value,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

