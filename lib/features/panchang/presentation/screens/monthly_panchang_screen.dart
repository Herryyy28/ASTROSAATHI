import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/nine_languages_modal.dart';

class MonthlyPanchangScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const MonthlyPanchangScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<MonthlyPanchangScreen> createState() => _MonthlyPanchangScreenState();
}

class _MonthlyPanchangScreenState extends ConsumerState<MonthlyPanchangScreen> {
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _festivals = [
    {
      'day': '02',
      'weekday': 'TUE',
      'title': 'Sankashti Chaturthi',
      'desc': 'Fasting for Lord Ganesha • Moonrise: 09:42 PM',
      'isMajor': true,
    },
    {
      'day': '05',
      'weekday': 'FRI',
      'title': 'Masik Shivratri & Shravan Somwar Prep',
      'desc': 'Nishita Kaal Puja • Auspicious Abhijit Muhurat: 12:05 PM - 12:54 PM',
      'isMajor': false,
    },
    {
      'day': '08',
      'weekday': 'MON',
      'title': 'Somvati Amavasya (Darsha Amavasya)',
      'desc': 'Holy dip in sacred rivers & Pitru Tarpan • Rahu Kaal: 07:30 AM - 09:00 AM',
      'isMajor': true,
    },
    {
      'day': '15',
      'weekday': 'MON',
      'title': 'Shukla Paksha Ekadashi (Kamada / Padmini)',
      'desc': 'Lord Vishnu Puja • Parana time next day morning 06:12 AM',
      'isMajor': true,
    },
    {
      'day': '19',
      'weekday': 'FRI',
      'title': 'Pradosh Vrat (Shukla Paksha)',
      'desc': 'Lord Shiva Sandhya Sandhi Kaal Worship • 06:45 PM - 08:15 PM',
      'isMajor': false,
    },
    {
      'day': '23',
      'weekday': 'TUE',
      'title': 'Purnima Vrat & Satyanarayan Puja',
      'desc': 'Full Moon Satyanarayan Katha & Arghya to Chandra Dev',
      'isMajor': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final activeProfile = ref.watch(activeProfileProvider);
    final cityName = activeProfile.birthPlace.isNotEmpty
        ? activeProfile.birthPlace
        : 'New Delhi, India';

    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayWeekday = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday % 7; // Sunday = 0

    final bodyContent = Column(
      children: [
        if (!widget.isEmbedded) _buildAppBar(context),

            // ── Selected Day & Paksha Info Banner ─────────────────
            _buildVedicInfoBanner(cityName),

            // ── Monthly Calendar View ────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Calendar Grid Container
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLight ? const Color(0xFFE0E0E0) : AppColors.borderDark,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isLight ? 0.05 : 0.20),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Weekdays Header (SUN, MON, TUE, WED, THU, FRI, SAT)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isLight ? const Color(0xFFFFF8E1) : const Color(0xFF2C2237),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Row(
                              children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'].map((d) {
                                final isSun = d == 'SUN';
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: isSun ? const Color(0xFFD32F2F) : AppColors.getTextPrimary(context),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // Calendar Grid Days
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(6),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 0.95,
                            ),
                            itemCount: 35, // 5 weeks display
                            itemBuilder: (context, index) {
                              final dayNumber = index - firstDayWeekday + 1;
                              final isValidDay = dayNumber > 0 && dayNumber <= daysInMonth;

                              if (!isValidDay) {
                                return const SizedBox.shrink();
                              }

                              final isSelected = dayNumber == _selectedDate.day;
                              final isSunday = index % 7 == 0;
                              final isPurnima = dayNumber == 23;
                              final isAmavasya = dayNumber == 8;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayNumber);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFF5A623) // Selected Day Gold
                                        : (isSunday ? const Color(0xFFFFF3E0).withValues(alpha: 0.5) : Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                    border: isSelected
                                        ? Border.all(color: Colors.black87, width: 1.2)
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$dayNumber',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected
                                              ? Colors.black87
                                              : (isSunday ? const Color(0xFFD32F2F) : AppColors.getTextPrimary(context)),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      // Moon Phase Indicator
                                      if (isPurnima)
                                        const Icon(Icons.brightness_1_rounded, size: 12, color: Color(0xFFFFD54F))
                                      else if (isAmavasya)
                                        const Icon(Icons.circle, size: 12, color: Colors.black87)
                                      else
                                        Icon(
                                          Icons.nightlight_round,
                                          size: 11,
                                          color: isSelected ? Colors.black54 : Colors.grey.shade400,
                                        ),
                                      Text(
                                        '${(dayNumber % 15) + 1}',
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.black87 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // ── Hindu Calendar Festivals Section (Image 2) ─────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                      child: Text(
                        'Hindu Calendar Festivals & Vrats',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 32),
                      itemCount: _festivals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final fest = _festivals[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isLight ? Colors.white : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isLight ? const Color(0xFFEEEEEE) : AppColors.borderDark,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Date Badge (e.g. 02 TUE in bright orange)
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6D00),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      fest['day'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      fest['weekday'],
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Festival Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fest['title'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.getTextPrimary(context),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      fest['desc'],
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        color: AppColors.getTextSecondary(context),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

    if (widget.isEmbedded) {
      return Container(
        color: isLight ? const Color(0xFFF9F9F9) : AppColors.backgroundDark,
        child: bodyContent,
      );
    }

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF9F9F9) : AppColors.backgroundDark,
      body: SafeArea(
        child: bodyContent,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF5A623), // AstroSage Golden Yellow
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: () => NineLanguagesModal.show(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Monthly Calendar',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.black87),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on_outlined, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Panchang coordinates set to New Delhi (28°36\'N, 77°12\'E)')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVedicInfoBanner(String cityName) {
    final formattedDate = DateFormat('d MMMM, yyyy (EEEE)').format(_selectedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B132B), Color(0xFF2E1C44)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Moon Graphic
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFFFF9C4), Color(0xFFF57F17)],
              ),
            ),
            child: const Icon(Icons.nightlight_round, color: Color(0xFF4A148C), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phalguna (Purnimant) • Magha (Amanta)',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFD54F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Krishna Paksha • Saptami Tithi',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$formattedDate • $cityName',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
