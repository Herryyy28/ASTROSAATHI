import 'dart:ui';
import 'package:AstroSaathi/core/theme/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../explore/presentation/screens/astro_decision_assistant_screen.dart';

class CosmicEventItem {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String timeStr;
  final String location;
  final int score;
  final String dashaContext;
  final String aiExplanation;
  final bool isReminderEnabled;
  final String status;

  CosmicEventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.timeStr,
    required this.location,
    required this.score,
    required this.dashaContext,
    required this.aiExplanation,
    this.isReminderEnabled = true,
    this.status = 'Upcoming',
  });
}

class MyEventsScreen extends ConsumerStatefulWidget {
  const MyEventsScreen({super.key});

  @override
  ConsumerState<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends ConsumerState<MyEventsScreen> {
  final List<CosmicEventItem> _events = [
    CosmicEventItem(
      id: 'evt-1',
      title: 'Google Final Interview',
      category: 'Interview',
      date: DateTime.now().add(const Duration(days: 1)),
      timeStr: '11:00 AM',
      location: 'Bangalore, KA',
      score: 88,
      dashaContext: 'Jupiter-Mercury • Abhijit Muhurat',
      aiExplanation: 'Mercury alignment boosts communication skills & clarity.',
      status: 'Upcoming',
    ),
    CosmicEventItem(
      id: 'evt-2',
      title: 'Property Deed Registration',
      category: 'Property Purchase',
      date: DateTime.now().add(const Duration(days: 4)),
      timeStr: '02:30 PM',
      location: 'New Delhi',
      score: 94,
      dashaContext: 'Mars-Jupiter • Pushya Nakshatra',
      aiExplanation:
          'Pushya Nakshatra brings lifelong stability & wealth growth.',
      status: 'Upcoming',
    ),
    CosmicEventItem(
      id: 'evt-3',
      title: 'Flight to Singapore',
      category: 'Travel',
      date: DateTime.now().subtract(const Duration(days: 2)),
      timeStr: '08:15 AM',
      location: 'IGI Airport Delhi',
      score: 76,
      dashaContext: 'Moon Transit 9th House',
      aiExplanation: '9th house transit favors safe long-distance journeys.',
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.getSurface(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Events & Astrological Schedule',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: Color(0xFFFFD700),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AstroDecisionAssistantScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          child: ListView.builder(
            padding: const EdgeInsets.all(18),
            physics: const BouncingScrollPhysics(),
            itemCount: _events.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildTopAddEventBanner().fadeSlideUp();
              }
              final item = _events[index - 1];
              return _buildEventCard(item, index - 1).fadeSlideUp();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopAddEventBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        borderRadius: AppRadius.xl2,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFFFFD700),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan New Cosmic Event',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  Text(
                    'Evaluate interview, exam, travel or property purchase.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF1B1403),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AstroDecisionAssistantScreen(),
                  ),
                );
              },
              child: Text(
                '+ Event',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(CosmicEventItem item, int index) {
    final isUpcoming = item.status == 'Upcoming';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        borderRadius: AppRadius.xl2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        item.category,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isUpcoming
                            ? Colors.green.withOpacity(0.15)
                            : Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.status,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isUpcoming ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '★ ${item.score}/100',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFD700),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              item.title,
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.getTextSecondary(context),
                ),
                const SizedBox(width: 6),
                Text(
                  '${DateFormat('E, MMM d, yyyy').format(item.date)} at ${item.timeStr}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.getTextSecondary(context),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.location,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.getTextSecondary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: Colors.white10),

            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: Color(0xFFFFD700),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.dashaContext,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              item.aiExplanation,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.getTextSecondary(context),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  icon: Icon(
                    item.isReminderEnabled
                        ? Icons.notifications_active_rounded
                        : Icons.notifications_off_outlined,
                    size: 16,
                    color: item.isReminderEnabled
                        ? const Color(0xFFFFD700)
                        : Colors.grey,
                  ),
                  label: Text(
                    item.isReminderEnabled ? 'Reminder Set' : 'Enable Reminder',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: item.isReminderEnabled
                          ? const Color(0xFFFFD700)
                          : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    CosmicNotification.show(
                      context,
                      title: 'Reminder Updated 🔔',
                      message:
                          'Celestial timing notification set for ${item.title}.',
                      icon: Icons.notifications_active_rounded,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      _events.removeAt(index);
                    });
                    CosmicNotification.show(
                      context,
                      title: 'Event Removed 🗑️',
                      message: '${item.title} has been deleted.',
                      icon: Icons.delete_forever_rounded,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
