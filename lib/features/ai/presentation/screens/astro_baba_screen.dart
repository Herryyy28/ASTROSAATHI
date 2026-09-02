import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/engine/models/ai_data.dart';
import '../providers/astro_baba_provider.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../widgets/cosmic_orb_painter.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/widgets/admob_banner_widget.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';

class AstroBabaScreen extends ConsumerStatefulWidget {
  const AstroBabaScreen({super.key});

  @override
  ConsumerState<AstroBabaScreen> createState() => _AstroBabaScreenState();
}

class _AstroBabaScreenState extends ConsumerState<AstroBabaScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isListeningVoice = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final subNotifier = ref.read(subscriptionProvider.notifier);
    if (!subNotifier.canAskAiQuery()) {
      PremiumUpgradeModal.show(context);
      return;
    }

    _controller.clear();
    setState(() => _isLoading = true);

    await subNotifier.recordAiQuery();
    await ref.read(astroBabaProvider.notifier).sendMessage(text);

    if (mounted) setState(() => _isLoading = false);

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

  void _toggleVoiceInput() {
    setState(() {
      _isListeningVoice = !_isListeningVoice;
    });
    if (_isListeningVoice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listening... Ask Astro Baba anything!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(astroBabaProvider);

    final subState = ref.watch(subscriptionProvider);
    final isPremium = subState.isPremium;
    final remaining = isPremium ? 999 : (1 - subState.aiQueriesToday);
    final hasUsedQuery = !isPremium && remaining <= 0;

    final double keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final double safeBottom = MediaQuery.of(context).padding.bottom;
    final double bottomPadding = keyboardInset > 0 ? 8.0 : (84.0 + safeBottom);

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: Column(
              children: [
                // ── Dynamic Glowing Orb Header ───────────────────────
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

                // ── Ad Banner ───────────────────────────────────────
                const AdMobBannerWidget(),

                // ── Contextual Smart Prompt Chips (Only show if typing is allowed) ──
                if (!hasUsedQuery) _buildSuggestedQuestions(),

                // ── Input Area or Upgrade Placeholder ────────────────
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: hasUsedQuery
                      ? _buildUpgradeInputPlaceholder()
                      : _buildInputArea(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final l10n = AppLocalizations.of(context, ref);
    final subState = ref.watch(subscriptionProvider);
    final isPremium = subState.isPremium;
    final remaining = ref
        .read(subscriptionProvider.notifier)
        .remainingFreeAiQueries;

    // ── Get active profile for Kundli context ──
    final activeProfile = ref.watch(
      Provider((ref) {
        final profiles = ref.watch(profilesListProvider);
        final idx = ref.watch(activeProfileIndexProvider);
        if (profiles.isEmpty) return null;
        return profiles[idx.clamp(0, profiles.length - 1)];
      }),
    );
    final profileName = activeProfile?.name ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CosmicOrbWidget(
                isSpeaking: _isLoading || _isListeningVoice,
                size: 48,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI ${l10n.navAstroBaba}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    Text(
                      _isLoading ? l10n.loading : l10n.babaConnected,
                      style: TextStyle(
                        color: AppColors.getTextSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => PremiumUpgradeModal.show(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? AppColors.primary.withOpacity(0.18)
                        : AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isPremium
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        isPremium ? '👑 Unlimited' : '⚡ $remaining/1 Free',
                        style: GoogleFonts.outfit(
                          color: isPremium
                              ? AppColors.primary
                              : AppColors.getDynamicTextPrimary(context),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ── Kundli Context Badge ──────────────────────
          if (profileName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.25),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.secondary,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${l10n.translate('based_on_kundli')} ($profileName)',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          maxWidth:
              MediaQuery.of(context).size.width *
              context.responsive<double>(
                mobile: 0.82,
                tablet: 0.65,
                desktop: 0.55,
              ),
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser)
                  const Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 4),
                    child: CosmicOrbWidget(size: 28),
                  ),
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                      bottomLeft: !isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.primary.withOpacity(0.15)
                              : AppColors.getGlassSurface(context),
                          borderRadius: BorderRadius.circular(18).copyWith(
                            bottomRight: isUser
                                ? const Radius.circular(4)
                                : const Radius.circular(18),
                            bottomLeft: !isUser
                                ? const Radius.circular(4)
                                : const Radius.circular(18),
                          ),
                          border: Border.all(
                            color: isUser
                                ? AppColors.primary.withOpacity(0.3)
                                : AppColors.getGlassBorder(context),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                              message.text,
                              style: GoogleFonts.inter(
                                color: AppColors.getTextPrimary(context),
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                            if (message.aiData != null &&
                                message.aiData!.actions.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Container(
                                height: 0.5,
                                color: AppColors.getGlassBorder(context),
                              ),
                              const SizedBox(height: 12),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    color: AppColors.primary,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Recommended Vedic Actions',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...message.aiData!.actions.map(
                                (a) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '✦ ',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                        ),
                                      ),
                                       Expanded(
                                        child: Text(
                                          a,
                                          style: GoogleFonts.inter(
                                            color: AppColors.getTextSecondary(context),
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (!isUser) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                    width: 0.5,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.analytics_outlined,
                                      color: AppColors.primary,
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        'Analyzed: Kundli • Dasha • Transits • Panchang',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
    ).animate().fadeIn(duration: 300.ms).slideX(begin: isUser ? 0.1 : -0.1);
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CosmicOrbWidget(size: 28, isSpeaking: true),
          const SizedBox(width: 8),
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
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1.0, 1.0),
                      duration: 400.ms,
                      delay: Duration(milliseconds: index * 150),
                    );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    if (ref.read(astroBabaProvider).length > 2) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context, ref);

    final categoryPrompts = [
      {
        'chip': l10n.translate('chip_career'),
        'query': 'What is my career outlook & 10th House alignment this month?',
      },
      {
        'chip': l10n.translate('chip_love'),
        'query': 'How is my relationship harmony & Venus transit today?',
      },
      {
        'chip': l10n.translate('chip_money'),
        'query':
            'What are my financial trends under current Jupiter Mahadasha?',
      },
      {
        'chip': l10n.translate('chip_mindset'),
        'query': 'How can I balance mental peace under today\'s Moon transit?',
      },
      {
        'chip': l10n.translate('chip_business'),
        'query': 'Is today favorable for new business deals or negotiations?',
      },
      {
        'chip': l10n.translate('chip_marriage'),
        'query': 'Explain my 7th house partnership aspect & Gun Milan factors.',
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categoryPrompts.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _sendMessage(item['query']!),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getPrimary(context).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: AppColors.getPrimary(context).withOpacity(0.35),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  item['chip']!,
                  style: TextStyle(
                    color: AppColors.getPrimary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    final l10n = AppLocalizations.of(context, ref);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.getSurface(context).withOpacity(0.92),
            border: Border(
              top: BorderSide(color: AppColors.getBorder(context), width: 0.8),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleVoiceInput,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isListeningVoice
                          ? AppColors.error.withOpacity(0.2)
                          : AppColors.getGlassSurface(context),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isListeningVoice
                            ? AppColors.error
                            : AppColors.getGlassBorder(context),
                      ),
                    ),
                    child: Icon(
                      _isListeningVoice
                          ? Icons.mic_rounded
                          : Icons.mic_none_rounded,
                      color: _isListeningVoice
                          ? AppColors.error
                          : AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.inter(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 14.5,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.askBabaHint,
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.getTextMuted(context),
                        fontSize: 13.5,
                      ),
                      filled: true,
                      fillColor: AppColors.getSurfaceElevated(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppColors.getBorder(context),
                          width: 0.8,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppColors.getBorder(context),
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppColors.getPrimary(context),
                          width: 1.2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeInputPlaceholder() {
    final primaryColor = AppColors.getPrimary(context);
    final primarySoft = AppColors.getPrimarySoft(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context).withOpacity(0.92),
        border: Border(
          top: BorderSide(color: AppColors.getBorder(context), width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primarySoft,
            borderRadius: BorderRadius.circular(AppRadius.xl2),
            border: Border.all(
              color: primaryColor.withOpacity(0.45),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.10),
                blurRadius: 16,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.15),
                    ),
                    child: const Text('\u{1F451}', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unlock Unlimited Astro Baba AI',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'You have used your 1 free chat query. Upgrade to VIP to chat 24/7.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.getTextSecondary(context),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderButton,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(0, 46),
                  ),
                  onPressed: () => PremiumUpgradeModal.show(context),
                  child: Text(
                    'Upgrade to VIP \u{1F451}',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
