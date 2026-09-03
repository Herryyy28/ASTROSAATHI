import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/widgets/explain_chart_modal.dart';

class TransitCenterScreen extends ConsumerWidget {
  const TransitCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          Text(
                            'Transit & Sade Sati Center',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            'Real-time planetary impact on ${activeProfile.name.isNotEmpty ? activeProfile.name : "Primary Profile"}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // 🪐 Sade Sati Tracker Banner Card
                    _buildSadeSatiCard(context, 'Aquarius (Kumbha)'),
                    const SizedBox(height: 20),

                    // Major Transits Feed Header
                    Text(
                      'ACTIVE PLANETARY TRANSITS (GOCHAR)',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AppColors.getPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Transit Cards List
                    _buildTransitItem(
                      context,
                      planet: 'Jupiter (Guru)',
                      symbol: '♃',
                      transitSign: 'Taurus (Vrishabha)',
                      houseImpact: '11th House of Wealth & Network Gains',
                      status: 'Highly Benefic',
                      statusColor: AppColors.success,
                      description: 'Jupiter aspecting your 11th house expands financial opportunities, social recognition, and career milestones.',
                      advice: 'Initiate major investments or pitch high-value client deals.',
                    ),
                    const SizedBox(height: 12),

                    _buildTransitItem(
                      context,
                      planet: 'Saturn (Shani)',
                      symbol: '♄',
                      transitSign: 'Aquarius (Kumbha)',
                      houseImpact: '10th House of Career & Karma Axis',
                      status: 'Disciplined Growth',
                      statusColor: AppColors.primary,
                      description: 'Saturn tests perseverance in professional leadership. Hard work brings long-lasting authority.',
                      advice: 'Focus on structured execution; avoid shortcuts or conflicts with seniors.',
                    ),
                    const SizedBox(height: 12),

                    _buildTransitItem(
                      context,
                      planet: 'Rahu (North Node)',
                      symbol: '☊',
                      transitSign: 'Pisces (Meena)',
                      houseImpact: '9th House of Higher Learning & Travel',
                      status: 'Transformative',
                      statusColor: AppColors.info,
                      description: 'Rahu drives ambition for international exposure, unconventional learning, and foreign connections.',
                      advice: 'Explore long-distance travel and digital expansion.',
                    ),
                    const SizedBox(height: 12),

                    _buildTransitItem(
                      context,
                      planet: 'Ketu (South Node)',
                      symbol: '☋',
                      transitSign: 'Virgo (Kanya)',
                      houseImpact: '3rd House of Courage & Skill Creation',
                      status: 'Introspective',
                      statusColor: AppColors.warning,
                      description: 'Ketu encourages deep focus on specialized skill mastery and spiritual writing.',
                      advice: 'Practice mindfulness and document your strategic ideas.',
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

  Widget _buildSadeSatiCard(BuildContext context, String moonSign) {
    // Dynamic determination of Sade Sati state
    final isSadeSatiActive = moonSign.contains('Aquarius') || moonSign.contains('Capricorn') || moonSign.contains('Pisces');
    final phaseTitle = moonSign.contains('Aquarius')
        ? 'Phase 2: Peak Phase (Janma Shani)'
        : (moonSign.contains('Capricorn')
            ? 'Phase 3: Setting Phase (Rising out)'
            : (moonSign.contains('Pisces')
                ? 'Phase 1: Rising Phase (Entering)'
                : 'No Active Sade Sati'));

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderColor: isSadeSatiActive ? AppColors.warning.withOpacity(0.5) : AppColors.success.withOpacity(0.5),
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
                        color: (isSadeSatiActive ? AppColors.warning : AppColors.success).withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSadeSatiActive ? Icons.shield_moon_rounded : Icons.verified_user_rounded,
                        color: isSadeSatiActive ? AppColors.warning : AppColors.success,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SATURN SADE SATI STATUS',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.getTextSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            phaseTitle,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                onPressed: () {
                  ExplainChartModal.show(
                    context,
                    term: 'Saturn Sade Sati (7.5 Year Transit Cycle)',
                    title: 'What is Sade Sati?',
                    simpleExplanation: 'Sade Sati is the 7.5-year period when Saturn transits the 12th, 1st, and 2nd houses from your natal Moon sign. It is a period of intense personal maturity, discipline, and karma clearing.',
                    technicalDetail: 'Saturn takes 2.5 years to cross each zodiac sign. Traversing 3 signs (12th sign, Moon sign, 2nd sign) equals 7.5 years.',
                    keyTakeaway: 'Sade Sati rewards discipline, honesty, and hard work. It cleanses weak areas and builds lasting character.',
                    remedy: 'Recite Hanuman Chalisa on Saturdays & light a mustard oil lamp under a Peepal tree.',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.getSurfaceSecondary(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isSadeSatiActive
                        ? 'Saturn is cultivating resilience in your life. Focus on ethical discipline and service.'
                        : 'Your Moon sign ($moonSign) is currently free from Sade Sati. Saturn provides stable support.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitItem(
    BuildContext context, {
    required String planet,
    required String symbol,
    required String transitSign,
    required String houseImpact,
    required String status,
    required Color statusColor,
    required String description,
    required String advice,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
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
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withOpacity(0.18),
                      ),
                      child: Center(
                        child: Text(
                          symbol,
                          style: TextStyle(fontSize: 18, color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planet,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Transiting $transitSign',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withOpacity(0.4)),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // House impact banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.getSurfaceElevated(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '✦ $houseImpact',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.getPrimary(context),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              height: 1.4,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Advice: $advice',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getPrimary(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
