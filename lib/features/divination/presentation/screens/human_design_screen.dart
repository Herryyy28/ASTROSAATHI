import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class HumanDesignScreen extends StatefulWidget {
  const HumanDesignScreen({super.key});

  @override
  State<HumanDesignScreen> createState() => _HumanDesignScreenState();
}

class _HumanDesignScreenState extends State<HumanDesignScreen> {
  int _selectedArchetypeIndex = 0;

  final List<Map<String, dynamic>> _archetypes = [
    {
      'type': 'Manifesting Generator',
      'profile': '5/1 Heretic / Investigator',
      'percentage': '32% of Population',
      'color': Colors.amberAccent,
      'strategy': 'To Respond & Inform before swift action',
      'authority': 'Sacral Authority (Gut Response)',
      'signature': 'Satisfaction & Flow',
      'notSelf': 'Frustration & Anger',
      'definedCenters': 'Head, Ajna, Sacral, Throat (4/9 Defined)',
      'cross': 'Right Angle Cross of Consciousness',
      'description':
          'The multi-passionate visionary builder. Possesses sustainable sacral motor energy coupled with throat initiation. Moves with rapid acceleration, learns through course-correction, and excels when responding to authentic external requests.',
      'centersList': [
        {'name': 'Head / Crown', 'defined': true, 'role': 'Inspiration & Pressure to Know'},
        {'name': 'Ajna Center', 'defined': true, 'role': 'Conceptualization & Mental Framing'},
        {'name': 'Throat Center', 'defined': true, 'role': 'Manifestation & Articulation'},
        {'name': 'G-Center (Identity)', 'defined': false, 'role': 'Open to Direction & Love'},
        {'name': 'Heart / Ego', 'defined': false, 'role': 'Variable Willpower Energy'},
        {'name': 'Sacral Center', 'defined': true, 'role': 'Sustained Life Force & Vitality'},
        {'name': 'Solar Plexus', 'defined': false, 'role': 'Empathetic Emotional Reception'},
        {'name': 'Spleen Center', 'defined': false, 'role': 'Intuitive Body Sensing'},
        {'name': 'Root Center', 'defined': false, 'role': 'Adrenaline & Physical Pressure'},
      ],
    },
    {
      'type': 'Generator',
      'profile': '3/5 Martyr / Heretic',
      'percentage': '36% of Population',
      'color': Colors.orangeAccent,
      'strategy': 'Wait to Respond (Never initiate cold)',
      'authority': 'Sacral Authority (Gut Sounds: Uh-huh / Un-un)',
      'signature': 'Pure Satisfaction & Mastery',
      'notSelf': 'Frustration & Depletion',
      'definedCenters': 'Sacral, Spleen, Root (3/9 Defined)',
      'cross': 'Left Angle Cross of Alignment',
      'description':
          'The steady master craftsman and backbone of the world. Built with deep enduring energy to master skills step-by-step. Finding tasks that light up the sacral gut response turns work into effortless devotion.',
      'centersList': [
        {'name': 'Head / Crown', 'defined': false, 'role': 'Open to Global Wonder'},
        {'name': 'Ajna Center', 'defined': false, 'role': 'Open Mental Flexibility'},
        {'name': 'Throat Center', 'defined': false, 'role': 'Speaks When Prompted'},
        {'name': 'G-Center (Identity)', 'defined': false, 'role': 'Adaptive Sense of Place'},
        {'name': 'Heart / Ego', 'defined': false, 'role': 'Free from Need to Prove'},
        {'name': 'Sacral Center', 'defined': true, 'role': 'Unstoppable Creative Generator'},
        {'name': 'Solar Plexus', 'defined': false, 'role': 'Clear Emotional Baseline'},
        {'name': 'Spleen Center', 'defined': true, 'role': 'Instant Immune & Survival Instincts'},
        {'name': 'Root Center', 'defined': true, 'role': 'Steady Rhythmic Work Drive'},
      ],
    },
    {
      'type': 'Projector',
      'profile': '1/3 Investigator / Martyr',
      'percentage': '21% of Population',
      'color': Colors.cyanAccent,
      'strategy': 'Wait for the Formal Recognition & Invitation',
      'authority': 'Splenic / Intuitive Guidance',
      'signature': 'Success & Masterful Efficiency',
      'notSelf': 'Bitterness & Burnout',
      'definedCenters': 'Ajna, Throat, G-Center (3/9 Defined)',
      'cross': 'Right Angle Cross of the Sphinx',
      'description':
          'The wise seer and guide of human systems. Not designed to toil in heavy manual labor, but rather to observe, direct, and optimize the energy of others. Thrives when genuinely recognized and invited for their perspective.',
      'centersList': [
        {'name': 'Head / Crown', 'defined': false, 'role': 'Receptive to Divine Queries'},
        {'name': 'Ajna Center', 'defined': true, 'role': 'Fixed Analytical Perception'},
        {'name': 'Throat Center', 'defined': true, 'role': 'Authoritative Articulation'},
        {'name': 'G-Center (Identity)', 'defined': true, 'role': 'Magnetic Identity Core'},
        {'name': 'Heart / Ego', 'defined': false, 'role': 'Wise in True Worth'},
        {'name': 'Sacral Center', 'defined': false, 'role': 'Non-Sacral; Needs Rest Cycles'},
        {'name': 'Solar Plexus', 'defined': false, 'role': 'Reflects Others Feelings'},
        {'name': 'Spleen Center', 'defined': false, 'role': 'Senses Health Vulnerabilities'},
        {'name': 'Root Center', 'defined': false, 'role': 'Refuses Rush and False Hurry'},
      ],
    },
    {
      'type': 'Manifestor',
      'profile': '2/4 Hermit / Opportunist',
      'percentage': '9% of Population',
      'color': Colors.redAccent,
      'strategy': 'To Inform Others Before Taking Action',
      'authority': 'Emotional Solar Plexus (Wait for wave clarity)',
      'signature': 'Deep Inner Peace & Autonomy',
      'notSelf': 'Anger & Resentment at Control',
      'definedCenters': 'Throat, Heart/Ego, Root (3/9 Defined)',
      'cross': 'Left Angle Cross of Demands',
      'description':
          'The sovereign trailblazer and initiator. The only type biologically designed to spark new paradigms without waiting for permission. Informing loved ones and colleagues beforehand dissolves obstacles and resistance.',
      'centersList': [
        {'name': 'Head / Crown', 'defined': false, 'role': 'Unfiltered Inspiration Stream'},
        {'name': 'Ajna Center', 'defined': false, 'role': 'Unconditioned Cognitive Flow'},
        {'name': 'Throat Center', 'defined': true, 'role': 'Spontaneous Creative Catalyst'},
        {'name': 'G-Center (Identity)', 'defined': false, 'role': 'Fluid Adaptable Essence'},
        {'name': 'Heart / Ego', 'defined': true, 'role': 'Iron Willpower & Command'},
        {'name': 'Sacral Center', 'defined': false, 'role': 'Sprint & Rest Cadence'},
        {'name': 'Solar Plexus', 'defined': false, 'role': 'Calm Detached Insight'},
        {'name': 'Spleen Center', 'defined': false, 'role': 'Sensitive to Environments'},
        {'name': 'Root Center', 'defined': true, 'role': 'High-Impact Burst Generator'},
      ],
    },
    {
      'type': 'Reflector',
      'profile': '6/2 Role Model / Hermit',
      'percentage': '1% of Population (Ultra Rare)',
      'color': Colors.purpleAccent,
      'strategy': 'Wait a Full 28-Day Lunar Cycle for major decisions',
      'authority': 'Lunar Ephemeris Authority',
      'signature': 'Childlike Surprise & Wonder',
      'notSelf': 'Disappointment with Community',
      'definedCenters': 'Completely Open (0/9 Defined)',
      'cross': 'Right Angle Cross of the Vessel of Love',
      'description':
          'The cosmic barometer and sacred mirror. With all nine centers open to the cosmos, the Reflector samples and reflects the purity, toxicity, or harmony of their environment. Decisions require patient communion with the moon.',
      'centersList': [
        {'name': 'Head / Crown', 'defined': false, 'role': 'Open Cosmic Gateway'},
        {'name': 'Ajna Center', 'defined': false, 'role': 'Open Holographic Mind'},
        {'name': 'Throat Center', 'defined': false, 'role': 'Voice of the Whole Tribe'},
        {'name': 'G-Center (Identity)', 'defined': false, 'role': 'Chameleon Soul of Places'},
        {'name': 'Heart / Ego', 'defined': false, 'role': 'Open to Divine Sovereignty'},
        {'name': 'Sacral Center', 'defined': false, 'role': 'Open Life Force Well'},
        {'name': 'Solar Plexus', 'defined': false, 'role': 'Vast Ocean of Empathy'},
        {'name': 'Spleen Center', 'defined': false, 'role': 'Cellular Environmental Antenna'},
        {'name': 'Root Center', 'defined': false, 'role': 'Open Rhythmic Vessel'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final current = _archetypes[_selectedArchetypeIndex];
    final Color currentAccent = current['color'] as Color;

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
              // Header App Bar
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
                                  'Human Design Matrix',
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
                                  color: Colors.amberAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
                                ),
                                child: Text(
                                  'EDUCATIONAL',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '5 Core Bio-Energetic Archetypes & Strategies',
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

              // Educational Notice Banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Full 64-gate natal BodyGraphs require exact UTC coordinates & I Ching ephemeris. Explore the 5 foundational archetypes below:',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.getTextSecondary(context),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Archetype Selector Chips
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: _archetypes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = _archetypes[index];
                    final isSelected = index == _selectedArchetypeIndex;
                    final Color color = item['color'] as Color;

                    return ChoiceChip(
                      label: Text(
                        item['type'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.black : AppColors.getTextPrimary(context),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: color,
                      backgroundColor: AppColors.getSurfaceSecondary(context),
                      side: BorderSide(
                        color: isSelected ? color : AppColors.getBorder(context),
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedArchetypeIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),

              // Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Main Archetype Card
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      borderColor: currentAccent.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ARCHETYPE BLUEPRINT',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: currentAccent,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: currentAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  current['percentage'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: currentAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            current['type'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            current['profile'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            current['description'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              height: 1.45,
                              color: AppColors.getTextPrimary(context).withOpacity(0.9),
                            ),
                          ),
                          Divider(color: AppColors.getDivider(context), height: 24),
                          _buildDetailRow(context, 'Core Strategy', current['strategy'] as String),
                          _buildDetailRow(context, 'Inner Authority', current['authority'] as String),
                          _buildDetailRow(context, 'Emotional Signature', current['signature'] as String),
                          _buildDetailRow(context, 'Not-Self Theme', current['notSelf'] as String),
                          _buildDetailRow(context, 'Defined Centers', current['definedCenters'] as String),
                          _buildDetailRow(context, 'Archetypal Cross', current['cross'] as String),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 9 Energy Centers Matrix
                    Text(
                      '✦ 9 Centers Energy Configuration',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...((current['centersList'] as List<Map<String, dynamic>>).map((center) {
                      final bool isDefined = center['defined'] as bool;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceSecondary(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDefined ? currentAccent.withOpacity(0.4) : AppColors.getBorder(context),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isDefined ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                              color: isDefined ? currentAccent : AppColors.getTextMuted(context),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        center['name'] as String,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getTextPrimary(context),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: (isDefined ? currentAccent : Colors.grey).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isDefined ? 'DEFINED' : 'OPEN',
                                          style: GoogleFonts.outfit(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: isDefined ? currentAccent : AppColors.getTextMuted(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    center['role'] as String,
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
                      );
                    })),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String key, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              key,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              val,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
