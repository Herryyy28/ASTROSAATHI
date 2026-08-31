import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';

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
      dayNames = ['सोम', 'मंगल', 'बुध', 'गुरु', 'शुक्र', 'शनि', 'रवि'];
    } else if (lang == AppLanguage.gujarati) {
      dayNames = ['સોમ', 'મંગળ', 'બુધ', 'ગુરુ', 'શુક્ર', 'શનિ', 'રવિ'];
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
              energyLevel: 'संतुलित',
              badgeColor: AppColors.secondary,
              nakshatra: 'पुष्य नक्षत्र',
              yoga: 'सिद्ध योग',
              transitHighlight: 'चंद्रमा का कर्क राशि में प्रवेश • भावनात्मक स्पष्टता',
              rahuKaal: '07:30 AM - 09:00 AM',
              bestWindow: '10:15 AM - 12:30 PM',
              recommendation: 'टीम बैठकों और दीर्घकालिक योजनाओं के लिए आदर्श दिन।',
            );
          case 1:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'शुभ',
              badgeColor: AppColors.success,
              nakshatra: 'अश्लेषा नक्षत्र',
              yoga: 'अमृत सिद्धि योग',
              transitHighlight: 'बुध का 10वें भाव में संचरण • वाक् चातुर्य',
              rahuKaal: '03:00 PM - 04:30 PM',
              bestWindow: '09:00 AM - 11:15 AM',
              recommendation: 'अनुबंध पर हस्ताक्षर, क्लाइंट मीटिंग और बातचीत निष्पादित करें।',
            );
          case 2:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'सावधानी',
              badgeColor: AppColors.error,
              nakshatra: 'मघा नक्षत्र',
              yoga: 'व्यतीपात योग',
              transitHighlight: 'मंगल-राहु दृष्टि • उग्र ऊर्जा',
              rahuKaal: '12:00 PM - 01:30 PM',
              bestWindow: '04:00 PM - 05:30 PM',
              recommendation: 'बड़े वित्तीय निर्णयों या विवादों से बचें।',
            );
          case 3:
            return CosmicCalendarDay(
              date: date,
              dayName: 'आज',
              dayNumber: dayNum,
              energyLevel: 'उच्चतम ऊर्जा ✦',
              badgeColor: AppColors.primary,
              nakshatra: 'पूर्वा फाल्गुनी नक्षत्र',
              yoga: 'गजकेसरी योग सक्रिय',
              transitHighlight: 'गुरु-चंद्र दृष्टि • वित्तीय वृद्धि योग',
              rahuKaal: '01:30 PM - 03:00 PM',
              bestWindow: '08:45 AM - 11:30 AM',
              recommendation: 'नये कार्य प्रारंभ करें, संपत्ति खरीदें या पदोन्नति की बात करें।',
            );
          case 4:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'शुभ',
              badgeColor: AppColors.success,
              nakshatra: 'उत्तरा फाल्गुनी',
              yoga: 'शुभ योग',
              transitHighlight: 'शुक्र का 11वें भाव में युति • संबंधों में प्रगाढ़ता',
              rahuKaal: '10:30 AM - 12:00 PM',
              bestWindow: '02:00 PM - 04:30 PM',
              recommendation: 'पारिवारिक एवं सामाजिक कार्यों के लिए उत्तम समय।',
            );
          case 5:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'शांतिदायक',
              badgeColor: AppColors.secondary,
              nakshatra: 'हस्त नक्षत्र',
              yoga: 'ब्रह्म योग',
              transitHighlight: 'सूर्य-शनि दृष्टि • अनुशासन एवं प्रतिष्ठा',
              rahuKaal: '09:00 AM - 10:30 AM',
              bestWindow: '06:30 AM - 08:30 AM',
              recommendation: 'आध्यात्मिक साधना एवं ध्यान के लिए अत्यंत उपयुक्त।',
            );
          default:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'अनुकूल',
              badgeColor: AppColors.primary,
              nakshatra: 'चित्रा नक्षत्र',
              yoga: 'इन्द्र योग',
              transitHighlight: 'चंद्रमा का कन्या राशि में गोचर',
              rahuKaal: '04:30 PM - 06:00 PM',
              bestWindow: '11:00 AM - 01:00 PM',
              recommendation: 'सप्ताह के कार्यों की समीक्षा करें एवं नए लक्ष्य निर्धारित करें।',
            );
        }
      } else if (lang == AppLanguage.gujarati) {
        switch (index) {
          case 0:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'સંતુલિત',
              badgeColor: AppColors.secondary,
              nakshatra: 'પુષ્ય નક્ષત્ર',
              yoga: 'સિદ્ધ યોગ',
              transitHighlight: 'ચંદ્રમાનું કર્ક રાશિમાં પ્રવેશ • ભાવનાત્મક સ્પષ્ટતા',
              rahuKaal: '07:30 AM - 09:00 AM',
              bestWindow: '10:15 AM - 12:30 PM',
              recommendation: 'ટીમ મીટિંગ્સ અને લાંબા ગાળાના આયોજન માટે ઉત્તમ દિવસ.',
            );
          case 1:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'શુભ',
              badgeColor: AppColors.success,
              nakshatra: 'અશ્લેષા નક્ષત્ર',
              yoga: 'અમૃત સિદ્ધિ યોગ',
              transitHighlight: 'બુધનું 10મા સ્થાનમાં પરિભ્રમણ • વાણી લાભ',
              rahuKaal: '03:00 PM - 04:30 PM',
              bestWindow: '09:00 AM - 11:15 AM',
              recommendation: 'મહત્વના કરાર અને મીટિંગ્સ પૂર્ણ કરો.',
            );
          case 2:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'સાવધાની',
              badgeColor: AppColors.error,
              nakshatra: 'મઘા નક્ષત્ર',
              yoga: 'વ્યતીપાત યોગ',
              transitHighlight: 'મંગળ-રાહુ દ્રષ્ટિ • ઉગ્ર ઊર્જા',
              rahuKaal: '12:00 PM - 01:30 PM',
              bestWindow: '04:00 PM - 05:30 PM',
              recommendation: 'મોટા નાણાકીય નિર્ણયો અને દલીલો ટાળો.',
            );
          case 3:
            return CosmicCalendarDay(
              date: date,
              dayName: 'આજે',
              dayNumber: dayNum,
              energyLevel: 'ઉચ્ચતમ ઊર્જા ✦',
              badgeColor: AppColors.primary,
              nakshatra: 'પૂર્વા ફાલ્ગુની નક્ષત્ર',
              yoga: 'ગજકેસરી યોગ સક્રિય',
              transitHighlight: 'ગુરુ-ચંદ્ર યોગ • નાણાકીય વૃદ્ધિ',
              rahuKaal: '01:30 PM - 03:00 PM',
              bestWindow: '08:45 AM - 11:30 AM',
              recommendation: 'નવા કાર્યોનો પ્રારંભ કરો અથવા પ્રમોશન અંગે ચર્ચા કરો.',
            );
          case 4:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'શુભ',
              badgeColor: AppColors.success,
              nakshatra: 'ઉત્તરા ફાલ્ગુની',
              yoga: 'શુભ યોગ',
              transitHighlight: 'શુક્રની યુતિ • સંબંધોમાં મધુરતા',
              rahuKaal: '10:30 AM - 12:00 PM',
              bestWindow: '02:00 PM - 04:30 PM',
              recommendation: 'કૌટુંબિક અને સામાજિક પ્રસંગો માટે ઉત્તમ.',
            );
          case 5:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'શાંતિદાયક',
              badgeColor: AppColors.secondary,
              nakshatra: 'હસ્ત નક્ષત્ર',
              yoga: 'બ્રહ્મ યોગ',
              transitHighlight: 'સૂર્ય-શનિ દ્રષ્ટિ • અનુશાસન',
              rahuKaal: '09:00 AM - 10:30 AM',
              bestWindow: '06:30 AM - 08:30 AM',
              recommendation: 'આધ્યાત્મિક સાધના અને ધ્યાન માટે અનુકૂળ.',
            );
          default:
            return CosmicCalendarDay(
              date: date,
              dayName: dayName,
              dayNumber: dayNum,
              energyLevel: 'અનુકૂળ',
              badgeColor: AppColors.primary,
              nakshatra: 'ચિત્રા નક્ષત્ર',
              yoga: 'ઇન્દ્ર યોગ',
              transitHighlight: 'ચંદ્રમાનું કન્યા રાશિમાં ગોચર',
              rahuKaal: '04:30 PM - 06:00 PM',
              bestWindow: '11:00 AM - 01:00 PM',
              recommendation: 'અઠવાડિયાના કાર્યોની સમીક્ષા કરો અને નવા લક્ષ્યો નક્કી કરો.',
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.glassBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                            color: AppColors.textPrimaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.cosmicCalendarSub,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondaryDark,
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
                  color: selectedDay.badgeColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedDay.badgeColor.withOpacity(0.5)),
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
                      color: isSelected ? null : AppColors.glassSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.glassBorder,
                        width: isSelected ? 1.5 : 0.6,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
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
                            color: isSelected ? Colors.black : AppColors.textSecondaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day.dayNumber,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.black : AppColors.textPrimaryDark,
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
                color: AppColors.glassSurface.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.glassBorder, width: 0.5),
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
                            color: AppColors.success.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success.withOpacity(0.3)),
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
                            color: AppColors.error.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('⚠️ Rahu Kaal', style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold)),
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
                      color: AppColors.surfaceHighlightDark.withOpacity(0.5),
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
                              color: AppColors.textSecondaryDark,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
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
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textTertiaryDark)),
                Text(
                  value,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
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
