import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../search/presentation/widgets/astro_command_center_modal.dart';
import '../../data/models/astrologer_model.dart';
import 'ai_astrologer_call_screen.dart';

class TalkToAiAstrologersScreen extends ConsumerStatefulWidget {
  const TalkToAiAstrologersScreen({super.key});

  @override
  ConsumerState<TalkToAiAstrologersScreen> createState() => _TalkToAiAstrologersScreenState();
}

class _TalkToAiAstrologersScreenState extends ConsumerState<TalkToAiAstrologersScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, String>> _categories = const [
    {'name': 'All', 'icon': ''},
    {'name': 'Love', 'icon': '❤️ '},
    {'name': 'Career', 'icon': '💼 '},
    {'name': 'Marriage', 'icon': '🎀 '},
    {'name': 'Wealth', 'icon': '💰 '},
    {'name': 'Health', 'icon': '🩺 '},
  ];

  int _walletBalance = 738;

  List<Astrologer> get _filteredAstrologers {
    final list = AstrologerRepository.aiAstrologers;
    if (_selectedCategory == 'All') return list;

    if (_selectedCategory == 'Love') {
      return list.where((a) => a.category == AstrologerCategory.love || a.id == 'swami_ji').toList();
    }
    if (_selectedCategory == 'Career') {
      return list.where((a) => a.category == AstrologerCategory.career || a.id == 'swami_ji').toList();
    }
    if (_selectedCategory == 'Marriage') {
      return list.where((a) => a.category == AstrologerCategory.love || a.category == AstrologerCategory.vedic).toList();
    }
    return list;
  }

  void _showWalletDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFFF9800)),
            const SizedBox(width: 10),
            Text('Astro Wallet', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Balance', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text('₹$_walletBalance', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFFFF9800))),
            const SizedBox(height: 16),
            Text('Quick Recharge Pack:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [100, 250, 500].map((amt) {
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() => _walletBalance += amt);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ₹$amt to Astro Wallet!')),
                    );
                  },
                  child: Text('+₹$amt'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connecting to 24x7 Astrological Support Helpline...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFFAF9F6) : AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // ── AstroSage Style Header ────────────────────────────
            _buildAppBar(context),

            // ── Category Filter Chips ─────────────────────────────
            _buildCategoryFilters(),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 90),
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredAstrologers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final astrologer = _filteredAstrologers[index];
                  return _buildAstrologerCard(astrologer, isLight);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        border: Border(bottom: BorderSide(color: AppColors.getGlassBorder(context), width: 0.8)),
      ),
      child: Row(
        children: [
          if (Navigator.canPop(context)) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              color: AppColors.getTextPrimary(context),
              onPressed: () => Navigator.pop(context),
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.only(left: 6, right: 6),
              child: Icon(Icons.auto_awesome, color: Color(0xFFFF9800), size: 22),
            ),
          ],
          Expanded(
            child: Text(
              'AstroSaathi AI',
              style: GoogleFonts.outfit(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),

          // Wallet Badge Pill
          GestureDetector(
            onTap: _showWalletDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFB74D), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 14, color: Color(0xFFE65100)),
                  const SizedBox(width: 4),
                  Text(
                    '₹$_walletBalance',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Support Headset Icon
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, size: 22),
            color: AppColors.getTextSecondary(context),
            onPressed: _showSupportDialog,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
          ),
          
          // Search Icon
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            color: AppColors.getTextSecondary(context),
            onPressed: () => AstroCommandCenterModal.show(context),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Leading List Icon button like in AstroSage screenshot
            return Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.getGlassBorder(context)),
                ),
                child: const Icon(Icons.format_list_bulleted_rounded, size: 18),
              ),
            );
          }

          final cat = _categories[index - 1];
          final isSelected = cat['name'] == _selectedCategory;

          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat['name']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF9800) : AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFF9800) : AppColors.getGlassBorder(context),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFF9800).withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    if (cat['icon']!.isNotEmpty) Text(cat['icon']!),
                    Text(
                      cat['name']!,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.getTextPrimary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAstrologerCard(Astrologer a, bool isLight) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLight ? const Color(0xFFEAEAEA) : AppColors.borderDark,
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.04 : 0.20),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Avatar with Green Online Dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [a.primaryAccent, const Color(0xFFFF8F00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    a.name.substring(0, 1),
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Verified Blue Badge
              Positioned(
                bottom: -2,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF1E88E5),
                    size: 16,
                  ),
                ),
              ),
              // AI Badge
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6D00),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    'AI',
                    style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        a.name,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.getTextPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  a.specialty,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.getTextSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${a.languages.first}   •   Exp: ${a.experienceYears} Years',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.getTextMuted(context),
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  '₹${a.ratePerMinute}/min',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE65100),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB300)),
                    Text(
                      ' ${a.rating} (${a.reviewCount})',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button on right: [AI Chat]
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 6),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AstroBabaScreen(
                      initialMessage: 'Pranam ${a.name}, please guide me on my horoscope.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_rounded, size: 14),
              label: Text(
                'AI Chat',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
