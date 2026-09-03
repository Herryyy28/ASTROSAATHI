import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';

class AstroScenarioSimulatorScreen extends StatefulWidget {
  const AstroScenarioSimulatorScreen({super.key});

  @override
  State<AstroScenarioSimulatorScreen> createState() => _AstroScenarioSimulatorScreenState();
}

class _AstroScenarioSimulatorScreenState extends State<AstroScenarioSimulatorScreen> {
  int _selectedScenarioType = 0; // 0: Location Shift, 1: Timing Shift, 2: Future Date

  // Scenario 0: Location Shift State (World Cities & Countries)
  String _originCity = 'Ahmedabad, India';
  String _targetCity = 'Dubai, UAE';

  // Scenario 1: Timing Shift State
  String _timeOptionA = '10:15 AM (Abhijit Muhurat)';
  String _timeOptionB = '02:30 PM (Rahu Kaal Window)';

  // Scenario 2: Future Date State
  String _targetMonth = 'October 2026';

  static const List<Map<String, String>> _presetLocations = [
    {
      'city': 'Ahmedabad',
      'country': 'India',
      'flag': '🇮🇳',
      'line': 'Sun-Mercury Karma Axis',
      'score': '+1.2',
      'verdict': 'STRONG SYNERGY',
      'detail': 'Sun-Mercury conjunction aligns with 10th House Karma Lord.',
    },
    {
      'city': 'Mumbai',
      'country': 'India',
      'flag': '🇮🇳',
      'line': 'Mercury Midheaven Line',
      'score': '+1.1',
      'verdict': 'STRONG SYNERGY',
      'detail': 'Mercury 10th house placement boosts financial trading and commerce authority.',
    },
    {
      'city': 'Delhi',
      'country': 'India',
      'flag': '🇮🇳',
      'line': 'Sun Zenith Authority Line',
      'score': '+1.3',
      'verdict': 'PEAK SYNERGY',
      'detail': 'Sun in 10th house strengthens executive leadership and administrative recognition.',
    },
    {
      'city': 'Bengaluru',
      'country': 'India',
      'flag': '🇮🇳',
      'line': 'Rahu Technocracy Line',
      'score': '+1.5',
      'verdict': 'HIGH SYNERGY',
      'detail': 'Rahu-Mercury alignment favors tech innovation, startups, and software engineering.',
    },
    {
      'city': 'Jaipur',
      'country': 'India',
      'flag': '🇮🇳',
      'line': 'Jupiter Cultural Heritage Trine',
      'score': '+1.0',
      'verdict': 'FAVORABLE SHIFT',
      'detail': 'Jupiter in 9th house enhances creative arts, architectural legacy, and spiritual peace.',
    },
    {
      'city': 'Hyderabad',
      'country': 'India',
      'flag': '🇮🇳',
      'line': 'Kuber Cyber Node',
      'score': '+1.4',
      'verdict': 'HIGH SYNERGY',
      'detail': 'Venus-Mercury 11th house synergy accelerates enterprise tech & wealth building.',
    },
    {
      'city': 'Dubai',
      'country': 'UAE',
      'flag': '🇦🇪',
      'line': 'Jupiter Midheaven Line',
      'score': '+1.8',
      'verdict': 'PEAK SYNERGY',
      'detail': 'Jupiter on Midheaven opens a 6-month window of rapid wealth creation & executive status.',
    },
    {
      'city': 'London',
      'country': 'UK',
      'flag': '🇬🇧',
      'line': 'Venus IC Harmony Line',
      'score': '+0.9',
      'verdict': 'MODERATE SYNERGY',
      'detail': 'Venus in 4th house brings domestic comfort, luxury living, and creative opportunities.',
    },
    {
      'city': 'Toronto',
      'country': 'Canada',
      'flag': '🇨🇦',
      'line': 'Moon Descendant Line',
      'score': '+0.6',
      'verdict': 'BALANCED',
      'detail': 'Moon on Descendant deepens emotional partnerships, family immigration, and community stability.',
    },
    {
      'city': 'Vancouver',
      'country': 'Canada',
      'flag': '🇨🇦',
      'line': 'Neptune-Venus Coastal Trine',
      'score': '+0.8',
      'verdict': 'HARMONIOUS',
      'detail': 'Venus-Neptune harmonic aspect favors wellness, natural living, and balanced lifestyle.',
    },
    {
      'city': 'New York',
      'country': 'USA',
      'flag': '🇺🇸',
      'line': 'Sun Midheaven Power Line',
      'score': '+1.6',
      'verdict': 'PEAK SYNERGY',
      'detail': 'Sun on Midheaven dramatically elevates ambition, global recognition, and capital growth.',
    },
    {
      'city': 'San Francisco',
      'country': 'USA',
      'flag': '🇺🇸',
      'line': 'Mercury Node Synergy',
      'score': '+1.4',
      'verdict': 'HIGH SYNERGY',
      'detail': 'Mercury in 11th house of gains triggers major venture funding and tech network expansion.',
    },
    {
      'city': 'Chicago',
      'country': 'USA',
      'flag': '🇺🇸',
      'line': 'Saturn-Sun Industry Zenith',
      'score': '+1.2',
      'verdict': 'STRONG SYNERGY',
      'detail': 'Saturn-Sun conjunction in 10th house rewards industrial enterprise & executive grit.',
    },
    {
      'city': 'Los Angeles',
      'country': 'USA',
      'flag': '🇺🇸',
      'line': 'Venus Media Zenith Line',
      'score': '+1.5',
      'verdict': 'PEAK SYNERGY',
      'detail': 'Venus on Zenith amplifies public presence, media production, and entertainment charisma.',
    },
    {
      'city': 'Singapore',
      'country': 'Singapore',
      'flag': '🇸🇬',
      'line': 'Kuber Lakshmi Axis',
      'score': '+1.7',
      'verdict': 'PEAK SYNERGY',
      'detail': 'Venus-Jupiter 2nd & 11th lord connection creates optimum wealth accumulation conditions.',
    },
    {
      'city': 'Sydney',
      'country': 'Australia',
      'flag': '🇦🇺',
      'line': 'Mars Zenith Drive Line',
      'score': '+0.8',
      'verdict': 'DYNAMIC SHIFT',
      'detail': 'Mars on Zenith energizes physical vitality, real estate ventures, and independent initiative.',
    },
    {
      'city': 'Tokyo',
      'country': 'Japan',
      'flag': '🇯🇵',
      'line': 'Saturn Stability Line',
      'score': '+0.5',
      'verdict': 'STABLE & DISCIPLINED',
      'detail': 'Saturn in 6th house yields disciplined hard work, long-term security, and structural success.',
    },
    {
      'city': 'Berlin',
      'country': 'Germany',
      'flag': '🇩🇪',
      'line': 'Mercury-Jupiter Trine',
      'score': '+1.0',
      'verdict': 'FAVORABLE',
      'detail': 'Mercury-Jupiter trine supports academic research, intellectual property, and industrial contracts.',
    },
    {
      'city': 'Paris',
      'country': 'France',
      'flag': '🇫🇷',
      'line': 'Venus Zenith Beauty Line',
      'score': '+1.3',
      'verdict': 'HIGH SYNERGY',
      'detail': 'Venus on Zenith brings aesthetic fulfillment, brand elevation, and artistic recognition.',
    },
    {
      'city': 'Rome',
      'country': 'Italy',
      'flag': '🇮🇹',
      'line': 'Jupiter Solar Wisdom Node',
      'score': '+1.1',
      'verdict': 'STRONG SYNERGY',
      'detail': 'Jupiter in 9th house inspires cultural depth, philosophy, and legal accomplishments.',
    },
    {
      'city': 'Barcelona',
      'country': 'Spain',
      'flag': '🇪🇸',
      'line': 'Sun-Venus Coastal Trine',
      'score': '+1.2',
      'verdict': 'HIGH SYNERGY',
      'detail': 'Sun-Venus harmony enhances vibrant social life, design innovation, and lifestyle joy.',
    },
    {
      'city': 'Amsterdam',
      'country': 'Netherlands',
      'flag': '🇳🇱',
      'line': 'Mercury Global Commerce Line',
      'score': '+1.3',
      'verdict': 'HIGH SYNERGY',
      'detail': 'Mercury in 10th house boosts international trade, logistics, and digital nomad growth.',
    },
    {
      'city': 'Zurich',
      'country': 'Switzerland',
      'flag': '🇨🇭',
      'line': 'Kuber Financial Fortress Axis',
      'score': '+1.6',
      'verdict': 'PEAK SYNERGY',
      'detail': 'Saturn-Jupiter 2nd house strength provides unparalleled asset protection and financial security.',
    },
    {
      'city': 'Bangkok',
      'country': 'Thailand',
      'flag': '🇹🇭',
      'line': 'Venus-Jupiter Hospitality Line',
      'score': '+1.1',
      'verdict': 'FAVORABLE SHIFT',
      'detail': 'Jupiter in 5th house favors tourism, creative endeavors, and culinary business.',
    },
    {
      'city': 'Kuala Lumpur',
      'country': 'Malaysia',
      'flag': '🇲🇾',
      'line': 'Mercury-Rahu Regional Gateway',
      'score': '+1.2',
      'verdict': 'STRONG SYNERGY',
      'detail': 'Rahu-Mercury alignment unlocks South-East Asian market expansion and commercial gains.',
    },
  ];

