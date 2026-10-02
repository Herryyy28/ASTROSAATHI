import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../home/presentation/screens/main_screen.dart';
import '../widgets/guna_radar_painter.dart';

class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen>
    with SingleTickerProviderStateMixin {
  final _p1NameController = TextEditingController(text: 'Rohan');
  final _p2NameController = TextEditingController(text: 'Priya');

  String _p1Sign = 'Aries';
  String _p2Sign = 'Leo';

  late TabController _tabController;

  final List<String> _zodiacSigns = const [
    'Aries', 'Taurus', 'Gemini', 'Cancer',
    'Leo', 'Virgo', 'Libra', 'Scorpio',
    'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];

  final List<String> _tabs = [
    'RESULTS',
    'DETAILS',
    'VARNA',
    'VASYA',
    'TARA',
    'YONI',
    'MAITRI',
    'GANA',
    'BHAKOOT',
    'NADI',
  ];

  double totalScore = 25.5;
  String grade = 'Good';
  String summaryText =
      'Rohan (Aries) and Priya (Leo) achieve an authentic Ashtakoota compatibility score of 25.5 out of 36 Gunas (Auspicious Match).';

  static const Map<String, double> maxScores = {
    'Varna': 1.0,
    'Vasya': 2.0,
    'Tara': 3.0,
    'Yoni': 4.0,
    'Maitri': 5.0,
    'Gana': 6.0,
    'Bhakoot': 7.0,
    'Nadi': 8.0,
  };

  static const Map<String, String> areasOfLife = {
    'Varna': 'Work',
    'Vasya': 'Dominance',
    'Tara': 'Destiny',
    'Yoni': 'Mentality',
    'Maitri': 'Compatibility',
    'Gana': 'Guna Level',
    'Bhakoot': 'Love',
    'Nadi': 'Health',
  };

  Map<String, double> rawScores = {
    'Varna': 1.0,
    'Vasya': 1.0,
    'Tara': 1.5,
    'Yoni': 2.0,
    'Maitri': 5.0,
    'Gana': 0.0,
    'Bhakoot': 7.0,
    'Nadi': 8.0,
  };

  @override
  void initState() {
    super.initState();
    // Default to DETAILS tab to match Image 4
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 1);

    final active = ref.read(activeProfileProvider);
    if (active.name.isNotEmpty) {
      _p1NameController.text = active.name;
      final z = ZodiacSignUtils.getZodiacFromName(active.name);
      if (z != null) {
        _p1Sign = z.englishName;
      }
    }
    _calculateMatch();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _p1NameController.dispose();
    _p2NameController.dispose();
    super.dispose();
  }

  void _calculateMatch() {
    final idx1 = _zodiacSigns.indexOf(_p1Sign);
    final idx2 = _zodiacSigns.indexOf(_p2Sign);

    final varna = (idx1 ~/ 3 >= idx2 ~/ 3) ? 1.0 : 0.5;
    final vasya = (idx1 % 3 == idx2 % 3) ? 2.0 : 1.0;
    final distance = (idx2 - idx1 + 12) % 12;
    final tara = (distance % 9 == 3 || distance % 9 == 5) ? 1.5 : 3.0;
    final yoni = (idx1 == idx2) ? 4.0 : 2.0;

    final isSameLord = (idx1 % 6 == idx2 % 6);
    final maitri = isSameLord ? 5.0 : 4.0;

    final gana = (idx1 % 3 == idx2 % 3) ? 6.0 : 0.0;
    final houseDiff = (idx2 - idx1 + 12) % 12 + 1;
    final bhakoot = (houseDiff == 2 || houseDiff == 12 || houseDiff == 6 || houseDiff == 8) ? 0.0 : 7.0;
    final nadi = (idx1 % 3 == idx2 % 3 && idx1 != idx2) ? 0.0 : 8.0;

    final calculatedTotal = varna + vasya + tara + yoni + maitri + gana + bhakoot + nadi;

    String calculatedGrade = 'Good';
    if (calculatedTotal >= 28) {
      calculatedGrade = 'Exceptional';
    } else if (calculatedTotal >= 24) {
      calculatedGrade = 'Good';
    } else if (calculatedTotal >= 18) {
      calculatedGrade = 'Average';
    } else {
      calculatedGrade = 'Challenging';
    }

    setState(() {
      totalScore = calculatedTotal;
      grade = calculatedGrade;
      rawScores = {
        'Varna': varna,
        'Vasya': vasya,
        'Tara': tara,
        'Yoni': yoni,
        'Maitri': maitri,
        'Gana': gana,
        'Bhakoot': bhakoot,
        'Nadi': nadi,
      };
      summaryText =
          '${_p1NameController.text} ($_p1Sign) & ${_p2NameController.text} ($_p2Sign) achieve an Ashtakoota compatibility score of $calculatedTotal / 36 ($calculatedGrade Match).';
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(activeProfileProvider, (previous, next) {
      if (next.name.isNotEmpty && next.name != _p1NameController.text) {
        _p1NameController.text = next.name;
        final z = ZodiacSignUtils.getZodiacFromName(next.name);
        if (z != null) {
          setState(() {
            _p1Sign = z.englishName;
          });
        }
        _calculateMatch();
      }
    });

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF9F9F9) : AppColors.backgroundDark,
      body: SafeArea(
        child: ResponsiveLayout(
          child: Column(
            children: [
              // ── Top Bar (AstroSage Golden Header) ─────────────────
              _buildGoldenAppBar(context),

              // ── Tab Bar (RESULTS, DETAILS, VARNA, VASYA...) ────────
              _buildTabBar(context),

              // ── Tab Views ──────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildResultsTab(context, isLight),
                    _buildDetailsTab(context, isLight), // Image 4 Table View
                    _buildGunaInfoTab(
                      'Varna (Work & Ego Compatibility)',
                      'Maximum Points: 1.0\nObtained: ${rawScores['Varna']}\n\n'
                          'Varna indicates mental compatibility and spiritual inclinations. It assesses the intellectual and work attitude harmony between partners.',
                    ),
                    _buildGunaInfoTab(
                      'Vasya (Dominance & Magnetic Attraction)',
                      'Maximum Points: 2.0\nObtained: ${rawScores['Vasya']}\n\n'
                          'Vasya represents the degree of mutual influence and magnetic attraction. It reveals whether one partner naturally dominates or if power is shared equally.',
                    ),
                    _buildGunaInfoTab(
                      'Tara (Destiny & Longevity)',
                      'Maximum Points: 3.0\nObtained: ${rawScores['Tara']}\n\n'
                          'Tara measures the birth star (Nakshatra) compatibility, determining the mutual prosperity, good fortune, and health longevity in matrimonial life.',
                    ),
                    _buildGunaInfoTab(
                      'Yoni (Mentality & Biological Harmony)',
                      'Maximum Points: 4.0\nObtained: ${rawScores['Yoni']}\n\n'
                          'Yoni represents biological attraction, intimate compatibility, and instinctive mutual affection between husband and wife.',
                    ),
                    _buildGunaInfoTab(
                      'Maitri (Friendship & Psychological Compatibility)',
                      'Maximum Points: 5.0\nObtained: ${rawScores['Maitri']}\n\n'
                          'Graha Maitri evaluates the planetary friendship between Moon sign lords. High points ensure lasting friendship and emotional understanding.',
                    ),
                    _buildGunaInfoTab(
                      'Gana (Temperament & Lifestyle Harmony)',
                      'Maximum Points: 6.0\nObtained: ${rawScores['Gana']}\n\n'
                          'Gana classifies human nature into Deva (divine), Manushya (human), and Rakshasa (demonic). Similar ganas ensure domestic peace.',
                    ),
                    _buildGunaInfoTab(
                      'Bhakoot (Love, Family & Financial Prosperity)',
                      'Maximum Points: 7.0\nObtained: ${rawScores['Bhakoot']}\n\n'
                          'Bhakoot relates to emotional bonding, child birth, and economic progress. Auspicious alignment creates wealth and harmony.',
                    ),
                    _buildGunaInfoTab(
                      'Nadi (Health, Genetics & Heredity)',
                      'Maximum Points: 8.0\nObtained: ${rawScores['Nadi']}\n\n'
                          'Nadi is the single highest-scoring Guna (8 points). It assesses genetic compatibility, nervous constitution, and offspring longevity.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoldenAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF5A623), // AstroSage Golden Yellow
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AstroSaathi Matching',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing Kundli Milan Result...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.black87, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading detailed Match PDF Report...')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black87, size: 24),
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'settings') {
                ref.read(mainNavIndexProvider.notifier).state = 4;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_rounded, size: 20, color: AppColors.getTextPrimary(context)),
                    const SizedBox(width: 12),
                    Text('Settings', style: GoogleFonts.inter(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF5A623),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: Colors.black,
        indicatorWeight: 3.5,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  /// Exact replica of Image 4: Guna Milan Result in Detail Table & Score
  Widget _buildDetailsTab(BuildContext context, bool isLight) {
    final keys = ['Varna', 'Vasya', 'Tara', 'Yoni', 'Maitri', 'Gana', 'Bhakoot', 'Nadi'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Guna Milan Result in Detail',
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),

          // 4-Column Table Header
          Container(
            color: isLight ? const Color(0xFFEBEBEB) : const Color(0xFF2C2436),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Guna',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Maximum',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Obtained',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Area of Life',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Rows with alternating background
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final max = maxScores[key] ?? 1.0;
              final obtained = rawScores[key] ?? 0.0;
              final area = areasOfLife[key] ?? '';
              final isEven = index % 2 == 0;

              final rowBg = isEven
                  ? (isLight ? Colors.white : AppColors.surfaceDark)
                  : (isLight ? const Color(0xFFF4F4F4) : const Color(0xFF20182A));

              return Container(
                color: rowBg,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        key,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        max.toInt().toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        obtained.toStringAsFixed(1),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: obtained == 0
                              ? const Color(0xFFD32F2F)
                              : AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        area,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // ── Big Score Banner (25.5 / 36) exactly matching Image 4 ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFEBEBEB) : const Color(0xFF241C2D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLight ? const Color(0xFFDDDDDD) : AppColors.borderDark,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isLight ? 0.04 : 0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: totalScore.toStringAsFixed(1),
                      style: GoogleFonts.outfit(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(context),
                        letterSpacing: -1,
                      ),
                    ),
                    TextSpan(
                      text: ' / 36',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Astrological Verdict Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: totalScore >= 18
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: totalScore >= 18
                      ? const Color(0xFF81C784)
                      : const Color(0xFFE57373),
                ),
              ),
              child: Text(
                totalScore >= 18 ? '✦ Auspicious Match ($grade)' : '⚠ Needs Consultation',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: totalScore >= 18 ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildResultsTab(BuildContext context, bool isLight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Partner Input Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLight ? Colors.white : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.getGlassBorder(context)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _p1NameController,
                            style: TextStyle(color: AppColors.getTextPrimary(context)),
                            decoration: InputDecoration(
                              labelText: 'Partner 1',
                              labelStyle: TextStyle(color: AppColors.getTextSecondary(context)),
                              filled: true,
                              fillColor: AppColors.getSurfaceSecondary(context),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildZodiacDropdown('Sign 1', _p1Sign, (val) {
                            if (val != null) setState(() => _p1Sign = val);
                          }),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.favorite_rounded, color: Color(0xFFE91E63), size: 28),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _p2NameController,
                            style: TextStyle(color: AppColors.getTextPrimary(context)),
                            decoration: InputDecoration(
                              labelText: 'Partner 2',
                              labelStyle: TextStyle(color: AppColors.getTextSecondary(context)),
                              filled: true,
                              fillColor: AppColors.getSurfaceSecondary(context),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildZodiacDropdown('Sign 2', _p2Sign, (val) {
                            if (val != null) setState(() => _p2Sign = val);
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _calculateMatch,
                    child: Text('Recalculate Gun Milan', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Radar Chart representation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isLight ? Colors.white : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.getGlassBorder(context)),
            ),
            child: Column(
              children: [
                Text(
                  'Ashtakoot Compatibility Radar',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CustomPaint(
                    painter: GunaRadarPainter(
                      scores: rawScores.map((k, v) => MapEntry(k, v / (maxScores[k] ?? 1.0))),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Summary Text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLight ? Colors.white : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.getGlassBorder(context)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Color(0xFFF5A623), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    summaryText,
                    style: GoogleFonts.inter(fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildGunaInfoTab(String title, String content) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFFF5A623)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.getGlassBorder(context)),
            ),
            child: Text(
              content,
              style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: AppColors.getTextPrimary(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacDropdown(String label, String currentVal, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceSecondary(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentVal,
          isExpanded: true,
          style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 13),
          dropdownColor: AppColors.getSurface(context),
          items: _zodiacSigns.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
