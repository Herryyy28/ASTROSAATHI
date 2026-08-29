import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AstrologySearchScreen extends StatefulWidget {
  const AstrologySearchScreen({super.key});

  @override
  State<AstrologySearchScreen> createState() => _AstrologySearchScreenState();
}

class _AstrologySearchScreenState extends State<AstrologySearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Rashi',
    'Planet',
    'Nakshatra',
    'Bhava',
    'Yoga',
    'Dasha',
    'Panchang',
    'Muhurat',
  ];

  final List<Map<String, String>> _knowledgeBase = [
    {
      'term': 'Sun (Surya)',
      'category': 'Planet',
      'description': 'Represents the soul (Atma), authority, father, vitality, and willpower in Vedic astrology.'
    },
    {
      'term': 'Moon (Chandra)',
      'category': 'Planet',
      'description': 'Governs emotions, mind (Manas), mother, public interaction, and mental peace.'
    },
    {
      'term': 'Mesha (Aries)',
      'category': 'Rashi',
      'description': 'First sign of the Zodiac, ruled by Mars. Symbolizes initiative, leadership, and courage.'
    },
    {
      'term': 'Rohini Nakshatra',
      'category': 'Nakshatra',
      'description': '4th Nakshatra ruled by Moon. Associated with creation, beauty, prosperity, and magnetic charm.'
    },
    {
      'term': '1st House (Lagna)',
      'category': 'Bhava',
      'description': 'Represents physical self, personality traits, health, status, and overall life destiny.'
    },
    {
      'term': 'Gajakesari Yoga',
      'category': 'Yoga',
      'description': 'Formed when Jupiter occupies a kendra from Moon. Brings wisdom, virtue, and lasting reputation.'
    },
    {
      'term': 'Vimshottari Dasha',
      'category': 'Dasha',
      'description': '120-year planetary period system tracking life events based on natal Moon Nakshatra.'
    },
    {
      'term': 'Abhijit Muhurat',
      'category': 'Muhurat',
      'description': 'Auspicious mid-day time window suitable for starting important ventures or negotiations.'
    },
    {
      'term': 'Shukla Paksha',
      'category': 'Panchang',
      'description': 'Waxing phase of the Moon from New Moon (Amavasya) to Full Moon (Purnima).'
    },
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _queryController.text.trim().toLowerCase();
    final results = _knowledgeBase.where((item) {
      final matchesQuery = query.isEmpty ||
          item['term']!.toLowerCase().contains(query) ||
          item['description']!.toLowerCase().contains(query);
      final matchesFilter =
          _selectedFilter == 'All' || item['category'] == _selectedFilter;
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Search Astrology Knowledge',
          style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Input
            TextField(
              controller: _queryController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AppColors.textPrimaryDark),
              decoration: InputDecoration(
                hintText: 'Search Rashi, Planet, Nakshatra, Dasha...',
                hintStyle: const TextStyle(color: AppColors.textTertiaryDark),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondaryDark),
                        onPressed: () {
                          _queryController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceDark,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : AppColors.textPrimaryDark,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (sel) {
                        if (sel) setState(() => _selectedFilter = filter);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Results List
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        'No matching astrology terms found.',
                        style: GoogleFonts.outfit(color: AppColors.textTertiaryDark, fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.glassBorder, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item['term']!,
                                    style: GoogleFonts.outfit(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      item['category']!,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['description']!,
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondaryDark,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
