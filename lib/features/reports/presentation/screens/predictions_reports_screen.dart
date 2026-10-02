import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/nine_languages_modal.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';

class PredictionsReportsScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const PredictionsReportsScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<PredictionsReportsScreen> createState() => _PredictionsReportsScreenState();
}

class _PredictionsReportsScreenState extends ConsumerState<PredictionsReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'PREDICTIONS',
    'LIFE PREDICTIONS',
    'MONTHLY PREDICTIONS',
  ];

  final List<Map<String, dynamic>> _coreCards = [
    {'title': 'Basic', 'icon': Icons.description_outlined, 'desc': 'Ascendant, Planets & Degrees'},
    {'title': 'Dasha', 'icon': Icons.all_inclusive_rounded, 'desc': 'Vimshottari 5 Levels & Yogini'},
    {'title': 'KP System', 'icon': Icons.auto_awesome, 'desc': 'Sub-Lords & Significators'},
    {'title': 'Shodashvarga', 'icon': Icons.grid_view_rounded, 'desc': '16 Divisional Charts'},
    {'title': 'Lal Kitab', 'icon': Icons.menu_book_rounded, 'desc': 'Teva Type, Debts & Upay'},
    {'title': 'Varshphal', 'icon': Icons.calendar_today_rounded, 'desc': 'Tajik Annual Solar Return'},
  ];

  final List<List<String>> _reportRows = [
    ['Life Predictions', 'Monthly Predictions'],
    ['Daily Predictions', 'Mangal Dosh'],
    ['Sade Sati Life Report', 'Kaal Sarp Dosha'],
    ['Lal Kitab Debt', 'Lal Kitab Teva Type'],
    ['Lal Kitab Remedies', 'Ascendant Prediction'],
    ['Planet Consideration', 'Gemstones Report'],
    ['Transit Today', 'Mahadasha Phala'],
    ['Panchang Phala', 'Yogini Dasha Analysis'],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openReportDetail(String reportName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildReportDetailModal(ctx, reportName),
    );
  }

  Widget _buildReportDetailModal(BuildContext ctx, String reportName) {
    final active = ref.read(activeProfileProvider);
    final userName = active.name.isNotEmpty ? active.name : 'Seeker';

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFF3E0),
                ),
                child: const Icon(Icons.stars_rounded, color: Color(0xFFFF9800), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportName,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    Text(
                      'Personalized Vedic Analysis for $userName',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Astrological Assessment & Findings',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on your natal Lagna and Gochara transit coordinates, planetary influences in this domain indicate auspicious karma tempered by key lessons. Jupiter provides divine wisdom, while Saturn tests patience.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dosha status: Neutral / Mild. Fully alleviated through routine spiritual discipline.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Prescribed Vedic Upay & Remedies',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Recite the Gayatri Mantra 11 times during sunrise.\n'
                    '2. Offer water (Arghya) to Lord Surya in a copper vessel.\n'
                    '3. Wear natural gemstones (e.g. Yellow Sapphire or Pearl) only after testing suitability.\n'
                    '4. Feed birds with soaked grains on Wednesday mornings.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.6,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AstroBabaScreen(
                              initialMessage: 'Please explain my $reportName report in detail with remedies.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      label: Text(
                        'Discuss $reportName with AI Astrologer',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final bodyContent = Column(
      children: [
        if (!widget.isEmbedded) _buildAppBar(context),

            // ── Navigation Tabs ───────────────────────────────────
            _buildTabs(context),

            // ── Content Area ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // ── 6 Core Cards 3x2 Grid (Image 3) ───────────
                    Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLight ? const Color(0xFFE0E0E0) : AppColors.borderDark,
                          width: 1,
                        ),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.15,
                        ),
                        itemCount: _coreCards.length,
                        itemBuilder: (context, index) {
                          final c = _coreCards[index];
                          return InkWell(
                            onTap: () => _openReportDetail(c['title']),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isLight ? const Color(0xFFF0F0F0) : AppColors.borderDark,
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(c['icon'], color: const Color(0xFF37474F), size: 28),
                                  const SizedBox(height: 6),
                                  Text(
                                    c['title'],
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ── 2-Column Table of 100+ Free Reports ─────────
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLight ? const Color(0xFFE0E0E0) : AppColors.borderDark,
                          width: 1,
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _reportRows.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: isLight ? const Color(0xFFEEEEEE) : AppColors.borderDark,
                        ),
                        itemBuilder: (context, idx) {
                          final row = _reportRows[idx];
                          return Row(
                            children: [
                              // Left Column Report
                              Expanded(
                                child: InkWell(
                                  onTap: () => _openReportDetail(row[0]),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: isLight ? const Color(0xFFEEEEEE) : AppColors.borderDark,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      row[0],
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.getTextPrimary(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Right Column Report
                              Expanded(
                                child: InkWell(
                                  onTap: () => _openReportDetail(row[1]),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    child: Text(
                                      row[1],
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.getTextPrimary(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        );

    if (widget.isEmbedded) {
      return Container(
        color: isLight ? const Color(0xFFF9F9F9) : AppColors.backgroundDark,
        child: bodyContent,
      );
    }

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF9F9F9) : AppColors.backgroundDark,
      body: SafeArea(
        child: bodyContent,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF5A623), // AstroSage Golden Yellow
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: () => NineLanguagesModal.show(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Predictions',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined, color: Colors.black87, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparing Printable Vedic Horoscope Document...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black87, size: 21),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AstroBabaScreen(
                    initialMessage: 'Please provide my personalized horoscope predictions.',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing Free Horoscope Reports...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black87, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      color: const Color(0xFFF5A623),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.black,
        indicatorWeight: 3.5,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}
