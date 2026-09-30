import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../kundli/presentation/screens/kundli_screen.dart';
import '../../../matching/presentation/screens/matching_screen.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../reports/presentation/screens/custom_pdf_report_builder_screen.dart';
import '../../../explore/presentation/screens/personal_timing_engine_screen.dart';
import '../../../explore/presentation/screens/future_radar_screen.dart';
import '../../../reminders/presentation/screens/astro_reminders_screen.dart';

class AstrologySearchScreen extends StatefulWidget {
  const AstrologySearchScreen({super.key});

  @override
  State<AstrologySearchScreen> createState() => _AstrologySearchScreenState();
}

class _AstrologySearchScreenState extends State<AstrologySearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Features',
    'Planet',
    'Rashi',
    'Bhava',
    'Nakshatra',
    'Yoga',
    'Dasha',
    'Muhurat',
  ];

  final List<Map<String, String>> _knowledgeBase = [
    // ── App Features (Direct Navigation) ─────────────────────
    {
      'term': 'Kundli Birth Chart',
      'category': 'Features',
      'description': 'View interactive North & South Indian natal charts, house meanings, planetary strengths & dignities.',
      'action': 'Open Kundli',
      'screen': 'kundli',
    },
    {
      'term': 'Gun Milan & Compatibility',
      'category': 'Features',
      'description': '36-Guna Ashtakoota compatibility analysis and relationship synastry for prospective matches.',
      'action': 'Open Matching',
      'screen': 'matching',
    },
    {
      'term': 'Astro Baba AI Guide',
      'category': 'Features',
      'description': 'Ask conversational Vedic astrology queries regarding career, love, health, Dasha timing & remedies.',
      'action': 'Ask Astro Baba',
      'screen': 'astrobaba',
    },
    {
      'term': 'Custom PDF Report Generator',
      'category': 'Features',
      'description': 'Build & export multi-language personalized Vedic birth chart reports in PDF format with custom sections.',
      'action': 'Build PDF',
      'screen': 'pdf',
    },
    {
      'term': 'Personal Timing & Muhurat Engine',
      'category': 'Features',
      'description': 'Calculate auspicious time windows for contracts, interviews, travel, property, and ceremonies.',
      'action': 'View Timing Engine',
      'screen': 'timing',
    },
    {
      'term': '90-Day Cosmic Future Radar',
      'category': 'Features',
      'description': 'Planetary transit calendar mapping major astrological opportunities and challenge periods.',
      'action': 'Open Future Radar',
      'screen': 'radar',
    },
    {
      'term': 'Smart Astro Reminders & Alerts',
      'category': 'Features',
      'description': 'Configure morning score alerts, Rahu Kaal pre-warnings, and Shubh Muhurat window notifications.',
      'action': 'Open Reminders',
      'screen': 'reminders',
    },

    // ── Navagrahas (9 Planets) ───────────────────────────────
    {
      'term': 'Sun (Surya)',
      'category': 'Planet',
      'description': 'Represents the Atma (soul), leadership, father, vitality, self-expression, and willpower in Vedic astrology. Exalted in Aries, debility in Libra.',
      'ruler': 'Leo (Simha)',
      'gemstone': 'Ruby (Manik)',
      'mantra': 'Om Suryaya Namaha',
    },
    {
      'term': 'Moon (Chandra)',
      'category': 'Planet',
      'description': 'Governs the Manas (mind), emotions, mother, mental serenity, intuition, and sleep rhythms. Exalted in Taurus, debility in Scorpio.',
      'ruler': 'Cancer (Karka)',
      'gemstone': 'Pearl (Moti)',
      'mantra': 'Om Chandraya Namaha',
    },
    {
      'term': 'Mars (Mangal)',
      'category': 'Planet',
      'description': 'Symbol of physical energy, courage, brother, land property, ambition, and technical focus. Exalted in Capricorn, debility in Cancer.',
      'ruler': 'Aries (Mesha) & Scorpio (Vrishchika)',
      'gemstone': 'Red Coral (Moonga)',
      'mantra': 'Om Angarakaya Namaha',
    },
    {
      'term': 'Mercury (Budh)',
      'category': 'Planet',
      'description': 'Lord of intelligence, analytical reasoning, trade, speech, witty articulation, and commerce. Exalted in Virgo, debility in Pisces.',
      'ruler': 'Gemini (Mithuna) & Virgo (Kanya)',
      'gemstone': 'Emerald (Panna)',
      'mantra': 'Om Budhaya Namaha',
    },
    {
      'term': 'Jupiter (Brihaspati / Guru)',
      'category': 'Planet',
      'description': 'The supreme benefic planet representing higher wisdom, spiritual dharma, children, wealth, and teachers. Exalted in Cancer, debility in Capricorn.',
      'ruler': 'Sagittarius (Dhanu) & Pisces (Meena)',
      'gemstone': 'Yellow Sapphire (Pukhraj)',
      'mantra': 'Om Brihaspataye Namaha',
    },
    {
      'term': 'Venus (Shukra)',
      'category': 'Planet',
      'description': 'Governs love, sensual beauty, luxury, artistic creativity, marriage harmony, and diplomacy. Exalted in Pisces, debility in Virgo.',
      'ruler': 'Taurus (Vrishabha) & Libra (Tula)',
      'gemstone': 'Diamond (Heera) or White Zircon',
      'mantra': 'Om Shukraya Namaha',
    },
    {
      'term': 'Saturn (Shani)',
      'category': 'Planet',
      'description': 'The Karmic taskmaster representing discipline, endurance, longevity, justice, and practical labor. Exalted in Libra, debility in Aries.',
      'ruler': 'Capricorn (Makara) & Aquarius (Kumbha)',
      'gemstone': 'Blue Sapphire (Neelam)',
      'mantra': 'Om Sham Shanaishcharaya Namaha',
    },
    {
      'term': 'Rahu (North Lunar Node)',
      'category': 'Planet',
      'description': 'Shadow planet representing worldly ambitions, cutting-edge technology, foreign travel, obsession, and sudden shifts.',
      'ruler': 'Co-ruler of Aquarius',
      'gemstone': 'Hessonite Garnet (Gomed)',
      'mantra': 'Om Rahave Namaha',
    },
    {
      'term': 'Ketu (South Lunar Node)',
      'category': 'Planet',
      'description': 'Shadow planet representing spiritual liberation (Moksha), detachment, occult wisdom, intuition, and ascetic enlightenment.',
      'ruler': 'Co-ruler of Scorpio',
      'gemstone': 'Cat’s Eye (Lehsuniya)',
      'mantra': 'Om Ketave Namaha',
    },

    // ── Rashis (12 Zodiac Signs) ─────────────────────────────
    {
      'term': 'Mesha (Aries)',
      'category': 'Rashi',
      'description': '1st sign, Fire element, ruled by Mars. Symbolizes fearless initiative, entrepreneurial drive, physical vigor, and direct leadership.',
    },
    {
      'term': 'Vrishabha (Taurus)',
      'category': 'Rashi',
      'description': '2nd sign, Earth element, ruled by Venus. Symbolizes grounded stability, sensory appreciation, material security, and enduring loyalty.',
    },
    {
      'term': 'Mithuna (Gemini)',
      'category': 'Rashi',
      'description': '3rd sign, Air element, ruled by Mercury. Known for versatile curiosity, rapid communication, intellectual exploration, and adaptability.',
    },
    {
      'term': 'Karka (Cancer)',
      'category': 'Rashi',
      'description': '4th sign, Water element, ruled by Moon. Centers around emotional nurturing, home foundation, empathy, intuition, and family devotion.',
    },
    {
      'term': 'Simha (Leo)',
      'category': 'Rashi',
      'description': '5th sign, Fire element, ruled by Sun. Radiates regal confidence, creative generosity, natural dignity, and authoritative leadership.',
    },
    {
      'term': 'Kanya (Virgo)',
      'category': 'Rashi',
      'description': '6th sign, Earth element, ruled by Mercury. Excels in precise analytical mastery, holistic healing, systematic efficiency, and practical service.',
    },
    {
      'term': 'Tula (Libra)',
      'category': 'Rashi',
      'description': '7th sign, Air element, ruled by Venus. Governs diplomatic justice, aesthetic harmony, consensual partnerships, and balanced agreements.',
    },
    {
      'term': 'Vrishchika (Scorpio)',
      'category': 'Rashi',
      'description': '8th sign, Water element, ruled by Mars & Ketu. Marked by intense transformation, deep psychological penetration, regenerative power, and secrecy.',
    },
    {
      'term': 'Dhanu (Sagittarius)',
      'category': 'Rashi',
      'description': '9th sign, Fire element, ruled by Jupiter. Driven by philosophical exploration, higher truth, international travel, optimism, and moral dharma.',
    },
    {
      'term': 'Makara (Capricorn)',
      'category': 'Rashi',
      'description': '10th sign, Earth element, ruled by Saturn. The master architect of executive responsibility, societal institutions, enduring reputation, and grit.',
    },
    {
      'term': 'Kumbha (Aquarius)',
      'category': 'Rashi',
      'description': '11th sign, Air element, ruled by Saturn & Rahu. Envisions collective progress, humanitarian causes, scientific innovations, and wide community networks.',
    },
    {
      'term': 'Meena (Pisces)',
      'category': 'Rashi',
      'description': '12th sign, Water element, ruled by Jupiter. Channel of universal compassion, poetic artistry, meditative transcendence, and mystical surrender.',
    },

    // ── 12 Bhavas (Astrological Houses) ──────────────────────
    {
      'term': '1st House (Tanu Bhava / Lagna)',
      'category': 'Bhava',
      'description': 'The physical self, bodily vitality, constitution, personality traits, general outlook on life, and personal appearance.',
    },
    {
      'term': '2nd House (Dhana Bhava)',
      'category': 'Bhava',
      'description': 'Accumulated wealth, liquid savings, family lineage, speech demeanor, dietary habits, and moral values.',
    },
    {
      'term': '4th House (Sukha Bhava)',
      'category': 'Bhava',
      'description': 'Inner emotional peace, mother, real estate property, vehicles, primary education, and domestic environment.',
    },
    {
      'term': '7th House (Kalatra Bhava)',
      'category': 'Bhava',
      'description': 'Spousal marriage, intimate partnerships, commercial joint ventures, public interactions, and foreign contracts.',
    },
    {
      'term': '10th House (Karma Bhava)',
      'category': 'Bhava',
      'description': 'Career profession, worldly executive authority, societal reputation, public accomplishments, and father/mentors.',
    },

    // ── Yogas, Dashas & Muhurat ──────────────────────────────
    {
      'term': 'Gajakesari Yoga',
      'category': 'Yoga',
      'description': 'Formed when Jupiter occupies a Kendra (1st, 4th, 7th, or 10th) from the natal Moon. Bestows enduring wisdom, respect, and moral standing.',
    },
    {
      'term': 'Budhaditya Yoga',
      'category': 'Yoga',
      'description': 'Formed by conjunction of Sun and Mercury. Enhances sharp intellect, professional prestige, speech fluency, and executive clarity.',
    },
    {
      'term': 'Vimshottari Dasha',
      'category': 'Dasha',
      'description': 'The 120-year planetary cycle based on the natal Moon Nakshatra. Dictates the unfolding timing of karma, major events, and life chapters.',
    },
    {
      'term': 'Abhijit Muhurat',
      'category': 'Muhurat',
      'description': 'The highly auspicious midday window (approximately 48 minutes centered on local solar noon) blessed by Lord Vishnu to neutralize minor planetary doshas.',
    },
    {
      'term': 'Rahu Kaal',
      'category': 'Muhurat',
      'description': 'A 90-minute daily planetary segment ruled by Rahu. In Vedic tradition, starting new financial ventures or journeys during this window is avoided.',
    },
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _onItemTapped(Map<String, String> item) {
    if (item['category'] == 'Features') {
      final screen = item['screen'];
      if (screen == 'kundli') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const KundliScreen()));
      } else if (screen == 'matching') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchingScreen()));
      } else if (screen == 'astrobaba') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroBabaScreen()));
      } else if (screen == 'pdf') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomPdfReportBuilderScreen()));
      } else if (screen == 'timing') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalTimingEngineScreen()));
      } else if (screen == 'radar') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FutureRadarScreen()));
      } else if (screen == 'reminders') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroRemindersScreen()));
      }
    } else {
      _showAstrologyDetailsSheet(item);
    }
  }

  void _showAstrologyDetailsSheet(Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: AppColors.getGlassBorder(context))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: Text(
                    item['category']!.toUpperCase(),
                    style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(context)),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item['term']!,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item['description']!,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                height: 1.5,
                color: AppColors.getTextPrimary(context).withOpacity(0.9),
              ),
            ),
            if (item['ruler'] != null || item['gemstone'] != null || item['mantra'] != null) ...[
              const SizedBox(height: 16),
              Divider(color: AppColors.getDivider(context)),
              const SizedBox(height: 8),
              if (item['ruler'] != null)
                _buildInfoRow('Ruling Sign:', item['ruler']!),
              if (item['gemstone'] != null)
                _buildInfoRow('Prescribed Gemstone:', item['gemstone']!),
              if (item['mantra'] != null)
                _buildInfoRow('Sacred Mantra:', item['mantra']!),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final query = _queryController.text.trim().toLowerCase();

    final results = _knowledgeBase.where((item) {
      final matchesQuery = query.isEmpty ||
          item['term']!.toLowerCase().contains(query) ||
          item['description']!.toLowerCase().contains(query);
      final matchesFilter = _selectedFilter == 'All' || item['category'] == _selectedFilter;
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
        elevation: 0,
        title: Text(
          'Vedic Astrology Knowledge Search',
          style: GoogleFonts.outfit(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Input
              TextField(
                controller: _queryController,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.inter(color: AppColors.getTextPrimary(context), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search Planet, Rashi, House, Feature...',
                  hintStyle: GoogleFonts.inter(color: AppColors.getTextMuted(context), fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, color: AppColors.getTextSecondary(context), size: 18),
                          onPressed: () {
                            _queryController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.getSurface(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.getBorder(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.getBorder(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Filter Chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.getSurface(context),
                        labelStyle: GoogleFonts.outfit(
                          color: isSelected ? Colors.black : AppColors.getTextPrimary(context),
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.getBorder(context),
                        ),
                        onSelected: (sel) {
                          if (sel) setState(() => _selectedFilter = filter);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // Results List
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Text(
                          'No matching astrology terms found.\nTry a different search keyword.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: AppColors.getTextMuted(context), fontSize: 13),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          final isFeature = item['category'] == 'Features';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.getSurface(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isFeature ? AppColors.primary.withOpacity(0.5) : AppColors.getBorder(context),
                                width: 0.8,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _onItemTapped(item),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item['term']!,
                                            style: GoogleFonts.outfit(
                                              color: isFeature ? AppColors.primary : AppColors.getTextPrimary(context),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: (isFeature ? AppColors.primary : Colors.grey).withOpacity(0.14),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: (isFeature ? AppColors.primary : Colors.grey).withOpacity(0.3),
                                              ),
                                            ),
                                            child: Text(
                                              item['category']!,
                                              style: GoogleFonts.outfit(
                                                color: isFeature ? AppColors.primary : AppColors.getTextSecondary(context),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            isFeature ? Icons.arrow_forward_rounded : Icons.info_outline_rounded,
                                            size: 16,
                                            color: AppColors.getTextSecondary(context),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['description']!,
                                        style: GoogleFonts.inter(
                                          color: AppColors.getTextSecondary(context),
                                          fontSize: 12,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
