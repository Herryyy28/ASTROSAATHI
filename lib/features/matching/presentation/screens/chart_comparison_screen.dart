import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/widgets/explain_chart_modal.dart';

enum RelationshipType {
  couple('Couple', Icons.favorite_rounded, Color(0xFFE5A63C)),
  friendship('Friendship', Icons.groups_rounded, Color(0xFF45A77D)),
  parentChild('Parent / Child', Icons.family_restroom_rounded, Color(0xFF70A0D4)),
  siblings('Siblings', Icons.people_rounded, Color(0xFFD6A044)),
  business('Business Partners', Icons.handshake_rounded, Color(0xFFD9901A));

  final String label;
  final IconData icon;
  final Color color;

  const RelationshipType(this.label, this.icon, this.color);
}

class ChartComparisonScreen extends ConsumerStatefulWidget {
  const ChartComparisonScreen({super.key});

  @override
  ConsumerState<ChartComparisonScreen> createState() => _ChartComparisonScreenState();
}

class _ChartComparisonScreenState extends ConsumerState<ChartComparisonScreen> {
  RelationshipType _selectedType = RelationshipType.couple;
  BirthProfileData? _profile1;
  BirthProfileData? _profile2;

  @override
  void initState() {
    super.initState();
    final profiles = ref.read(profilesListProvider);
    if (profiles.isNotEmpty) {
      _profile1 = profiles.firstWhere((p) => p.isPrimary, orElse: () => profiles.first);
      if (profiles.length > 1) {
        _profile2 = profiles.firstWhere((p) => p.id != _profile1?.id, orElse: () => profiles.last);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profilesListProvider);
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
              // App Bar Header
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
                            'Chart Comparison & Synastry',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            'Compare any two profiles across relationship types',
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

              // Scrollable Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Profile Selectors Dropdowns Card
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SELECT PROFILES TO COMPARE',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.getPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Profile 1 Picker
                              Expanded(
                                child: _buildProfileDropdown(
                                  context,
                                  label: 'Person 1',
                                  selected: _profile1,
                                  profiles: profiles,
                                  onChanged: (p) => setState(() => _profile1 = p),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
                              ),
                              // Profile 2 Picker
                              Expanded(
                                child: _buildProfileDropdown(
                                  context,
                                  label: 'Person 2',
                                  selected: _profile2,
                                  profiles: profiles,
                                  onChanged: (p) => setState(() => _profile2 = p),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Relationship Dynamic Type Chips
                    Text(
                      'RELATIONSHIP DYNAMIC',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: RelationshipType.values.map((type) {
                          final isSel = type == _selectedType;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedType = type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? type.color.withOpacity(0.2) : AppColors.getSurfaceSecondary(context),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSel ? type.color : AppColors.getGlassBorder(context),
                                  width: isSel ? 1.5 : 0.6,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(type.icon, size: 14, color: isSel ? type.color : AppColors.getTextSecondary(context)),
                                  const SizedBox(width: 6),
                                  Text(
                                    type.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                      color: isSel ? type.color : AppColors.getTextSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Synastry Compatibility Score Banner
                    _buildCompatibilityScoreBanner(context),
                    const SizedBox(height: 16),

                    // Category Breakdown Metrics
                    _buildMetricCard(context, title: 'Communication Harmony', score: 8.8, icon: Icons.forum_rounded, text: 'Strong Mercurial resonance. Excellent intellectual understanding.'),
                    const SizedBox(height: 10),
                    _buildMetricCard(context, title: 'Emotional & Mental Depth', score: 8.2, icon: Icons.favorite_border_rounded, text: 'Harmonious Moon sign element trine (Water-Earth alignment).'),
                    const SizedBox(height: 10),
                    _buildMetricCard(context, title: 'Shared Values & Long-term Goals', score: 9.0, icon: Icons.flag_rounded, text: 'Jupiter transits favor long-term mutual growth and trust.'),
                    const SizedBox(height: 10),
                    _buildMetricCard(context, title: 'Potential Friction & Conflict Areas', score: 6.5, icon: Icons.warning_amber_rounded, text: 'Mars placement suggests occasional hasty decisions; practice patience.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDropdown(
    BuildContext context, {
    required String label,
    required BirthProfileData? selected,
    required List<BirthProfileData> profiles,
    required ValueChanged<BirthProfileData?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceSecondary(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getGlassBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: AppColors.getTextMuted(context))),
          DropdownButtonHideUnderline(
            child: DropdownButton<BirthProfileData>(
              value: selected,
              isExpanded: true,
              dropdownColor: AppColors.getSurfaceElevated(context),
              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
              items: profiles.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p.name.isNotEmpty ? p.name : 'Unnamed Profile', overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityScoreBanner(BuildContext context) {
    const overallScore = 8.6;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderColor: _selectedType.color.withOpacity(0.5),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldGradient,
              boxShadow: AppColors.goldGlowShadow,
            ),
            child: Center(
              child: Text(
                '$overallScore',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_selectedType.icon, size: 16, color: _selectedType.color),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${_selectedType.label} Compatibility',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _selectedType.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'High Cosmic Alignment! Excellent synergy for mutual support and collaboration.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required double score,
    required IconData icon,
    required String text,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(score * 10).toInt()}%',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 10.0,
              backgroundColor: AppColors.getSurfaceSecondary(context),
              color: AppColors.primary,
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
