import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class AstrocartographyScreen extends StatefulWidget {
  const AstrocartographyScreen({super.key});

  @override
  State<AstrocartographyScreen> createState() => _AstrocartographyScreenState();
}

class _AstrocartographyScreenState extends State<AstrocartographyScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _cities = [
    {
      'city': 'Dubai, UAE',
      'line': 'Jupiter Midheaven (MC) Line',
      'category': 'Career (MC)',
      'vibe': 'Expansive & Prosperous',
      'career': 'Accelerated executive growth, financial scale & leadership prominence.',
      'relationship': 'High-net-worth international networking and commercial circles.',
      'advice': 'Ideal for launching ventures, seeking capital, or scaling business footprint.',
      'color': const Color(0xFF00B0FF),
    },
    {
      'city': 'London, UK',
      'line': 'Mercury Ascendant Line',
      'category': 'Knowledge (Asc)',
      'vibe': 'Intellectual & Dynamic',
      'career': 'High intellectual output, academic research, publishing & digital media.',
      'relationship': 'Stimulating conversations, literary circles, and witty friendships.',
      'advice': 'Exceptional location for writing, broadcasting, study, and negotiations.',
      'color': const Color(0xFF00E676),
    },
    {
      'city': 'Toronto, Canada',
      'line': 'Venus Descendant (DC) Line',
      'category': 'Love & Peace (DC)',
      'vibe': 'Harmonic & Diplomatic',
      'career': 'Thrives in creative partnerships, design agencies, and civic consensus.',
      'relationship': 'Warm community reception, marriage prospects, and peaceful domestic life.',
      'advice': 'Wonderful for emotional balance, settling down, and collaborative contracts.',
      'color': const Color(0xFFFFD54F),
    },
    {
      'city': 'Tokyo, Japan',
      'line': 'Mars Imum Coeli (IC) Line',
      'category': 'Ambition (IC)',
      'vibe': 'Rigorous & Driven',
      'career': 'Intense focus on craftsmanship, technical mastery, and discipline.',
      'relationship': 'Fast-paced, task-oriented connections with clear boundaries.',
      'advice': 'Great for immersive sprints or physical fitness; maintain deliberate rest.',
      'color': const Color(0xFFFF5252),
    },
    {
      'city': 'New York City, USA',
      'line': 'Sun Midheaven (MC) Line',
      'category': 'Career (MC)',
      'vibe': 'Radiant & High-Visibility',
      'career': 'Commands center stage; effortless personal branding and authority recognition.',
      'relationship': 'Dynamic social calendar; connections with influential figures.',
      'advice': 'Magnifies personal charisma; step into leadership roles without hesitation.',
      'color': const Color(0xFFFFAB00),
    },
    {
      'city': 'Singapore',
      'line': 'Jupiter & Mercury Conjunction Line',
      'category': 'Career (MC)',
      'vibe': 'Strategic & Efficient',
      'career': 'Cross-border commerce, strategic investment, fintech and operations excellence.',
      'relationship': 'Cosmopolitan, ambitious, and highly organized peer groups.',
      'advice': 'Harness this meridian for structured wealth preservation and global trade.',
      'color': const Color(0xFF69F0AE),
    },
    {
      'city': 'Mumbai, India',
      'line': 'Moon Ascendant & Venus Line',
      'category': 'Love & Peace (DC)',
      'vibe': 'Expressive & Heart-Centered',
      'career': 'Mass communication, arts, media production, hospitality and cuisine.',
      'relationship': 'Deep emotional bonding, family ties, and vibrant celebratory culture.',
      'advice': 'Engage authentic creative intuition and trust your instincts in partnerships.',
      'color': const Color(0xFFE040FB),
    },
    {
      'city': 'Sydney, Australia',
      'line': 'Sun & Uranus Trine Line',
      'category': 'Ambition (IC)',
      'vibe': 'Innovative & Vital',
      'career': 'Clean tech, maritime industry, fitness, and unconventional entrepreneurial paths.',
      'relationship': 'Active outdoorsy friends, freedom-oriented bonds, and spontaneous fun.',
      'advice': 'Embrace lifestyle transformation, innovative hobbies, and fresh horizons.',
      'color': const Color(0xFF40C4FF),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = AppColors.getTextPrimary(context);

    final filteredCities = _cities.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          (item['city'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item['line'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        title: Text(
          'Astrocartography & Relocation',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Honest Disclaimer Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.public_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'True Astro*Carto*Graphy requires high-precision angularity recalculation for exact birth time. Below is an educational archetype guide for major metropolitan power lines.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.getTextSecondary(context),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Meridian Line Reference Guide
            GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✦ THE 4 CARDINAL ASTROCARTOGRAPHY ANGLES',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAngleRow('MC (Midheaven)', 'Career culmination, reputation & worldly success', context),
                  _buildAngleRow('Asc (Ascendant)', 'Physical vitality, personality projection & fresh starts', context),
                  _buildAngleRow('DC (Descendant)', 'Relationships, marriages, business partnerships & harmony', context),
                  _buildAngleRow('IC (Imum Coeli)', 'Home foundation, family roots & inner emotional security', context),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              style: GoogleFonts.inter(fontSize: 13, color: primaryTextColor),
              decoration: InputDecoration(
                hintText: 'Search city or planetary line...',
                hintStyle: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextMuted(context)),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.getSurface(context),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.getBorder(context)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.getBorder(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Category Filter Chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['All', 'Career (MC)', 'Love & Peace (DC)', 'Knowledge (Asc)', 'Ambition (IC)']
                    .map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: GoogleFonts.outfit(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.black : primaryTextColor,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.getSurfaceSecondary(context),
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.getBorder(context)),
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // City Results Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '✦ City Relocation Archetypes (${filteredCities.length})',
                  style: GoogleFonts.outfit(
                    color: primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_selectedCategory != 'All' || _searchQuery.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _selectedCategory = 'All';
                        _searchQuery = '';
                      });
                    },
                    child: Text('Reset', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.primary)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (filteredCities.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Text(
                  'No cities found matching your filter.\nTry clearing the search query.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.getTextSecondary(context)),
                ),
              ),

            // Filtered City Cards
            ...filteredCities.map((c) {
              final Color col = c['color'] as Color;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: col.withOpacity(0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          c['city'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: col.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c['vibe'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: col,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dominant Meridian: ${c['line']}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: col,
                      ),
                    ),
                    Divider(color: AppColors.getDivider(context), height: 18),
                    _buildRow('💼 Career Impact:', c['career'] as String, context),
                    const SizedBox(height: 6),
                    _buildRow('💞 Relationships:', c['relationship'] as String, context),
                    const SizedBox(height: 6),
                    _buildRow('🧭 Relocation Key:', c['advice'] as String, context),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAngleRow(String angle, String desc, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              angle,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              desc,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String val, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 115,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextMuted(context),
            ),
          ),
        ),
        Expanded(
          child: Text(
            val,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextPrimary(context),
            ),
          ),
        ),
      ],
    );
  }
}
