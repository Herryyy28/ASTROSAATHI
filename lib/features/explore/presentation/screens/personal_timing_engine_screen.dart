import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

  List<Map<String, dynamic>> _getDateComparisons(String activity) {
    final now = DateTime.now();
    final f = DateFormat('d MMM yyyy');

    switch (activity) {
      case 'Business Registration':
        return [
          {
            'date': f.format(now.add(const Duration(days: 3))),
            'rating': 'Strongest',
            'score': 96,
            'window': '10:45 AM - 01:15 PM (Sarvartha Siddhi Yoga)',
            'support': 'Jupiter in 11th House (Labha) fosters financial liquidity and rapid partnership growth.',
            'notice': 'Zero malefic Rahu Kaal overlap during registration window.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 7))),
            'rating': 'Strong',
            'score': 89,
            'window': '09:15 AM - 11:30 AM (Shubh Choghadiya)',
            'support': 'Mercury conjunct Sun elevates commercial acumen and public brand trust.',
            'notice': 'Ensure company paperwork is reviewed before afternoon Rahu transit.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 11))),
            'rating': 'Moderate',
            'score': 74,
            'window': '02:30 PM - 04:45 PM',
            'support': 'Steady Venusian grace supports aesthetic and service ventures.',
            'notice': 'Saturn aspect demands thorough legal verification.',
            'color': const Color(0xFFB87308),
          },
        ];

      case 'Travel & Relocation':
        return [
          {
            'date': f.format(now.add(const Duration(days: 2))),
            'rating': 'Strongest',
            'score': 95,
            'window': '06:30 AM - 08:45 AM (Amrit Muhurat)',
            'support': 'Auspicious Moon transit in Char (Movable) Nakshatra ensures seamless journey and safety.',
            'notice': 'Clear directional path with zero Dishashool interference.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 6))),
            'rating': 'Strong',
            'score': 85,
            'window': '11:30 AM - 01:45 PM (Abhijit Window)',
            'support': 'Favorable planetary wind supports smooth customs, bookings, and luggage transit.',
            'notice': 'Begin travel before 04:30 PM to avoid evening planetary tension.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 9))),
            'rating': 'Caution',
            'score': 68,
            'window': '03:15 PM - 05:00 PM',
            'support': 'Destination arrival aligned with supportive Venus hour.',
            'notice': 'Rahu transit overlap; chant travel safety mantra before departure.',
            'color': const Color(0xFFB87308),
          },
        ];

      case 'Important Meeting / Contract':
        return [
          {
            'date': f.format(now.add(const Duration(days: 1))),
            'rating': 'Strongest',
            'score': 97,
            'window': '11:15 AM - 01:20 PM (Abhijit Muhurat)',
            'support': 'High Mercurial resonance for persuasive communication, terms agreement, and signature.',
            'notice': 'Optimal planetary alignment for mutual commercial benefit.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 5))),
            'rating': 'Strong',
            'score': 88,
            'window': '02:00 PM - 04:15 PM (Labha Choghadiya)',
            'support': 'Sun in 10th House bolsters leadership presence and authority.',
            'notice': 'Keep negotiations calm and data-driven.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 10))),
            'rating': 'Moderate',
            'score': 76,
            'window': '10:00 AM - 12:15 PM',
            'support': 'Harmonious Venus aspect aids diplomatic compromise.',
            'notice': 'Avoid rushed commitments during final hour.',
            'color': const Color(0xFFB87308),
          },
        ];

      case 'Property & Asset Purchase':
        return [
          {
            'date': f.format(now.add(const Duration(days: 4))),
            'rating': 'Strongest',
            'score': 98,
            'window': '09:00 AM - 11:30 AM (Pushya Nakshatra Yoga)',
            'support': '4th House (Sukha & Land) energized by Jupiter; ideal for deed signing and registry.',
            'notice': 'Promotes long-term capital preservation and family tranquility.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 8))),
            'rating': 'Strong',
            'score': 91,
            'window': '11:45 AM - 01:50 PM (Amrit Siddhi Muhurat)',
            'support': 'Fixed sign Taurus/Scorpio ascendant brings permanence and physical stability.',
            'notice': 'Conduct physical inspection during morning sunlight.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 14))),
            'rating': 'Moderate',
            'score': 75,
            'window': '01:30 PM - 03:45 PM',
            'support': 'Mars alignment energizes land value appreciation.',
            'notice': 'Verify land titles and encumbrance certificates thoroughly.',
            'color': const Color(0xFFB87308),
          },
        ];

      case 'Interview & Job Launch':
      default:
        return [
          {
            'date': f.format(now.add(const Duration(days: 2))),
            'rating': 'Strongest',
            'score': 95,
            'window': '10:15 AM - 12:30 PM (Abhijit Muhurat)',
            'support': 'Sun in 10th House supported by Moon-Jupiter Trine.',
            'notice': 'Zero malefic Rahu Kaal overlap during window.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 5))),
            'rating': 'Strong',
            'score': 86,
            'window': '02:00 PM - 04:15 PM',
            'support': 'Mercury alignment favors confidence in negotiation and technical Q&A.',
            'notice': 'Maintain poised posture; recite Budh mantra before entry.',
            'color': const Color(0xFF00796B),
          },
          {
            'date': f.format(now.add(const Duration(days: 8))),
            'rating': 'Moderate',
            'score': 72,
            'window': '11:00 AM - 01:15 PM',
            'support': 'Jupiter aspect supports executive presentation.',
            'notice': 'Minor Saturn aspect requires careful documentation.',
            'color': const Color(0xFFB87308),
          },
        ];
    }
  }

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
            ..._getDateComparisons(_selectedActivity).map((item) {
              final Color col = isLight ? (item['color'] as Color) : (item['rating'] == 'Moderate' ? const Color(0xFFFFD700) : const Color(0xFF00E5FF));
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: col.withValues(alpha: 0.4), width: 1.2),
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
                            color: col.withValues(alpha: 0.15),
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
                    _buildRow('â° Favorable Window:', item['window'], context),
                    const SizedBox(height: 6),
                    _buildRow('ðŸª Planetary Support:', item['support'], context),
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

