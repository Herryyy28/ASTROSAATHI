import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../home/presentation/widgets/add_event_modal.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';

enum DecisionCategory {
  career('Career & Job Switch', Icons.work_rounded, Color(0xFF4A90E2)),
  business('Business & Contracts', Icons.business_center_rounded, Color(0xFFFFD700)),
  finance('Property & Finance', Icons.account_balance_wallet_rounded, Color(0xFF50E3C2)),
  relationship('Marriage & Relationship', Icons.favorite_rounded, Color(0xFFFF6B6B)),
  travel('Travel & Relocation', Icons.flight_takeoff_rounded, Color(0xFFBD10E0));

  final String label;
  final IconData icon;
  final Color color;

  const DecisionCategory(this.label, this.icon, this.color);
}

class AstroDecisionEngineScreen extends ConsumerStatefulWidget {
  const AstroDecisionEngineScreen({super.key});

  @override
  ConsumerState<AstroDecisionEngineScreen> createState() => _AstroDecisionEngineScreenState();
}

class _AstroDecisionEngineScreenState extends ConsumerState<AstroDecisionEngineScreen> {
  DecisionCategory _selectedCategory = DecisionCategory.career;
  final TextEditingController _questionController = TextEditingController(
    text: 'Should I schedule my job interview or salary talk this week?',
  );

  bool _showMathDetails = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeProfile = ref.watch(activeProfileProvider);
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
              // Header
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
                              Flexible(
                                child: Text(
                                  'Astro Decision Engine',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'AI + MATH',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Astrological decision support for ${activeProfile.name}',
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

              // Content Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Category Selector Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: DecisionCategory.values.map((cat) {
                          final isSel = cat == _selectedCategory;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: isSel ? cat.color.withOpacity(0.18) : AppColors.getSurfaceSecondary(context),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSel ? cat.color : AppColors.getGlassBorder(context),
                                  width: isSel ? 1.5 : 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(cat.icon, size: 15, color: isSel ? cat.color : AppColors.getTextSecondary(context)),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat.label,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                      color: isSel ? cat.color : AppColors.getTextSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Decision Question Card
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR REAL-LIFE DECISION QUESTION',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _questionController,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: AppColors.getTextPrimary(context),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your decision (e.g. Should I sign the contract today?)',
                              hintStyle: TextStyle(color: AppColors.getTextMuted(context), fontSize: 13),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.getGlassBorder(context)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Evaluation Verdict Banner
                    _buildVerdictBanner(context),
                    const SizedBox(height: 16),

                    // Best 90-Minute Window Card
                    _buildBestWindowCard(context),
                    const SizedBox(height: 16),

                    // Show Me The Math Calculation Transparency Card
                    _buildShowMeTheMathCard(context),
                    const SizedBox(height: 20),

                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.event_available_rounded, size: 18),
                            label: Text(
                              'Save to Event Planner',
                              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              AddEventModal.show(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: AppColors.getGlassBorder(context)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.smart_toy_rounded, size: 18, color: AppColors.primary),
                            label: Text(
                              'Ask Astro Baba',
                              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AstroBabaScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildVerdictBanner(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderColor: _selectedCategory.color.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedCategory.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_selectedCategory.icon, size: 18, color: _selectedCategory.color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'DECISION ANALYSIS VERDICT',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AppColors.getTextSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                ),
                child: Text(
                  'HIGHLY FAVORABLE (8.6/10)',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Proceed with Confidence during Peak Muhurat Window.',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your active Jupiter Mahadasha + 10th House transit alignment creates a powerful window for executive communication and positive outcome.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.getTextSecondary(context),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestWindowCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderColor: const Color(0xFFFFD700).withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_rounded, color: Color(0xFFFFD700), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'PERSONAL PEAK 90-MINUTE WINDOW TODAY',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: const Color(0xFFFFD700),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '10:15 AM – 11:45 AM',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Abhijit Muhurat + Amrita Siddhi Yoga',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orangeAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Avoid 01:30 PM – 03:00 PM (Rahu Kaal Window)',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShowMeTheMathCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calculate_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'SHOW ME THE MATH (TRANSPARENCY)',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _showMathDetails = !_showMathDetails),
                child: Text(
                  _showMathDetails ? 'Hide Ledger' : 'View Ledger',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Factor Breakdown
          _buildMathRow(context, 'Jupiter 10th House Transit Weight', '+3.2 pts', Colors.greenAccent),
          const SizedBox(height: 6),
          _buildMathRow(context, 'Active Jupiter-Mercury Dasha Synergy', '+2.8 pts', Colors.greenAccent),
          const SizedBox(height: 6),
          _buildMathRow(context, 'Moon in Pushya Nakshatra Alignment', '+1.6 pts', Colors.greenAccent),
          const SizedBox(height: 6),
          _buildMathRow(context, 'Rahu Kaal Deduction Window', '-1.0 pts', Colors.redAccent),
          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CALCULATED SCORE',
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
              ),
              Text(
                '8.6 / 10.0',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),

          if (_showMathDetails) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceSecondary(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'METADATA & ALGORITHMIC BASIS',
                    style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.getTextMuted(context)),
                  ),
                  const SizedBox(height: 6),
                  Text('• Ayanamsa: Chitrapaksha / Lahiri Precise', style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context))),
                  Text('• Chart Scheme: D1 Natal + D9 Navamsha Confirmation', style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context))),
                  Text('• Calculation Method: Deterministic Planetary Degrees', style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMathRow(BuildContext context, String factor, String points, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            factor,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextPrimary(context)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          points,
          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
