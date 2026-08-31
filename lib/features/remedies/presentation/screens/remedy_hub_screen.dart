import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../widgets/mantra_japa_counter_widget.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/providers/locale_provider.dart';

class RemedyHubScreen extends ConsumerStatefulWidget {
  const RemedyHubScreen({super.key});

  @override
  ConsumerState<RemedyHubScreen> createState() => _RemedyHubScreenState();
}

class _RemedyHubScreenState extends ConsumerState<RemedyHubScreen> {
  int _selectedPlanetIndex = 0;

  Map<String, Map<String, dynamic>> _getPlanetRemedies(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return {
        'गुरु (Jupiter)': {
          'gemstone': 'पीला पुखराज (Yellow Sapphire)',
          'emoji': '🟡',
          'wearing': 'तर्जनी अंगुली में पहनें • गुरुवार सुबह',
          'benefit': 'ज्ञान, उच्च शिक्षा, करियर वृद्धि और धन को मजबूत करता है।',
          'mantraTitle': 'गुरु (बृहस्पति) बीज मंत्र',
          'mantraText': 'ॐ ग्रां ग्रीं ग्रौं सः गुरवे नमः\n(गुरुवार को 108 जाप)',
          'rituals': [
            'गुरुवार को भगवान विष्णु को पीले फूल और चना दाल अर्पित करें',
            'सूर्योदय के समय विष्णु सहस्रनाम का पाठ करें',
            'छात्रों को पीली मिठाइयां या पुस्तकें दान करें',
          ],
        },
        'शनि (Saturn)': {
          'gemstone': 'नीलम (Blue Sapphire) / एमेथिस्ट',
          'emoji': '🔵',
          'wearing': 'मध्यमा अंगुली में पहनें • शनिवार शाम',
          'benefit': 'बाधाओं को दूर करता है, कर्म को संतुलित करता है, अनुशासन लाता है।',
          'mantraTitle': 'शनि बीज मंत्र एवं हनुमान चालीसा',
          'mantraText': 'ॐ शं शनैश्चराय नमः\n(शनिवार को 108 जाप)',
          'rituals': [
            'शनिवार शाम पीपल के पेड़ के नीचे सरसों के तेल का दीपक जलाएं',
            'प्रतिदिन हनुमान चालीसा का पाठ करें',
            'जरूरतमंदों को काले तिल, लोहा या जूते दान करें',
          ],
        },
        'मंगल (Mars)': {
          'gemstone': 'लाल मूंगा (Red Coral)',
          'emoji': '🔴',
          'wearing': 'अनामिका अंगुली में पहनें • मंगलवार सुबह',
          'benefit': 'साहस, ऊर्जा बढ़ाता है और मंगल दोष का निवारण करता है।',
          'mantraTitle': 'मंगल बीज मंत्र',
          'mantraText': 'ॐ क्रां क्रीं क्रौं सः भौमाय नमः\n(मंगलवार को 108 जाप)',
          'rituals': [
            'मंगलवार को हनुमान जी को लाल फूल और गुड़ अर्पित करें',
            'सुंदरकांड या हनुमान बाहुक का पाठ करें',
            'मसूर की दाल का दान या रक्तदान करें',
          ],
        },
        'शुक्र (Venus)': {
          'gemstone': 'हीरा (Diamond) / ओपल',
          'emoji': '⚪',
          'wearing': 'अनामिका या मध्यमा अंगुली में पहनें • शुक्रवार सुबह',
          'benefit': 'प्रेम, वैभव, कला और संबंधों में मधुरता बढ़ाता है।',
          'mantraTitle': 'शुक्र बीज मंत्र',
          'mantraText': 'ॐ द्रां द्रीं द्रौं सः शुक्राय नमः\n(शुक्रवार को 108 जाप)',
          'rituals': [
            'शुक्रवार को जरूरतमंद महिलाओं को सफेद मिठाई दान करें',
            'लक्ष्मी कृपा के लिए श्री सूक्त का पाठ करें',
            'चंदन की सुगंध का प्रयोग करें एवं स्वच्छता बनाए रखें',
          ],
        },
        'बुध (Mercury)': {
          'gemstone': 'पन्ना (Emerald)',
          'emoji': '🟢',
          'wearing': 'कनिष्ठिका अंगुली में पहनें • बुधवार सुबह',
          'benefit': 'बुद्धि, संचार कौशल और व्यावसायिक सफलता को तेज करता है।',
          'mantraTitle': 'बुध बीज मंत्र',
          'mantraText': 'ॐ ब्रां ब्रीं ब्रौं सः बुधाय नमः\n(बुधवार को 108 जाप)',
          'rituals': [
            'बुधवार को गायों को हरी घास या पालक खिलाएं',
            'भगवान गणेश को दुर्वा अर्पित कर प्रार्थना करें',
            'हरे वस्त्र या साबुत मूंह का दान करें',
          ],
        },
      };
    } else if (lang == AppLanguage.gujarati) {
      return {
        'ગુરુ (Jupiter)': {
          'gemstone': 'પીળો પોખરાજ (Yellow Sapphire)',
          'emoji': '🟡',
          'wearing': 'તર્જની આંગળીમાં પહેરો • ગુરુવાર સવારે',
          'benefit': 'જ્ઞાન, ઉચ્ચ શિક્ષણ, કરિયર પ્રગતિ અને સંપત્તિ વધારે છે.',
          'mantraTitle': 'ગુરુ બીજ મંત્ર',
          'mantraText': 'ૐ ગ્રાં ગ્રીં ગ્રૌં સઃ ગુરવે નમઃ\n(ગુરુવારે 108 જાપ)',
          'rituals': [
            'ગુરુવારે ભગવાન વિષ્ણુને પીળા ફૂલ અને ચણાની દાળ અર્પિત કરો',
            'સૂર્યોદય સમયે વિષ્ણુ સહસ્રનામનો પાઠ કરો',
            'વિદ્યાર્થીઓને પીળી મીઠાઈ અથવા પુસ્તકો દાન કરો',
          ],
        },
        'શનિ (Saturn)': {
          'gemstone': 'નીલમ (Blue Sapphire) / એમેથિસ્ટ',
          'emoji': '🔵',
          'wearing': 'મધ્યમા આંગળીમાં પહેરો • શનિવાર સાંજે',
          'benefit': 'અડચણો દૂર કરે છે, કર્મને સંતુલિત કરે છે અને સ્થિરતા લાવે છે.',
          'mantraTitle': 'શનિ બીજ મંત્ર અને હનુમાન ચાલીસા',
          'mantraText': 'ૐ શં શનૈશ્ચરાય નમઃ\n(શનિવારે 108 જાપ)',
          'rituals': [
            'શનિવારે સાંજે પીપળાના વૃક્ષ નીચે સરસવના તેલનો દીવો કરો',
            'દરરોજ હનુમાન ચાલીસાનો પાઠ કરો',
            'જરૂરિયાતમંદોને કાળા તલ અથવા પગરખાં દાન કરો',
          ],
        },
        'મંગળ (Mars)': {
          'gemstone': 'રાતું પરવાળું (Red Coral)',
          'emoji': '🔴',
          'wearing': 'અનામિકા આંગળીમાં પહેરો • મંગળવાર સવારે',
          'benefit': 'હિંમત, ઊર્જા અને જમીન-સંપત્તિમાં લાભ અપાવે છે.',
          'mantraTitle': 'મંગળ બીજ મંત્ર',
          'mantraText': 'ૐ ક્રાં ક્રીં ક્રૌં સઃ ભૌમાય નમઃ\n(મંગળવારે 108 જાપ)',
          'rituals': [
            'મંગળવારે હનુમાનજીને લાલ ફૂલ અને ગોળ અર્પિત કરો',
            'સુંદરકાંડનો પાઠ કરો',
            'લાલ મસૂરની દાળ દાન કરો',
          ],
        },
        'શુક્ર (Venus)': {
          'gemstone': 'હીરો (Diamond) / ઓપલ',
          'emoji': '⚪',
          'wearing': 'અનામિકા આંગળીમાં પહેરો • શુક્રવાર સવારે',
          'benefit': 'પ્રેમ, વૈભવ અને સંબંધોમાં મધુરતા વધારે છે.',
          'mantraTitle': 'શુક્ર બીજ મંત્ર',
          'mantraText': 'ૐ દ્રાં દ્રીં દ્રૌં સઃ શુક્રાય નમઃ\n(શુક્રવારે 108 જાપ)',
          'rituals': [
            'શુક્રવારે જરૂરિયાતમંદ મહિલાઓને સફેદ મીઠાઈ દાન કરો',
            'શ્રી સૂક્તનો પાઠ કરો',
            'ચંદનની સુગંધનો ઉપયોગ કરો',
          ],
        },
        'બુધ (Mercury)': {
          'gemstone': 'પન્ના (Emerald)',
          'emoji': '🟢',
          'wearing': 'ટચલી આંગળીમાં પહેરો • બુધવાર સવારે',
          'benefit': 'બુદ્ધિ, વાણી કૌશલ્ય અને વ્યવસાયમાં સફળતા અપાવે છે.',
          'mantraTitle': 'બુધ બીજ મંત્ર',
          'mantraText': 'ૐ બ્રાં બ્રીં બ્રૌં સઃ બુધાય નમઃ\n(બુધવારે 108 જાપ)',
          'rituals': [
            'બુધવારે ગાયને લીલું ઘાસ ખવડાવો',
            'ગણેશજીને દૂર્વા અર્પિત કરો',
            'લીલા કપડાં અથવા મગ દાન કરો',
          ],
        },
      };
    } else {
      return {
        'Jupiter (Guru)': {
          'gemstone': 'Yellow Sapphire (Pukhraj)',
          'emoji': '🟡',
          'wearing': 'Wear on Index Finger • Thursday Morning',
          'benefit': 'Strengthens wisdom, higher learning, career growth, and wealth.',
          'mantraTitle': 'Guru (Jupiter) Beej Mantra',
          'mantraText': 'Om Gram Greem Grom Sah Gurave Namah\n(108 Chants on Thursday)',
          'rituals': [
            'Offer yellow flowers and chana dal to Lord Vishnu on Thursdays',
            'Chant Vishnu Sahasranama at sunrise',
            'Donate yellow sweets or books to students',
          ],
        },
        'Saturn (Shani)': {
          'gemstone': 'Blue Sapphire (Neelam) / Amethyst',
          'emoji': '🔵',
          'wearing': 'Wear on Middle Finger • Saturday Evening',
          'benefit': 'Removes obstacles, balances Karma, brings discipline and stability.',
          'mantraTitle': 'Shani Beej Mantra & Hanuman Chalisa',
          'mantraText': 'Om Sham Shanaiscarya Namah\n(108 Chants on Saturday)',
          'rituals': [
            'Light a mustard oil lamp under a Peepal tree on Saturday evening',
            'Chant Hanuman Chalisa daily',
            'Donate black sesame seeds, iron, or shoes to the needy',
          ],
        },
        'Mars (Mangal)': {
          'gemstone': 'Red Coral (Moonga)',
          'emoji': '🔴',
          'wearing': 'Wear on Ring Finger • Tuesday Morning',
          'benefit': 'Boosts courage, energy, property gains, and resolves Mangal Dosh.',
          'mantraTitle': 'Mangal Beej Mantra',
          'mantraText': 'Om Kram Kreem Krom Sah Bhaumaya Namah\n(108 Chants on Tuesday)',
          'rituals': [
            'Offer red flowers and jaggery to Lord Hanuman on Tuesdays',
            'Recite Sundarkand or Hanuman Bahuk',
            'Donate red lentils (Masoor Dal) or blood donation',
          ],
        },
        'Venus (Shukra)': {
          'gemstone': 'Diamond / Opal',
          'emoji': '⚪',
          'wearing': 'Wear on Middle or Ring Finger • Friday Morning',
          'benefit': 'Enhances love, luxury, arts, relationship harmony, and magnetic charm.',
          'mantraTitle': 'Shukra Beej Mantra',
          'mantraText': 'Om Dram Dreem Drom Sah Shukraya Namah\n(108 Chants on Friday)',
          'rituals': [
            'Offer white sweets, rice, or ghee to needy women on Fridays',
            'Chant Shri Suktam for Lakshmi grace',
            'Use sandalwood fragrance and maintain cleanliness',
          ],
        },
        'Mercury (Budh)': {
          'gemstone': 'Emerald (Panna)',
          'emoji': '🟢',
          'wearing': 'Wear on Little Finger • Wednesday Morning',
          'benefit': 'Sharpens intelligence, communication, business success, and analytical skills.',
          'mantraTitle': 'Budh Beej Mantra',
          'mantraText': 'Om Bram Breem Brom Sah Budhaya Namah\n(108 Chants on Wednesday)',
          'rituals': [
            'Feed green grass or spinaches to cows on Wednesdays',
            'Pray to Lord Ganesha offering Durva grass',
            'Donate green clothes or green moong dal',
          ],
        },
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    final planetRemedies = _getPlanetRemedies(lang);
    final planetKeys = planetRemedies.keys.toList();
    if (_selectedPlanetIndex >= planetKeys.length) _selectedPlanetIndex = 0;
    final selectedPlanet = planetKeys[_selectedPlanetIndex];
    final remedy = planetRemedies[selectedPlanet]!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CosmicParticleBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back Arrow
                Row(
                  children: [
                    if (Navigator.canPop(context))
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.purpleGradient,
                      ),
                      child: const Icon(Icons.auto_fix_high_rounded, color: Colors.white, size: 20),
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
                                l10n.remediesTitle,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimaryDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                l10n.remediesSub,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Planet Selector Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: planetKeys.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final planetName = entry.value;
                      final isSelected = idx == _selectedPlanetIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(planetName),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceDark,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : AppColors.textPrimaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedPlanetIndex = idx);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Recommended Gemstone Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 16),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.2),
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: Center(
                          child: Text(remedy['emoji'] as String, style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              remedy['gemstone'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              remedy['benefit'] as String,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark, height: 1.3),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              remedy['wearing'] as String,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Interactive Japa Counter with selected Mantra
                MantraJapaCounterWidget(
                  mantraTitle: remedy['mantraTitle'] as String,
                  mantraText: remedy['mantraText'] as String,
                ).animate().fade(delay: 150.ms).slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Daily Karma Ritual Checklist
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlightDark.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authentic Upay for $selectedPlanet',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                      ),
                      const SizedBox(height: 12),
                      ...(remedy['rituals'] as List<String>).map((r) => _buildRitualTile(r)),
                    ],
                  ),
                ).animate().fade(delay: 300.ms).slideY(begin: 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRitualTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
