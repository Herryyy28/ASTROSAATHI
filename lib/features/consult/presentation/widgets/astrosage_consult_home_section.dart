import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../data/models/astrologer_model.dart';
import '../screens/chat_with_astrologers_screen.dart';
import '../screens/talk_to_ai_astrologers_screen.dart';
import 'live_astrologer_stream_modal.dart';

import '../../../kundli/presentation/screens/new_kundli_input_screen.dart';
import '../../../matching/presentation/screens/matching_screen.dart';
import '../../../home/presentation/screens/main_screen.dart';

class AstrosageConsultHomeSection extends StatelessWidget {
  final Widget? middleWidget;
  const AstrosageConsultHomeSection({super.key, this.middleWidget});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Festive Promotional Banner ("First Chat FREE") ──
        _buildFirstChatFreeBanner(context),
        const SizedBox(height: 14),

        // ── 2. Middle Insert (e.g. 3 Primary Cards + Grid) ───────
        if (middleWidget != null) ...[
          middleWidget!,
          const SizedBox(height: 18),
        ],

        // ── 3. Live Astrologers Horizontal Carousel ────────────
        _buildLiveAstrologersSection(context, isLight),
        const SizedBox(height: 20),

        // ── 4. Chat / Call with Astrologer Section ─────────────
        _buildChatCallAstrologerSection(context, isLight),
      ],
    );
  }

  Widget _buildFirstChatFreeBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TalkToAiAstrologersScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFFF6F00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular Avatar or festive icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFFFD54F), width: 2),
              ),
              child: const Center(
                child: Icon(Icons.support_agent_rounded, color: Color(0xFFC62828), size: 30),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'First Chat ',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD54F),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'FREE',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFB71C1C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Consult Premium Astrologers Online',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: const Color(0xFFB71C1C),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TalkToAiAstrologersScreen()),
                );
              },
              child: Text(
                'Chat Now',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveAstrologersSection(BuildContext context, bool isLight) {
    final liveList = AstrologerRepository.liveAstrologers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Live Astrologers',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'LIVE',
                    style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatWithAstrologersScreen()),
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFFFF9800)),
              label: Text(
                'View All',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF9800)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: liveList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final a = liveList[index];
              return GestureDetector(
                onTap: () => LiveAstrologerStreamModal.show(context, a),
                child: Container(
                  width: 96,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE65100).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                            ),
                            child: Center(
                              child: Text(
                                a.name.substring(0, 1),
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE65100),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD50000),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'LIVE',
                                style: GoogleFonts.inter(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        a.name,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatCallAstrologerSection(BuildContext context, bool isLight) {
    final list = AstrologerRepository.directoryAstrologers.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Chat/Call with Astrologer',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.getTextPrimary(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatWithAstrologersScreen()),
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFFFF9800)),
              label: Text(
                'View All',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF9800)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final a = list[index];
              return Container(
                width: 130,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isLight ? Colors.white : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLight ? const Color(0xFFEEEEEE) : AppColors.borderDark,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isLight ? 0.05 : 0.20),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top tag: Today's Offer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Today's Offer",
                        style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.w800, color: const Color(0xFFE65100)),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Avatar with online green dot
                    Stack(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [a.primaryAccent, const Color(0xFFFF8F00)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              a.name.substring(0, 1),
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF00E676),
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    Text(
                      a.name,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Rating & Price
                    Text(
                      '${a.rating} ★ | FREE',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    Text(
                      '₹${a.ratePerMinute}/min',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),

                    // Connect button
                    SizedBox(
                      width: double.infinity,
                      height: 26,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AstroBabaScreen(
                                initialMessage: 'Pranam ${a.name}, please analyze my horoscope.',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Connect',
                          style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 3 Primary Large Feature Cards matching Image 2 (Kundli | Matching | Horoscope)
class AstrosagePrimaryActionCards extends StatelessWidget {
  final void Function(int tabIndex)? onSelectTab;
  const AstrosagePrimaryActionCards({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Row(
      children: [
        Expanded(
          child: _buildBigCard(
            context,
            title: 'Kundli',
            icon: Icons.grid_goldenratio_rounded,
            iconColor: const Color(0xFFFF9800),
            isLight: isLight,
            onTap: () {
              if (onSelectTab != null) {
                onSelectTab!(3);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewKundliInputScreen()),
                );
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildBigCard(
            context,
            title: 'Matching',
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFFF5722),
            isLight: isLight,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MatchingScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildBigCard(
            context,
            title: 'Horoscope',
            icon: Icons.balance_rounded,
            iconColor: const Color(0xFFFF9800),
            isLight: isLight,
            onTap: () {
              if (onSelectTab != null) {
                onSelectTab!(3);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewKundliInputScreen()),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBigCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isLight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLight ? const Color(0xFFEEEEEE) : AppColors.borderDark,
            width: 1,
          ),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.getTextPrimary(context),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
