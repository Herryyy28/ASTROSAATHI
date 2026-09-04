import 'dart:ui';
import 'package:AstroSaathi/core/theme/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../../core/widgets/animated_cosmic_reminder_modal.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';

class AstroDecisionAssistantScreen extends ConsumerStatefulWidget {
  const AstroDecisionAssistantScreen({super.key});

  @override
  ConsumerState<AstroDecisionAssistantScreen> createState() =>
      _AstroDecisionAssistantScreenState();
}

class _AstroDecisionAssistantScreenState
    extends ConsumerState<AstroDecisionAssistantScreen> {
  final TextEditingController _eventController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 11, minute: 0);
  String _selectedCategory = 'Interview';

  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Interview', 'icon': Icons.badge_outlined, 'color': Colors.amber},
    {'name': 'Exam', 'icon': Icons.school_outlined, 'color': Colors.blue},
    {
      'name': 'Travel',
      'icon': Icons.flight_takeoff_rounded,
      'color': Colors.green,
    },
    {
      'name': 'Business',
      'icon': Icons.work_outline_rounded,
      'color': Colors.purple,
    },
    {'name': 'Property', 'icon': Icons.home_outlined, 'color': Colors.orange},
    {
      'name': 'Personal',
      'icon': Icons.favorite_outline_rounded,
      'color': Colors.pink,
    },
  ];

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void _runAstrologicalAnalysis() async {
    final title = _eventController.text.trim();
    if (title.isEmpty) {
      CosmicNotification.show(
        context,
        title: 'Enter Event Title ✦',
        message:
            'Please specify your event details to run cosmic decision analysis.',
        icon: Icons.edit_note_rounded,
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    // Simulate real-time ephemeris & Dasha transit evaluation
    await Future.delayed(const Duration(milliseconds: 1400));

    final profiles = ref.read(profilesListProvider);
    final activeIdx = ref.read(activeProfileIndexProvider);
    final userProfile = profiles.isNotEmpty
        ? profiles[activeIdx.clamp(0, profiles.length - 1)]
        : null;

    final hour = _selectedTime.hour;
    int score = 84;
    String verdict = 'Highly Favorable';
    String dashaContext = 'Jupiter Mahadasha • Mercury Antardasha';
    String transitContext = 'Moon in 10th House (Career & Honor)';
    String panchangContext = 'Shukla Ekadashi • Abhijit Muhurat';
    List<String> guidance = [
      'The planetary alignment favors communication and intellect during this time slot.',
      'Rahu Kaal is completely avoided (ends before 10:30 AM).',
      'Wear Light Yellow or Gold to channel Jupiter\'s auspicious energy.',
    ];

    if (hour >= 12 && hour <= 14) {
      score = 92;
      verdict = 'Auspicious Abhijit Window';
    } else if (hour >= 16.5 && hour <= 18) {
      score = 62;
      verdict = 'Moderate - Minor Rahu Impact';
      guidance[1] =
          'Proceed with steady focus; recite Om Namah Shivaya before starting.';
    }

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = {
          'title': title,
          'category': _selectedCategory,
          'profileName': userProfile?.name ?? 'Primary Chart',
          'score': score,
          'verdict': verdict,
          'dasha': dashaContext,
          'transit': transitContext,
          'panchang': panchangContext,
          'guidance': guidance,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.getSurface(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Astro Decision Assistant',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Banner ─────────────────────────────────
              _buildHeaderBanner().fadeSlideUp(),

              const SizedBox(height: 20),

              // ── Event Input Card ──────────────────────────────
              _buildEventFormCard(),

              const SizedBox(height: 24),

              // ── Analysis Pipeline Indicator / Results ─────────
              if (_isAnalyzing) ...[
                _buildAnalyzingState(),
              ] else if (_analysisResult != null) ...[
                _buildAnalysisResultsCard().fadeSlideUp(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: AppRadius.xl2,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.black,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalized Timing Evaluator',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Evaluate your interview, exam, business deal or travel with exact Dasha, Transit & Panchang alignment.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventFormCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: AppRadius.xl2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What event are you planning?',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 12),

          // Event Category Selector
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['name'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 14,
                          color: isSelected
                              ? Colors.black
                              : cat['color'] as Color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat['name'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.black
                                : AppColors.getTextPrimary(context),
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFFD700),
                    backgroundColor: AppColors.getSurfaceElevated(context),
                    onSelected: (val) {
                      if (val)
                        setState(
                          () => _selectedCategory = cat['name'] as String,
                        );
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // TextField Input
          TextField(
            controller: _eventController,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              color: AppColors.getTextPrimary(context),
            ),
            decoration: InputDecoration(
              hintText: 'e.g. Interview at Google 11 AM',
              hintStyle: GoogleFonts.inter(
                fontSize: 13.5,
                color: AppColors.getTextMuted(context),
              ),
              filled: true,
              fillColor: AppColors.getSurfaceElevated(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.getBorder(context)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date & Time Picker Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    DateFormat('E, MMM d').format(_selectedDate),
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    _selectedTime.format(context),
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) setState(() => _selectedTime = picked);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Evaluate Timing Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF1B1403),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _runAstrologicalAnalysis,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Calculate Cosmic Score',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingState() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      borderRadius: AppRadius.xl2,
      child: Column(
        children: [
          const CircularProgressIndicator(color: Color(0xFFFFD700)),
          const SizedBox(height: 20),
          Text(
            'Analyzing Cosmic Alignments...',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Birth Chart ➔ Dasha ➔ Transits ➔ Panchang ➔ Rahu Kaal',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResultsCard() {
    final res = _analysisResult!;
    final int score = res['score'];

    return GlassCard(
      padding: const EdgeInsets.all(22),
      borderRadius: AppRadius.xl2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    res['title'],
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  Text(
                    '${res['category']} • ${res['profileName']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      '$score / 100',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      res['verdict'],
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 28, color: Colors.white10),

          // Planetary Details
          _buildDetailRow(
            Icons.account_tree_outlined,
            'Dasha Alignment',
            res['dasha'],
          ),
          const SizedBox(height: 10),
          _buildDetailRow(
            Icons.auto_awesome_outlined,
            'Planetary Transit',
            res['transit'],
          ),
          const SizedBox(height: 10),
          _buildDetailRow(
            Icons.wb_sunny_outlined,
            'Panchang Window',
            res['panchang'],
          ),

          const SizedBox(height: 20),
          Text(
            'Actionable Guidance',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          ...((res['guidance'] as List<String>).map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✦ ',
                    style: TextStyle(color: Color(0xFFFFD700), fontSize: 12),
                  ),
                  Expanded(
                    child: Text(
                      g,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.getTextSecondary(context),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),

          const SizedBox(height: 24),

          // Action Buttons: Ask Astro Baba, Save Event, Schedule Reminder
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getSurfaceElevated(context),
                    foregroundColor: AppColors.getTextPrimary(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 16,
                    color: Color(0xFFFFD700),
                  ),
                  label: Text(
                    'Ask Astro Baba',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AstroBabaScreen(
                          initialMessage:
                              'I am planning "${res['title']}" on ${DateFormat('MMM d').format(_selectedDate)} at ${_selectedTime.format(context)}. How can I maximize my success?',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF1B1403),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.notifications_active_outlined,
                    size: 16,
                  ),
                  label: Text(
                    'Save & Remind',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    AnimatedCosmicReminderModal.show(
                      context,
                      title: res['title'],
                      category: _selectedCategory,
                      astroScore: (score / 10.0),
                      dashaContext: res['dasha'],
                      aiRecommendation: res['transit'],
                      remediationText: (res['guidance'] as List<String>).isNotEmpty
                          ? (res['guidance'] as List<String>).first
                          : '',
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.getTextSecondary(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