  Map<String, String> _resolveLocationData(String locationString) {
    final cleanInput = locationString.trim();

    // 1. Try exact or partial match in preset list
    for (final loc in _presetLocations) {
      final fullPreset = '${loc['city']}, ${loc['country']}'.toLowerCase();
      final cityOnly = loc['city']!.toLowerCase();
      if (fullPreset == cleanInput.toLowerCase() || cityOnly == cleanInput.toLowerCase()) {
        return loc;
      }
    }

    // 2. Deterministically calculate Astrocartography metadata for ANY typed custom world city & country!
    final parts = cleanInput.split(',');
    final cityName = parts[0].trim();
    final countryName = parts.length > 1 ? parts[1].trim() : 'Global';

    final hash = cleanInput.toLowerCase().codeUnits.fold(0, (prev, elem) => prev + elem);

    final lines = [
      'Jupiter Zenith Midheaven Line',
      'Sun Karma Leadership Axis',
      'Venus IC Domestic Trine',
      'Mercury 10th House Commerce Line',
      'Rahu Innovation & Tech Node',
      'Kuber Wealth Lakshmi Axis',
      'Mars Zenith Power Line',
    ];
    final verdicts = ['PEAK SYNERGY', 'HIGH SYNERGY', 'STRONG SYNERGY', 'FAVORABLE SHIFT'];

    final line = lines[hash % lines.length];
    final verdict = verdicts[hash % verdicts.length];
    final score = '+${((hash % 11) / 10.0 + 0.8).toStringAsFixed(1)}';

    return {
      'city': cityName.isNotEmpty ? cityName : 'Location',
      'country': countryName,
      'flag': '🌍',
      'line': line,
      'score': score,
      'verdict': verdict,
      'detail': 'Relocation to $cityName ($countryName) aligns $line, optimizing 10th Karma & 11th Gain houses.',
    };
  }

