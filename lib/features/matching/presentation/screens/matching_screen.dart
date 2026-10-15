import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/models/birth_details.dart';
import '../../../../core/models/matchmaking_models.dart';
import '../../../../core/providers/matchmaking_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
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
  final _p1DobController = TextEditingController(text: '1995-05-15');
  final _p1TimeController = TextEditingController(text: '08:30');
  final _p1PlaceController = TextEditingController(text: 'New Delhi, India');

  final _p2NameController = TextEditingController(text: 'Priya');
  final _p2DobController = TextEditingController(text: '1997-08-20');
  final _p2TimeController = TextEditingController(text: '14:15');
  final _p2PlaceController = TextEditingController(text: 'Mumbai, India');

  late TabController _tabController;

  final List<String> _tabs = [
    'RESULTS',
    'DETAILS',
    'HISTORY',
    'VARNA',
    'VASYA',
    'TARA',
    'YONI',
    'MAITRI',
    'GANA',
    'BHAKOOT',
    'NADI',
  ];

  double totalScore = 28.0;
  String grade = 'Exceptional';
  String manglikStatus = 'Both Non-Manglik (Anukool)';
  String recommendation = 'Highly Auspicious Match';
  String summaryText =
      'Rohan & Priya achieve an authentic Ashtakoota compatibility score of 28.0 out of 36 Gunas (Auspicious Match).';

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
    'Vasya': 2.0,
    'Tara': 3.0,
    'Yoni': 2.0,
    'Maitri': 4.0,
    'Gana': 5.0,
    'Bhakoot': 7.0,
    'Nadi': 8.0,
  };

  @override
  void initState() {
    super.initState();
    // Default to DETAILS tab to match Vedic Milan overview
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 1);

    final active = ref.read(activeProfileProvider);
    if (active.name.isNotEmpty) {
      _p1NameController.text = active.name;
      if (active.dob.isNotEmpty) _p1DobController.text = active.dob;
      if (active.birthTime.isNotEmpty) _p1TimeController.text = active.birthTime;
      if (active.birthPlace.isNotEmpty) _p1PlaceController.text = active.birthPlace;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMatch();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _p1NameController.dispose();
    _p1DobController.dispose();
    _p1TimeController.dispose();
    _p1PlaceController.dispose();

    _p2NameController.dispose();
    _p2DobController.dispose();
    _p2TimeController.dispose();
    _p2PlaceController.dispose();
    super.dispose();
  }

  Future<void> _calculateMatch() async {
    final first = MatchProfile(
      id: 'p1',
      name: _p1NameController.text.trim().isNotEmpty ? _p1NameController.text.trim() : 'Partner 1',
      gender: 'male',
      birthDetails: BirthDetails(
        name: _p1NameController.text.trim(),
        dob: _p1DobController.text.trim().isNotEmpty ? _p1DobController.text.trim() : '1995-01-01',
        birthTime: _p1TimeController.text.trim().isNotEmpty ? _p1TimeController.text.trim() : '12:00',
        birthPlace: _p1PlaceController.text.trim().isNotEmpty ? _p1PlaceController.text.trim() : 'Delhi, India',
        latitude: 28.6139,
        longitude: 77.2090,
      ),
    );

    final second = MatchProfile(
      id: 'p2',
      name: _p2NameController.text.trim().isNotEmpty ? _p2NameController.text.trim() : 'Partner 2',
      gender: 'female',
      birthDetails: BirthDetails(
        name: _p2NameController.text.trim(),
        dob: _p2DobController.text.trim().isNotEmpty ? _p2DobController.text.trim() : '1997-01-01',
        birthTime: _p2TimeController.text.trim().isNotEmpty ? _p2TimeController.text.trim() : '12:00',
        birthPlace: _p2PlaceController.text.trim().isNotEmpty ? _p2PlaceController.text.trim() : 'Mumbai, India',
        latitude: 19.0760,
        longitude: 72.8777,
      ),
    );

    final result = await ref.read(matchmakingProvider.notifier).calculateMatch(
      first: first,
      second: second,
    );

    if (result != null && mounted) {
      _applyResult(result);
    }
  }

  void _applyResult(CompatibilityResult result) {
    setState(() {
      totalScore = result.totalScore;
      summaryText = result.summary;
      manglikStatus = result.manglikStatus;
      recommendation = result.recommendation;

      if (totalScore >= 28) {
        grade = 'Exceptional';
      } else if (totalScore >= 21) {
        grade = 'Good';
      } else if (totalScore >= 18) {
        grade = 'Average';
      } else {
        grade = 'Challenging';
      }

      final Map<String, double> updated = {};
      for (final g in result.gunas) {
        updated[g.kootaName] = g.obtainedScore;
      }
      rawScores = updated;
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime initial = DateTime(1995, 1, 1);
    try {
      final parts = controller.text.split('-');
      if (parts.length == 3) {
        initial = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      }
    } catch (_) {}

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF5A623),
              onPrimary: Colors.black,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      controller.text = formatted;
      _calculateMatch();
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay initial = const TimeOfDay(hour: 12, minute: 0);
    try {
      final parts = controller.text.split(':');
      if (parts.length >= 2) {
        initial = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1].split(' ')[0]));
      }
    } catch (_) {}

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF5A623),
              onPrimary: Colors.black,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      _calculateMatch();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(activeProfileProvider, (previous, next) {
      if (next.name.isNotEmpty && next.name != _p1NameController.text) {
        _p1NameController.text = next.name;
        if (next.dob.isNotEmpty) _p1DobController.text = next.dob;
        if (next.birthTime.isNotEmpty) _p1TimeController.text = next.birthTime;
        if (next.birthPlace.isNotEmpty) _p1PlaceController.text = next.birthPlace;
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
              // ── Top Bar (AstroSaathi Golden Header) ─────────────────
              _buildGoldenAppBar(context),

              // ── Tab Bar (RESULTS, DETAILS, HISTORY, VARNA, VASYA...) ────────
              _buildTabBar(context),

              // ── Tab Views ──────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildResultsTab(context, isLight),
                    _buildDetailsTab(context, isLight),
                    _buildHistoryTab(context, isLight),
                    _buildGunaInfoTab(
                      'Varna (Work & Spiritual Compatibility)',
                      'Maximum Points: 1.0\nObtained: ${rawScores['Varna'] ?? 0.0}\n\n'
                          'Varna indicates mental compatibility and spiritual inclinations. It assesses the intellectual and work attitude harmony between partners.',
                    ),
                    _buildGunaInfoTab(
                      'Vasya (Dominance & Magnetic Attraction)',
                      'Maximum Points: 2.0\nObtained: ${rawScores['Vasya'] ?? 0.0}\n\n'
                          'Vasya represents the degree of mutual influence and magnetic attraction. It reveals whether one partner naturally dominates or if power is shared equally.',
                    ),
                    _buildGunaInfoTab(
                      'Tara (Destiny & Longevity)',
                      'Maximum Points: 3.0\nObtained: ${rawScores['Tara'] ?? 0.0}\n\n'
                          'Tara measures the birth star (Nakshatra) compatibility, determining the mutual prosperity, good fortune, and health longevity in matrimonial life.',
                    ),
                    _buildGunaInfoTab(
                      'Yoni (Mentality & Biological Harmony)',
                      'Maximum Points: 4.0\nObtained: ${rawScores['Yoni'] ?? 0.0}\n\n'
                          'Yoni represents biological attraction, intimate compatibility, and instinctive mutual affection between husband and wife.',
                    ),
                    _buildGunaInfoTab(
                      'Maitri (Friendship & Psychological Compatibility)',
                      'Maximum Points: 5.0\nObtained: ${rawScores['Graha Maitri'] ?? rawScores['Maitri'] ?? 0.0}\n\n'
                          'Graha Maitri evaluates the planetary friendship between Moon sign lords. High points ensure lasting friendship and emotional understanding.',
                    ),
                    _buildGunaInfoTab(
                      'Gana (Temperament & Lifestyle Harmony)',
                      'Maximum Points: 6.0\nObtained: ${rawScores['Gana'] ?? 0.0}\n\n'
                          'Gana classifies human nature into Deva (divine), Manushya (human), and Rakshasa (demonic). Similar ganas ensure domestic peace.',
                    ),
                    _buildGunaInfoTab(
                      'Bhakoot (Love, Family & Financial Prosperity)',
                      'Maximum Points: 7.0\nObtained: ${rawScores['Bhakoot'] ?? 0.0}\n\n'
                          'Bhakoot relates to emotional bonding, child birth, and economic progress. Auspicious alignment creates wealth and harmony.',
                    ),
                    _buildGunaInfoTab(
                      'Nadi (Health, Genetics & Heredity)',
                      'Maximum Points: 8.0\nObtained: ${rawScores['Nadi'] ?? 0.0}\n\n'
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
      color: const Color(0xFFF5A623),
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
            tooltip: 'Share Kundli Milan Result',
            icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 22),
            onPressed: () {
              final text = '✦ AstroSaathi Vedic Milan ✦\n'
                  '${_p1NameController.text} & ${_p2NameController.text}\n'
                  'Compatibility: ${totalScore.toStringAsFixed(1)} / 36.0 Gunas ($grade)\n'
                  'Manglik Status: $manglikStatus\n'
                  'Recommendation: $recommendation\n'
                  'Summary: $summaryText';
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Milan summary copied to clipboard!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Save Match to History',
            icon: const Icon(Icons.bookmark_add_outlined, color: Colors.black87, size: 22),
            onPressed: () async {
              final ok = await ref.read(matchmakingProvider.notifier).saveCurrentMatch();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? 'Match saved to history!' : 'Match already saved.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black87, size: 24),
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'settings') {
                ref.read(mainNavIndexProvider.notifier).state = 4;
              } else if (value == 'history') {
                _tabController.animateTo(2);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history_rounded, size: 20, color: AppColors.getTextPrimary(context)),
                    const SizedBox(width: 12),
                    Text('Match History', style: GoogleFonts.inter(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
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

  /// Guna Milan Result in Detail Table & Score
  Widget _buildDetailsTab(BuildContext context, bool isLight) {
    final keys = ['Varna', 'Vasya', 'Tara', 'Yoni', 'Graha Maitri', 'Gana', 'Bhakoot', 'Nadi'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Guna Milan Result in Detail',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                  label: const Text('Save Match'),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFFF5A623)),
                  onPressed: () async {
                    final ok = await ref.read(matchmakingProvider.notifier).saveCurrentMatch();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ok ? 'Saved to history!' : 'Match already saved')),
                      );
                    }
                  },
                ),
              ],
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
              final lookupKey = key == 'Graha Maitri' ? (rawScores.containsKey('Graha Maitri') ? 'Graha Maitri' : 'Maitri') : key;
              final max = maxScores[key == 'Graha Maitri' ? 'Maitri' : key] ?? 1.0;
              final obtained = rawScores[lookupKey] ?? 0.0;
              final area = areasOfLife[key == 'Graha Maitri' ? 'Maitri' : key] ?? '';
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

          const SizedBox(height: 20),

          // ── Big Score Banner (Score / 36) ──
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
            child: Column(
              children: [
                RichText(
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
                const SizedBox(height: 6),
                Text(
                  '${(totalScore / 36.0 * 100).toStringAsFixed(0)}% Compatibility',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Astrological Verdict Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                  totalScore >= 18 ? '✦ $recommendation' : '⚠ $recommendation',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: totalScore >= 18 ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: manglikStatus.contains('Both Non-Manglik') || manglikStatus.contains('Neutralized')
                      ? const Color(0xFFE3F2FD)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: manglikStatus.contains('Both Non-Manglik') || manglikStatus.contains('Neutralized')
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFFFFB74D),
                  ),
                ),
                child: Text(
                  manglikStatus,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: manglikStatus.contains('Both Non-Manglik') || manglikStatus.contains('Neutralized')
                        ? const Color(0xFF1565C0)
                        : const Color(0xFFE65100),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildResultsTab(BuildContext context, bool isLight) {
    final state = ref.watch(matchmakingProvider);
    final isCalculating = state.currentResult.isLoading;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Partner 1 Inputs
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Partner 1 (Self)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _p1NameController,
                            style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Name',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              filled: true,
                              fillColor: AppColors.getSurfaceSecondary(context),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () => _selectDate(context, _p1DobController),
                            child: IgnorePointer(
                              child: TextField(
                                controller: _p1DobController,
                                style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'YYYY-MM-DD',
                                  prefixIcon: const Icon(Icons.calendar_today, size: 14),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  filled: true,
                                  fillColor: AppColors.getSurfaceSecondary(context),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () => _selectTime(context, _p1TimeController),
                            child: IgnorePointer(
                              child: TextField(
                                controller: _p1TimeController,
                                style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'HH:mm',
                                  prefixIcon: const Icon(Icons.access_time, size: 14),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  filled: true,
                                  fillColor: AppColors.getSurfaceSecondary(context),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                      child: Icon(Icons.favorite_rounded, color: Color(0xFFE91E63), size: 24),
                    ),
                    // Partner 2 Inputs
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Partner 2 (Match)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _p2NameController,
                            style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Name',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              filled: true,
                              fillColor: AppColors.getSurfaceSecondary(context),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () => _selectDate(context, _p2DobController),
                            child: IgnorePointer(
                              child: TextField(
                                controller: _p2DobController,
                                style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'YYYY-MM-DD',
                                  prefixIcon: const Icon(Icons.calendar_today, size: 14),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  filled: true,
                                  fillColor: AppColors.getSurfaceSecondary(context),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () => _selectTime(context, _p2TimeController),
                            child: IgnorePointer(
                              child: TextField(
                                controller: _p2TimeController,
                                style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'HH:mm',
                                  prefixIcon: const Icon(Icons.access_time, size: 14),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  filled: true,
                                  fillColor: AppColors.getSurfaceSecondary(context),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: isCalculating ? null : _calculateMatch,
                    child: isCalculating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                          )
                        : Text('Calculate Authentic Gun Milan', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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
                      scores: rawScores.map((k, v) {
                        final max = maxScores[k == 'Graha Maitri' ? 'Maitri' : k] ?? 1.0;
                        return MapEntry(k == 'Graha Maitri' ? 'Maitri' : k, v / max);
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Summary Text Card
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

  Widget _buildHistoryTab(BuildContext context, bool isLight) {
    final history = ref.watch(matchmakingHistoryProvider);

    if (history.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history_rounded,
        title: 'No Saved Matches',
        description: 'Calculate a match and tap "Save Match" to store and compare profiles here.',
        emoji: '💍',
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final match = history[index];
        final isAuspicious = match.totalScore >= 18;

        return Container(
          decoration: BoxDecoration(
            color: isLight ? Colors.white : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.getGlassBorder(context)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () {
              _applyResult(match);
              _tabController.animateTo(1); // Go to DETAILS
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loaded match for ${match.firstProfile.name} & ${match.secondProfile.name}')),
              );
            },
            title: Text(
              '${match.firstProfile.name} & ${match.secondProfile.name}',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Score: ${match.totalScore.toStringAsFixed(1)} / 36.0 (${match.recommendation})',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isAuspicious ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  match.manglikStatus,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context)),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.grey),
              onPressed: () {
                ref.read(matchmakingProvider.notifier).deleteFromHistory(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Match removed from history')),
                );
              },
            ),
          ),
        );
      },
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
}
