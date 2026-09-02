import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/locale_provider.dart';

class CosmicInboxScreen extends ConsumerWidget {
  const CosmicInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);

    String title;
    String subTitle;
    List<Map<String, String>> alerts;

    if (lang == AppLanguage.hindi) {
      title = 'कॉस्मिक अलर्ट इनबॉक्स';
      subTitle = 'ग्रह अंतर्दृष्टि और समय की वास्तविक सूचनाएं';
      alerts = [
        {'title': '🔮 दैनिक कॉस्मिक गेम प्लान तैयार है', 'desc': 'ऊर्जा स्कोर 8.7/10 — गुरु का आज 10वें कर्म भाव में शुभ प्रभाव।', 'time': '07:00 AM'},
        {'title': '⏰ राहु काल अलर्ट', 'desc': 'राहु काल 20 मिनट में शुरू हो रहा है (1:30 PM - 3:00 PM)। नए सौदों पर हस्ताक्षर करने से बचें।', 'time': '01:10 PM'},
        {'title': '💼 सर्वश्रेष्ठ करियर मुहूर्त निकट है', 'desc': 'अभिजीत मुहूर्त 11:15 AM पर शुरू होगा — महत्वपूर्ण बैठकों के लिए उत्तम।', 'time': '10:45 AM'},
        {'title': '📿 मंत्र काउंटर अनुस्मारक', 'desc': 'आपका महामृत्युंजय जाप लक्ष्य 108 में से 54 मनके पूर्ण हो चुके हैं।', 'time': 'कल'},
      ];
    } else if (lang == AppLanguage.gujarati) {
      title = 'કોસ્મિક એલર્ટ ઇનબૉક્સ';
      subTitle = 'ગ્રહ દ્રષ્ટિ અને સમયની વાસ્તવિક સૂચનાઓ';
      alerts = [
        {'title': '🔮 દૈનિક કોસ્મિક ગેમ પ્લાન તૈયાર છે', 'desc': 'ઊર્જા સ્કોર 8.7/10 — ગુરુનું આજે 10મા સ્થાને શુભ ભ્રમણ.', 'time': '07:00 AM'},
        {'title': '⏰ રાહુ કાળ એલર્ટ', 'desc': 'રાહુ કાળ 20 મિનિટમાં શરૂ થઈ રહ્યો છે (1:30 PM - 3:00 PM). નવા સોદા ટાળો.', 'time': '01:10 PM'},
        {'title': '💼 શ્રેષ્ઠ કરિયર સમય નજીક છે', 'desc': 'અભિજીત મુહૂર્ત 11:15 AM થી શરૂ થશે — મહત્વની મીટિંગ્સ માટે ઉત્તમ.', 'time': '10:45 AM'},
        {'title': '📿 મંત્ર કાઉન્ટર યાદ અપાવનાર', 'desc': 'તમારો મહામૃત્યુંજય જાપ લક્ષ્ય 108 માંથી 54 પૂર્ણ થયા છે.', 'time': 'ગઈકાલે'},
      ];
    } else {
      title = 'Cosmic Alert Inbox';
      subTitle = 'In-App Planetary Insights & Timing Notifications';
      alerts = [
        {'title': '🔮 Daily Cosmic Game Plan Ready', 'desc': 'Energy score 8.7/10 — Jupiter aspecting 10th Karma House today.', 'time': '07:00 AM'},
        {'title': '⏰ Rahu Kaal Alert', 'desc': 'Rahu Kaal starting in 20 minutes (1:30 PM - 3:00 PM). Avoid signing deals.', 'time': '01:10 PM'},
        {'title': '💼 Best Career Window Approaching', 'desc': 'Abhijit Muhurat starts at 11:15 AM — optimal for executive calls.', 'time': '10:45 AM'},
        {'title': '📿 Mantra Counter Reminder', 'desc': 'Your Mahamrityunjaya Japa goal is 54 beads completed out of 108.', 'time': 'Yesterday'},
      ];
    }

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      body: CosmicParticleBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.purpleGradient,
                      ),
                      child: const Icon(Icons.inbox_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                          ),
                          Text(
                            subTitle,
                            style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ...alerts.map((a) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.getGlassBorder(context)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                a['title']!,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            Text(
                              a['time']!,
                              style: TextStyle(fontSize: 11, color: AppColors.getTextMuted(context)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          a['desc']!,
                          style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context), height: 1.3),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
