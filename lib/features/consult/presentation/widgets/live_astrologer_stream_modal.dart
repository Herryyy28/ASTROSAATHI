import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/astrologer_model.dart';

class LiveAstrologerStreamModal extends StatefulWidget {
  final Astrologer astrologer;

  const LiveAstrologerStreamModal({
    super.key,
    required this.astrologer,
  });

  static void show(BuildContext context, Astrologer astrologer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LiveAstrologerStreamModal(astrologer: astrologer),
    );
  }

  @override
  State<LiveAstrologerStreamModal> createState() => _LiveAstrologerStreamModalState();
}

class _LiveAstrologerStreamModalState extends State<LiveAstrologerStreamModal> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [
    {'user': 'Amit Verma', 'msg': 'Pranam Guruji! 🙏 How is Mesha rashi this month?'},
    {'user': 'Pooja Hegde', 'msg': 'Har Har Mahadev! Great remedies explained.'},
    {'user': 'Rajesh Sharma', 'msg': 'Please check marriage timing for Tula lagna.'},
    {'user': 'Sneha K', 'msg': 'Thank you for the Shani Sade Sati उपाय.'},
  ];

  Timer? _commentTimer;
  int _viewers = 1420;

  @override
  void initState() {
    super.initState();
    // Simulate active live comments
    _commentTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        final sampleComments = [
          {'user': 'Kunal Sen', 'msg': 'Can I wear Yellow Sapphire?'},
          {'user': 'Vandana J', 'msg': 'Om Namah Shivaya! Very accurate reading.'},
          {'user': 'Nitin P', 'msg': 'What is today’s Rahu Kaal?'},
        ];
        setState(() {
          _viewers += 3;
          _comments.add(sampleComments[DateTime.now().second % sampleComments.length]);
        });
      }
    });
  }

  @override
  void dispose() {
    _commentTimer?.cancel();
    _commentController.dispose();
    super.dispose();
  }

  void _postComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add({'user': 'You', 'msg': text});
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.astrologer;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Color(0xFF140E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Top Live Video Preview Area
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Atmospheric video simulation
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    gradient: LinearGradient(
                      colors: [a.primaryAccent, const Color(0xFF1B0B2E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFB300), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: a.primaryAccent.withValues(alpha: 0.6),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              a.name.substring(0, 1),
                              style: GoogleFonts.outfit(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          a.name,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Live Consultation & Kundli Guidance',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFFFB300),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top Overlay Controls
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Red LIVE Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'LIVE',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Viewer counter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.remove_red_eye_rounded, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '$_viewers',
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Live Chat Comments Stream
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF140E1E),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemCount: _comments.length,
                itemBuilder: (context, idx) {
                  final item = _comments[_comments.length - 1 - idx];
                  final isYou = item['user'] == 'You';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['user']}: ',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isYou ? const Color(0xFFFFB300) : const Color(0xFF90CAF9),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item['msg']!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            color: const Color(0xFF1C142B),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Ask Astrologer in Live...',
                        hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _postComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xFFFF9800)),
                  onPressed: _postComment,
                ),
                IconButton(
                  icon: const Icon(Icons.card_giftcard_rounded, color: Color(0xFFE91E63)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dakshina / Rose gifted to Guruji!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
