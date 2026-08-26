import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/engine/models/ai_data.dart';
import '../providers/astro_baba_provider.dart';

class AstroBabaScreen extends ConsumerStatefulWidget {
  const AstroBabaScreen({super.key});

  @override
  ConsumerState<AstroBabaScreen> createState() => _AstroBabaScreenState();
}

class _AstroBabaScreenState extends ConsumerState<AstroBabaScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _controller.clear();
    setState(() => _isLoading = true);

    await ref.read(astroBabaProvider.notifier).sendMessage(text);

    setState(() => _isLoading = false);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(astroBabaProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.cosmicRadialGradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── App Bar ─────────────────────────────────────────
              _buildAppBar().fadeSlideUp(),

              // ── Messages ────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return _buildTypingIndicator();
                    }
                    return _buildMessageBubble(messages[index], index);
                  },
                ),
              ),

              // ── Suggested Questions ─────────────────────────────
              _buildSuggestedQuestions(),

              // ── Input Area ──────────────────────────────────────
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.purpleGradient,
              boxShadow: [
                BoxShadow(color: AppColors.purpleGlow, blurRadius: 12),
              ],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Astro Baba',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const Text(
                'Your personal astrologer',
                style: TextStyle(
                  color: AppColors.textTertiaryDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Online',
            style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Avatar + Bubble
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 4),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.purpleGradient,
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                    ),
                  ),
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                      bottomLeft: !isUser ? const Radius.circular(4) : const Radius.circular(18),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.primary.withOpacity(0.15)
                              : AppColors.glassSurface,
                          borderRadius: BorderRadius.circular(18).copyWith(
                            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                            bottomLeft: !isUser ? const Radius.circular(4) : const Radius.circular(18),
                          ),
                          border: Border.all(
                            color: isUser
                                ? AppColors.primary.withOpacity(0.3)
                                : AppColors.glassBorder,
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.text,
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimaryDark,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                            if (message.aiData != null && message.aiData!.actions.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Container(
                                height: 0.5,
                                color: AppColors.glassBorder,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.lightbulb_outline_rounded, color: AppColors.success, size: 14),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Suggested Actions',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...message.aiData!.actions.map((a) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('→ ', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14)),
                                    Expanded(
                                      child: Text(
                                        a,
                                        style: GoogleFonts.inter(
                                          color: AppColors.textSecondaryDark,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(
          begin: isUser ? 0.1 : -0.1,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.purpleGradient,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
          ),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            borderRadius: 18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 150))
                    .scale(
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1.0, 1.0),
                      duration: 400.ms,
                      delay: Duration(milliseconds: index * 150),
                      curve: Curves.easeInOut,
                    );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    if (ref.read(astroBabaProvider).length > 1) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          'Should I change my job?',
          'Is today good for a meeting?',
          'Why does today feel difficult?',
        ].asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _sendMessage(entry.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.4), width: 0.5),
                ),
                child: Text(
                  entry.value,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ).fadeSlideUp(delay: Duration(milliseconds: entry.key * 100)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withOpacity(0.85),
            border: const Border(
              top: BorderSide(color: AppColors.glassBorder, width: 0.5),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimaryDark,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask Astro Baba...',
                      hintStyle: TextStyle(color: AppColors.textTertiaryDark),
                      filled: true,
                      fillColor: AppColors.glassSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.glassBorder, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.glassBorder, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.secondary, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.goldGlow, blurRadius: 12, spreadRadius: -4),
                      ],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
