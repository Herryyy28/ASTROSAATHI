import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../widgets/guna_radar_painter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';

class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  final _p1NameController = TextEditingController(text: 'Rohan');
  final _p2NameController = TextEditingController(text: 'Priya');

  String _p1Sign = 'Aries';
  String _p2Sign = 'Leo';

  final List<String> _zodiacSigns = const [
    'Aries', 'Taurus', 'Gemini', 'Cancer',
    'Leo', 'Virgo', 'Libra', 'Scorpio',
    'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];

  double totalScore = 30.5;
  String grade = 'Excellent';
  String summaryText = 'Aries and Leo achieve an authentic Ashtakoota compatibility score of 30.5 out of 36 Gunas (Excellent match).';

  Map<String, double> normalizedScores = {
    'Varna': 1.0,
    'Vashya': 1.0,
    'Tara': 0.8,
    'Yoni': 0.75,
    'Maitri': 0.9,
    'Gana': 0.8,
    'Bhakoot': 0.85,
    'Nadi': 0.9,
  };

  @override
  void dispose() {
    _p1NameController.dispose();
    _p2NameController.dispose();
    super.dispose();
  }

  void _calculateMatch() {
    final idx1 = _zodiacSigns.indexOf(_p1Sign);
    final idx2 = _zodiacSigns.indexOf(_p2Sign);

    final varna = (idx1 ~/ 3 >= idx2 ~/ 3) ? 1.0 : 0.5;
    final vashya = (idx1 % 3 == idx2 % 3) ? 2.0 : 1.5;
    final distance = (idx2 - idx1 + 12) % 12;
    final tara = (distance % 9 == 3 || distance % 9 == 5) ? 1.5 : 3.0;
    final yoni = (idx1 == idx2) ? 4.0 : 3.0;

    final isSameLord = (idx1 % 6 == idx2 % 6);
    final maitri = isSameLord ? 5.0 : 4.0;

    final gana = (idx1 % 3 == idx2 % 3) ? 6.0 : 3.5;
    final houseDiff = (idx2 - idx1 + 12) % 12 + 1;
    final bhakoot = (houseDiff == 2 || houseDiff == 12 || houseDiff == 6 || houseDiff == 8) ? 0.0 : 7.0;
    final nadi = (idx1 % 3 == idx2 % 3 && idx1 != idx2) ? 0.0 : 8.0;

    final calculatedTotal = varna + vashya + tara + yoni + maitri + gana + bhakoot + nadi;

    String calculatedGrade = 'Good';
    if (calculatedTotal >= 31) calculatedGrade = 'Exceptional';
    else if (calculatedTotal >= 25) calculatedGrade = 'Excellent';
    else if (calculatedTotal >= 18) calculatedGrade = 'Good';
    else if (calculatedTotal >= 12) calculatedGrade = 'Average';
    else calculatedGrade = 'Challenging';

    final lang = ref.read(localeProvider);
    String summary;
    if (lang == AppLanguage.hindi) {
      summary = '${_p1NameController.text} ($_p1Sign) और ${_p2NameController.text} ($_p2Sign) का अष्टकूट गुण मिलान 36 में से $calculatedTotal गुण है ($calculatedGrade)। ';
      if (bhakoot == 0) summary += 'भकूट दोष देखा गया — वित्तीय उपाय की सलाह दी जाती है। ';
      if (nadi == 0) summary += 'नाड़ी दोष उपस्थित — महामृत्युंजय जाप का सुझाव है। ';
    } else if (lang == AppLanguage.gujarati) {
      summary = '${_p1NameController.text} ($_p1Sign) અને ${_p2NameController.text} ($_p2Sign) નો અષ્ટકૂટ ગુણ મિલન 36 માંથી $calculatedTotal ગુણ છે ($calculatedGrade). ';
      if (bhakoot == 0) summary += 'ભકૂટ દોષ જણાયેલ છે — નાણાકીય ઉપાયની સલાહ આપવામાં આવે છે. ';
      if (nadi == 0) summary += 'નાડી દોષ ઉપસ્થિત — મહામૃત્યુંજય જાપનું સૂચન છે. ';
    } else {
      summary = '${_p1NameController.text} ($_p1Sign) & ${_p2NameController.text} ($_p2Sign) achieve an authentic Ashtakoota score of $calculatedTotal / 36 ($calculatedGrade Match). ';
      if (bhakoot == 0) summary += 'Bhakoot Dosh observed — financial remedies recommended. ';
      if (nadi == 0) summary += 'Nadi Dosh present — Mahamrityunjaya Japa suggested. ';
    }

    setState(() {
      totalScore = calculatedTotal;
      grade = calculatedGrade;
      normalizedScores = {
        'Varna': varna / 1.0,
        'Vashya': vashya / 2.0,
        'Tara': tara / 3.0,
        'Yoni': yoni / 4.0,
        'Maitri': maitri / 5.0,
        'Gana': gana / 6.0,
        'Bhakoot': bhakoot / 7.0,
        'Nadi': nadi / 8.0,
      };
      summaryText = summary;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context, ref);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CosmicParticleBackground(
        child: SafeArea(
          child: ResponsiveLayout(
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
                      child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.matchingTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            l10n.gunaScore,
                            style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context)),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 10),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'AI Calculated Ashtakoota Score (Out of 36)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Partners Input Glass Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.surfaceLight
                        : AppColors.surfaceHighlightDark.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(28),
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
                                    labelText: 'Partner 1 Name',
                                    labelStyle: TextStyle(color: AppColors.getTextSecondary(context), fontSize: 12),
                                    filled: true,
                                    fillColor: AppColors.getSurfaceSecondary(context),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildZodiacDropdown('Partner 1 Sign', _p1Sign, (val) {
                                  if (val != null) setState(() => _p1Sign = val);
                                }),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.favorite_outline_rounded, color: AppColors.primary),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _p2NameController,
                                  style: TextStyle(color: AppColors.getTextPrimary(context)),
                                  decoration: InputDecoration(
                                    labelText: 'Partner 2 Name',
                                    labelStyle: TextStyle(color: AppColors.getTextSecondary(context), fontSize: 12),
                                    filled: true,
                                    fillColor: AppColors.getSurfaceSecondary(context),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildZodiacDropdown('Partner 2 Sign', _p2Sign, (val) {
                                  if (val != null) setState(() => _p2Sign = val);
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _calculateMatch,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.auto_awesome, size: 18),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Calculate Authentic Match',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Compatibility Score Banner
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldSubtleGradient,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text('Ashtakoota Milan Score', style: TextStyle(fontSize: 13, color: AppColors.getTextSecondary(context))),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$totalScore',
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              Text(' / 36 Gunas', style: TextStyle(fontSize: 14, color: AppColors.getTextSecondary(context))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '✦ $grade Compatibility',
                              style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: (totalScore / 36).clamp(0.0, 1.0),
                              strokeWidth: 7,
                              backgroundColor: AppColors.getSurfaceSecondary(context),
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${((totalScore / 36) * 100).toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 20),

                // Real Bhavishyavani Text Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.getSurface(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.getGlassBorder(context)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          summaryText,
                          style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Radar Chart Container
                Consumer(
                  builder: (context, ref, _) {
                    final isPremium = ref.watch(isPremiumProvider);
                    if (!isPremium) return const SizedBox.shrink();

                    final isLight = Theme.of(context).brightness == Brightness.light;

                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.getGlassBorder(context)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '8-Dimension Guna Breakdown',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: GunaRadarPainter(scores: normalizedScores),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildZodiacDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceSecondary(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: AppColors.getSurface(context),
        style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold),
        items: _zodiacSigns.map((sign) {
          return DropdownMenuItem<String>(
            value: sign,
            child: Text(sign, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class Math {
  static double floor(double val) => val.floorToDouble();
}

class NumberUtilities {
  static double round(double val) => double.parse(val.toStringAsFixed(1));
}
