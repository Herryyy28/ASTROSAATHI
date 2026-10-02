import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/astrologer_model.dart';

class AiAstrologerCallScreen extends StatefulWidget {
  final Astrologer astrologer;

  const AiAstrologerCallScreen({
    super.key,
    required this.astrologer,
  });

  @override
  State<AiAstrologerCallScreen> createState() => _AiAstrologerCallScreenState();
}

class _AiAstrologerCallScreenState extends State<AiAstrologerCallScreen>
    with SingleTickerProviderStateMixin {
  int _seconds = 0;
  Timer? _callTimer;
  bool _isConnected = false;
  bool _isMuted = false;
  bool _isSpeaker = true;

  late AnimationController _waveController;
  final List<String> _astrologerDialogues = [
    'Om Namah Shivaya! Your planetary lagna is in an auspicious alignment today.',
    'I see your Moon transit is bringing emotional clarity. What question is on your mind?',
    'Jupiter is aspecting your 10th house of career. Success will come through patience and dedication.',
    'Chant the Gayatri Mantra 11 times in the morning for immense peace and spiritual protection.',
    'Auspicious energy surrounds your efforts. Trust your inner intuition.',
  ];
  int _dialogueIndex = 0;
  Timer? _dialogueTimer;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Simulate connection delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _seconds++);
      }
    });

    _dialogueTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (mounted) {
        setState(() {
          _dialogueIndex = (_dialogueIndex + 1) % _astrologerDialogues.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _dialogueTimer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.astrologer;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B17),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isConnected ? const Color(0xFF00E676) : const Color(0xFFFFB300),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isConnected ? 'Connected • ${_formatDuration(_seconds)}' : 'Connecting...',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline_rounded, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Pulsing Avatar with Divine Aura
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated Outer Aura Waves
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      final scale = 1.0 + (_waveController.value * 0.25);
                      final opacity = (1.0 - _waveController.value) * 0.35;
                      return Container(
                        width: 170 * scale,
                        height: 170 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: a.primaryAccent.withValues(alpha: opacity),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      final scale = 1.0 + (_waveController.value * 0.12);
                      return Container(
                        width: 150 * scale,
                        height: 150 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFB300).withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  // Avatar Circle
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [a.primaryAccent, const Color(0xFFFF8F00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: a.primaryAccent.withValues(alpha: 0.5),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        a.name.substring(0, 1),
                        style: GoogleFonts.outfit(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Astrologer Info
            Text(
              a.name,
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              a.specialty,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFFFB300),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${a.languagesDisplay} • ₹${a.ratePerMinute}/min',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),

            const Spacer(flex: 1),

            // Live Voice Transcriptions / Guidance
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0x22FFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.graphic_eq_rounded, color: Color(0xFFFFB300), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'AI Vedic Audio Stream',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFFFB300),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      _astrologerDialogues[_dialogueIndex],
                      key: ValueKey<int>(_dialogueIndex),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Audio Waves simulator
                  SizedBox(
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(14, (idx) {
                        return AnimatedBuilder(
                          animation: _waveController,
                          builder: (context, _) {
                            final h = 6 + (18 * sin((idx * 0.4) + (_waveController.value * 2 * pi)).abs());
                            return Container(
                              width: 3.5,
                              height: h,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800).withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Call Controls: Mute, Keypad, Speaker, End Call
            Padding(
              padding: const EdgeInsets.only(bottom: 36, left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute
                  _buildCallButton(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),

                  // Speaker
                  _buildCallButton(
                    icon: _isSpeaker ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                    label: 'Speaker',
                    isActive: _isSpeaker,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),

                  // End Call (Red button)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53935),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66E53935),
                                blurRadius: 18,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.call_end_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'End',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.white.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.10),
              border: Border.all(
                color: isActive ? const Color(0xFFFFB300) : Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFFFFB300) : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