  void _showCitySearchModal(BuildContext context, bool isOrigin) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = searchController.text.trim().toLowerCase();
            final filteredPresets = _presetLocations.where((loc) {
              final fullStr = '${loc['city']} ${loc['country']}'.toLowerCase();
              return fullStr.contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                  color: isLight ? Colors.black.withOpacity(0.08) : AppColors.glassBorder,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Handle Bar
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.getTextMuted(context),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Icon(
                            isOrigin ? Icons.my_location_rounded : Icons.flight_land_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isOrigin ? 'Select Origin Location' : 'Select Target Location',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Search & Type Input Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: searchController,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.getTextPrimary(context),
                        ),
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Type any World City & Country (e.g. Rome, Italy)...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.getTextMuted(context),
                          ),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    searchController.clear();
                                    setModalState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: AppColors.getSurfaceElevated(context),
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
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Apply Custom Typed Location Button (if user typed something)
                    if (searchController.text.trim().isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.check_circle_rounded, size: 18),
                            label: Text(
                              'Use Custom Location: "${searchController.text.trim()}"',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () {
                              final typedVal = searchController.text.trim();
                              setState(() {
                                if (isOrigin) {
                                  _originCity = typedVal;
                                } else {
                                  _targetCity = typedVal;
                                }
                              });
                              Navigator.pop(ctx);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Presets Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'POPULAR WORLD DESTINATIONS',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextSecondary(context),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Filtered List of Cities
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredPresets.length,
                        itemBuilder: (context, index) {
                          final loc = filteredPresets[index];
                          final locName = '${loc['city']}, ${loc['country']}';
                          final isSelected = isOrigin
                              ? (_originCity.toLowerCase() == locName.toLowerCase() || _originCity.toLowerCase() == loc['city']!.toLowerCase())
                              : (_targetCity.toLowerCase() == locName.toLowerCase() || _targetCity.toLowerCase() == loc['city']!.toLowerCase());

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.15)
                                  : AppColors.getSurfaceElevated(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.getBorder(context),
                                width: isSelected ? 1.5 : 0.6,
                              ),
                            ),
                            child: ListTile(
                              dense: true,
                              leading: Text(loc['flag']!, style: const TextStyle(fontSize: 22)),
                              title: Text(
                                '${loc['city']}, ${loc['country']}',
                                style: GoogleFonts.outfit(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              subtitle: Text(
                                loc['line']!,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                                  : const Icon(Icons.chevron_right_rounded, size: 18),
                              onTap: () {
                                setState(() {
                                  if (isOrigin) {
                                    _originCity = locName;
                                  } else {
                                    _targetCity = locName;
                                  }
                                });
                                Navigator.pop(ctx);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceElevated(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: AppColors.getTextPrimary(context), size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Astro Scenario Simulator',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
                                ),
                                child: Text(
                                  'LABS',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Simulate location, timing & future date variations',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scenario Type Selector Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildTypeChip(0, Icons.flight_takeoff_rounded, 'Location Shift'),
                    const SizedBox(width: 8),
                    _buildTypeChip(1, Icons.access_time_rounded, 'Timing Window'),
                    const SizedBox(width: 8),
                    _buildTypeChip(2, Icons.calendar_month_rounded, 'Future Date'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (_selectedScenarioType == 0) _buildLocationSimulator(context),
                    if (_selectedScenarioType == 1) _buildTimingSimulator(context),
                    if (_selectedScenarioType == 2) _buildFutureDateSimulator(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(int index, IconData icon, String label) {
    final isSelected = _selectedScenarioType == index;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ChoiceChip(
      showCheckmark: false,
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedScenarioType = index),
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected
            ? Colors.black
            : (isLight ? AppColors.getPrimary(context) : AppColors.primary),
      ),
      label: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected
              ? Colors.black
              : AppColors.getTextPrimary(context),
        ),
      ),
      selectedColor: AppColors.primary,
      backgroundColor: isLight
          ? AppColors.getSurfaceSecondary(context)
          : Colors.white.withOpacity(0.06),
      side: BorderSide(
        color: isSelected
            ? AppColors.primary
            : AppColors.getBorder(context),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildLocationSimulator(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final greenColor = isLight ? Colors.green[800]! : Colors.greenAccent;

    final originLoc = _resolveLocationData(_originCity);
    final targetLoc = _resolveLocationData(_targetCity);

    final isSameLocation = originLoc['city']!.toLowerCase() == targetLoc['city']!.toLowerCase();

    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMPARE ASTROCARTOGRAPHY & RELOCATION',
                style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  // ORIGIN LOCATION BUTTON
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ORIGIN LOCATION', style: GoogleFonts.outfit(fontSize: 10, color: AppColors.getTextSecondary(context))),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => _showCitySearchModal(context, true),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.getSurfaceElevated(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.getBorder(context)),
                            ),
                            child: Row(
                              children: [
                                Text(originLoc['flag'] ?? '🌍', style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        originLoc['city']!,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getTextPrimary(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (originLoc['country']!.isNotEmpty)
                                        Text(
                                          originLoc['country']!,
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5,
                                            color: AppColors.getTextSecondary(context),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SWAP / COMPARE ICON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: IconButton(
                      icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 22),
                      onPressed: () {
                        setState(() {
                          final temp = _originCity;
                          _originCity = _targetCity;
                          _targetCity = temp;
                        });
                      },
                    ),
                  ),

                  // TARGET LOCATION BUTTON
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TARGET LOCATION', style: GoogleFonts.outfit(fontSize: 10, color: AppColors.getTextSecondary(context))),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => _showCitySearchModal(context, false),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.getSurfaceElevated(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.getBorder(context)),
                            ),
                            child: Row(
                              children: [
                                Text(targetLoc['flag'] ?? '🌍', style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        targetLoc['city']!,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getTextPrimary(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (targetLoc['country']!.isNotEmpty)
                                        Text(
                                          targetLoc['country']!,
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5,
                                            color: AppColors.getTextSecondary(context),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Results Card
        GlassCard(
          padding: const EdgeInsets.all(18),
          borderColor: AppColors.primary.withOpacity(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Non-Truncating & Non-Overflowing Verdict Badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SIMULATION VERDICT',
                      style: GoogleFonts.outfit(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextSecondary(context),
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: greenColor.withOpacity(isLight ? 0.12 : 0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: greenColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      isSameLocation
                          ? 'BASELINE LOCATION'
                          : '${targetLoc['verdict']} (▲ ${targetLoc['score']} PTS)',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: greenColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Route & Alignment Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceElevated(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(originLoc['flag'] ?? '🌍', style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          originLoc['city']!,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.east_rounded,
                            size: 16,
                            color: AppColors.getPrimary(context),
                          ),
                        ),
                        Text(targetLoc['flag'] ?? '🌍', style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          targetLoc['city']!,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isSameLocation
                          ? 'Baseline natal chart applies in ${originLoc['city']}. Select a different target city to compare relocation synergy.'
                          : 'Relocation aligns ${targetLoc['line']} across your zenith meridian.',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              if (isSameLocation) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceElevated(context),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Select a different target city above to compare planetary line shifts & relocation synergy.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Structured Detail Cards
                _buildStructuredDetailItem(
                  context,
                  icon: Icons.explore_rounded,
                  iconColor: AppColors.primary,
                  title: 'Astrocartography Line',
                  value: targetLoc['line']!,
                ),
                const SizedBox(height: 8),
                _buildStructuredDetailItem(
                  context,
                  icon: Icons.auto_awesome_rounded,
                  iconColor: Colors.purpleAccent,
                  title: 'Relocation & House Impact',
                  value: targetLoc['detail']!,
                ),
                const SizedBox(height: 8),
                _buildStructuredDetailItem(
                  context,
                  icon: Icons.trending_up_rounded,
                  iconColor: greenColor,
                  title: 'Career & Wealth Synergy',
                  value: '${targetLoc['score']} PTS gain over ${originLoc['city']}',
                ),
              ],

              const SizedBox(height: 16),

              // Ask Astro Baba AI Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.smart_toy_rounded, size: 18),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Ask Astro Baba: "Should I move to ${targetLoc['city']}?"',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AstroBabaScreen(
                          initialMessage:
                              'Analyze my natal chart relocation suitability for moving from ${originLoc['city']} (${originLoc['country']}) to ${targetLoc['city']} (${targetLoc['country']}).',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStructuredDetailItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight
            ? AppColors.surfaceElevatedLight
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLight ? Colors.black.withOpacity(0.06) : AppColors.glassBorder,
          width: 0.6,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextSecondary(context),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingSimulator(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIMING WINDOW COMPARISON',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          _buildTimingOptionCard(
            context,
            badge: 'OPTION A (RECOMMENDED)',
            title: _timeOptionA,
            score: '8.8/10',
            muhurat: 'Abhijit Muhurat',
            rahuStatus: 'Rahu-Kaal Free Window',
            color: Colors.greenAccent,
          ),
          const SizedBox(height: 12),
          _buildTimingOptionCard(
            context,
            badge: 'OPTION B (CAUTION)',
            title: _timeOptionB,
            score: '4.2/10',
            muhurat: 'Gulika Kaal Active',
            rahuStatus: 'Rahu Kaal Intersecting',
            color: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildTimingOptionCard(
    BuildContext context, {
    required String badge,
    required String title,
    required String score,
    required String muhurat,
    required String rahuStatus,
    required Color color,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(isLight ? 0.06 : 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.35), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.outfit(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Text(
                'Score $score',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMiniPointBadge(
                  context,
                  icon: Icons.check_circle_outline_rounded,
                  label: muhurat,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniPointBadge(
                  context,
                  icon: Icons.shield_outlined,
                  label: rahuStatus,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPointBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceElevated(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.getBorder(context),
          width: 0.6,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFutureDateSimulator(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FUTURE DATE ASTROLOGICAL PROJECTION',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Target Month:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceElevated(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.getBorder(context)),
                ),
                child: DropdownButton<String>(
                  value: _targetMonth,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
                  items: ['October 2026', 'November 2026', 'December 2026', 'January 2027']
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextPrimary(context),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _targetMonth = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Structured Future Projection Cards
          _buildStructuredDetailItem(
            context,
            icon: Icons.calendar_month_rounded,
            iconColor: AppColors.primary,
            title: 'Active Dasha Period',
            value: 'Jupiter Mahadasha + Mercury Antardasha',
          ),
          const SizedBox(height: 8),
          _buildStructuredDetailItem(
            context,
            icon: Icons.stars_rounded,
            iconColor: Colors.amber,
            title: 'Projected Cosmic Score',
            value: '8.9 / 10 • Exceptional Growth Window',
          ),
        ],
      ),
    );
  }
}
