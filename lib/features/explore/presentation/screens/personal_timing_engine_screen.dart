import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class PersonalTimingEngineScreen extends StatefulWidget {
  const PersonalTimingEngineScreen({super.key});

  @override
  State<PersonalTimingEngineScreen> createState() => _PersonalTimingEngineScreenState();
}

class _PersonalTimingEngineScreenState extends State<PersonalTimingEngineScreen> {
  String _selectedActivity = 'Interview & Job Launch';

  final List<String> _activities = [
    'Interview & Job Launch',
    'Business Registration',
    'Travel & Relocation',
    'Important Meeting / Contract',
    'Property & Asset Purchase',
  ];

  final List<Map<String, dynamic>> _dateComparisons = [
    {
      'date': '10 Sep 2026',
      'rating': 'Strong',
      'score': 94,
      'window': '10:15 AM - 12:30 PM (Abhijit Muhurat)',
      'support': 'Sun in 10th House supported by Moon-Jupiter Trine.',
      'notice': 'Zero malefic Rahu Kaal overlap during window.',
      'color': const Color(0xFF00796B),
    },
    {
      'date': '12 Sep 2026',
      'rating': 'Moderate',
      'score': 72,
      'window': '02:00 PM - 04:15 PM',
      'support': 'Mercury alignment favors negotiation.',
      'notice': 'Minor Saturn aspect requires careful documentation.',
      'color': const Color(0xFFB87308),
    },
    {
      'date': '15 Sep 2026',
      'rating': 'Strongest',
      'score': 98,
      'window': '09:30 AM - 11:45 AM (Amrit Siddhi Yoga)',
      'support': 'Peak Pushya Nakshatra alignment fostering long-term wealth.',
      'notice': 'Highest success probability window in September.',
      'color': const Color(0xFF00796B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = AppColors.isLight(context);
    final primaryTextColor = AppColors.getTextPrimary(context);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        title: Text(
          'Personal Timing Engine',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Dropdown Selector Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceElevated(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.getBorder(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Event / Activity:',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedActivity,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.getSurface(context),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.getBorder(context)),
                      ),
                    ),
                    items: _activities.map((act) {
                      return DropdownMenuItem(
                        value: act,
                        child: Text(
                          act,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedActivity = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date Comparison Section Header
            Text(
              '✦ Date Comparison Scorecard',
              style: GoogleFonts.outfit(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Date Comparison Cards
            ..._dateComparisons.map((item) {
              final Color col = isLight ? (item['color'] as Color) : (item['rating'] == 'Moderate' ? const Color(0xFFFFD700) : const Color(0xFF00E5FF));
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: col.withOpacity(0.4), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['date'],
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: col.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${item['rating']} (${item['score']}/100)',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: col,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.getDivider(context), height: 20),
                    _buildRow('⏰ Favorable Window:', item['window'], context),
                    const SizedBox(height: 6),
                    _buildRow('🪐 Planetary Support:', item['support'], context),
                    const SizedBox(height: 6),
                    _buildRow('💡 Key Notice:', item['notice'], context),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String val, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextMuted(context),
            ),
          ),
        ),
        Expanded(
          child: Text(
            val,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextPrimary(context),
            ),
          ),
        ),
      ],
    );
  }
}
