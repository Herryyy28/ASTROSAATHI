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
  final String? initialMessage;

  const AstroBabaScreen({super.key, this.initialMessage});

  @override
  ConsumerState<AstroBabaScreen> createState() => _AstroBabaScreenState();
}

class _AstroBabaScreenState extends ConsumerState<AstroBabaScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialMessage!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (jump) {
        _scrollController.jumpTo(target);
      } else {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final subNotifier = ref.read(subscriptionProvider.notifier);
    if (!subNotifier.canAskAiQuery()) {
      _focusNode.unfocus();
      PremiumUpgradeModal.show(context);
      return;
    }

    _controller.clear();
    _focusNode.unfocus();

    await subNotifier.recordAiQuery();
    await ref.read(astroBabaProvider.notifier).sendMessage(trimmed);

    _scrollToBottom();
  }

  Future<void> _retryMessage() async {
    await ref.read(astroBabaProvider.notifier).retryLastError();
    _scrollToBottom();
  }

  void _showQuickPromptsModal() {
    final prompts = [
      '🌟 How is my career outlook over the next 30 days?',
      '🪐 How is Shani Sade Sati or transit affecting my Lagna?',
      '💍 What is my favorable marriage & partnership window?',
      '💼 Is this an auspicious period for financial investments?',
      '📿 What personalized Vedic mantra should I chant for peace?',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.getGlassBorder(context))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Celestial Quick Questions',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Tap a question to send it instantly:',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.getTextSecondary(context),
              ),
            ),
            const SizedBox(height: 14),
            ...prompts.map((p) => Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.primary),
                    title: Text(
                      p,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.getTextPrimary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _sendMessage(p);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(astroBabaProvider);
    final isLoading = ref.watch(astroBabaLoadingProvider);

    final subState = ref.watch(subscriptionProvider);
    final isPremium = subState.isPremium;
    final remaining = isPremium
        ? 999
        : (SubscriptionNotifier.freeAiQueryLimit - subState.aiQueriesToday);
    final hasUsedQuery = !isPremium && remaining <= 0;

    final isLight = Theme.of(context).brightness == Brightness.light;

    // Auto-scroll when messages list changes
    if (messages.isNotEmpty) {
      _scrollToBottom();
    }

    final bool isTab = !Navigator.canPop(context);
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final double bottomNavPadding = (isTab && !isKeyboardOpen && context.isMobile) ? 84.0 : 0.0;

    return Scaffold(
      // resizeToAvoidBottomInset properly handles keyboard push
      resizeToAvoidBottomInset: true,
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
                // ── Header ──────────────────────────────────────────
                _buildAppBar(isPremium: isPremium, remaining: remaining,
                    isLoading: isLoading)
                    .fadeSlideUp(),

                // ── Messages ────────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(
                          messages[index], index, isLoading);
                    },
                  ),
                ),

                // ── Ad Banner ───────────────────────────────────────
                const AdMobBannerWidget(),

                // ── Suggested Prompts ─────────────────────────────
                if (!hasUsedQuery && messages.length <= 2)
                  _buildSuggestedQuestions(),

                // ── Input / Upgrade ──────────────────────────────────
                Padding(
                  padding: EdgeInsets.only(bottom: bottomNavPadding),
                  child: SafeArea(
                    top: false,
                    child: hasUsedQuery
                        ? _buildUpgradeInputPlaceholder()
                        : _buildInputArea(isLoading: isLoading),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar({
    required bool isPremium,
    required int remaining,
    required bool isLoading,
  }) {
    final l10n = AppLocalizations.of(context, ref);

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (Navigator.canPop(context)) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceElevated(context),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.getBorder(context), width: 0.8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
              CosmicOrbWidget(isSpeaking: isLoading, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'AI ${l10n.navAstroBaba}',
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        isLoading ? l10n.loading : l10n.babaConnected,
                        key: ValueKey(isLoading),
                        style: TextStyle(
                          color: isLoading
                              ? AppColors.getPrimary(context)
                              : AppColors.getTextSecondary(context),
                          fontSize: 11.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => PremiumUpgradeModal.show(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? AppColors.primary.withOpacity(0.18)
                        : AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPremium
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    isPremium ? '👑 Unlimited' : '⚡ $remaining Free',
                    style: GoogleFonts.outfit(
                      color: isPremium
                          ? AppColors.primary
                          : AppColors.getDynamicTextPrimary(context),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.getTextSecondary(context)),
                tooltip: 'Clear Chat History',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.getSurface(context),
                      title: Text(
                        'Clear Chat History?',
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(context)),
                      ),
                      content: Text(
                        'Are you sure you want to erase previous Astro Baba conversations?',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.getTextSecondary(context)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: AppColors.getTextMuted(context))),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Clear',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref
                        .read(astroBabaProvider.notifier)
                        .clearHistory();
                  }
                },
              ),
            ],
          ),
          // ── Kundli Context Badge ──────────────────────
          if (profileName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  const Icon(Icons.auto_awesome,
                      color: AppColors.secondary, size: 14),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '${l10n.translate('based_on_kundli')} ($profileName)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
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
    );
  }

  Widget _buildMessageBubble(
      ChatMessage message, int index, bool isLoading) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              context.responsive<double>(
                mobile: 0.82,
                tablet: 0.65,
                desktop: 0.55,
              ),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                              : message.isError
                                  ? AppColors.error.withOpacity(0.10)
                                  : AppColors.getGlassSurface(context),
                          borderRadius:
                              BorderRadius.circular(18).copyWith(
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
                                : message.isError
                                    ? AppColors.error.withOpacity(0.3)
                                    : AppColors.getGlassBorder(context),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Error icon row ──
                            if (message.isError) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline_rounded,
                                      color: AppColors.error, size: 15),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Connection Error',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            Text(
                              message.text,
                              style: GoogleFonts.inter(
                                color: message.isError
                                    ? AppColors.getTextSecondary(context)
                                    : AppColors.getTextPrimary(context),
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                            // ── Retry button ──
                            if (message.isError &&
                                message.retryQuery != null) ...[
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: isLoading ? null : _retryMessage,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color:
                                            AppColors.error.withOpacity(0.4),
                                        width: 0.8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        color: isLoading
                                            ? AppColors.getTextMuted(context)
                                            : AppColors.error,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Retry',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isLoading
                                              ? AppColors.getTextMuted(
                                                  context)
                                              : AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            // ── Recommended Actions ──
                            if (message.aiData != null &&
                                message.aiData!.actions.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Container(
                                  height: 0.5,
                                  color: AppColors.getGlassBorder(context)),
                              const SizedBox(height: 12),
                              const Row(
                                children: [
                                  Icon(Icons.auto_awesome_rounded,
                                      color: AppColors.primary, size: 14),
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
                                      const Text('✦ ',
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 12)),
                                      Expanded(
                                        child: Text(
                                          a,
                                          style: GoogleFonts.inter(
                                            color:
                                                AppColors.getTextSecondary(
                                                    context),
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
                            // ── Analysis badge on AI messages ──
                            if (!isUser && !message.isError) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        AppColors.primary.withOpacity(0.3),
                                    width: 0.5,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.analytics_outlined,
                                        color: AppColors.primary, size: 12),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
    final l10n = AppLocalizations.of(context, ref);

    final categoryPrompts = [
      {
        'chip': l10n.translate('chip_career'),
        'query':
            'What is my career outlook & 10th House alignment this month?',
      },
      {
        'chip': l10n.translate('chip_love'),
        'query':
            'How is my relationship harmony & Venus transit today?',
      },
      {
        'chip': l10n.translate('chip_money'),
        'query':
            'What are my financial trends under current Jupiter Mahadasha?',
      },
      {
        'chip': l10n.translate('chip_mindset'),
        'query':
            'How can I balance mental peace under today\'s Moon transit?',
      },
      {
        'chip': l10n.translate('chip_business'),
        'query':
            'Is today favorable for new business deals or negotiations?',
      },
      {
        'chip': l10n.translate('chip_marriage'),
        'query':
            'Explain my 7th house partnership aspect & Gun Milan factors.',
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
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      AppColors.getPrimary(context).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color:
                        AppColors.getPrimary(context).withOpacity(0.35),
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

  Widget _buildInputArea({required bool isLoading}) {
    final l10n = AppLocalizations.of(context, ref);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.getSurface(context).withOpacity(0.92),
            border: Border(
              top: BorderSide(
                  color: AppColors.getBorder(context), width: 0.8),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Quick prompts button
              GestureDetector(
                onTap: isLoading ? null : _showQuickPromptsModal,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.getGlassSurface(context),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.getGlassBorder(context),
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: isLoading
                        ? AppColors.getTextMuted(context)
                        : AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Text field — multi-line up to 4 lines, then scrolls
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !isLoading,
                  maxLines: 4,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: GoogleFonts.inter(
                    color: AppColors.getTextPrimary(context),
                    fontSize: 14.5,
                  ),
                  decoration: InputDecoration(
                    hintText: isLoading
                        ? 'Astro Baba is thinking…'
                        : l10n.askBabaHint,
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
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: AppColors.getBorder(context)
                            .withOpacity(0.4),
                        width: 0.8,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Send button — disabled during load
              GestureDetector(
                onTap: isLoading
                    ? null
                    : () => _sendMessage(_controller.text),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isLoading
                        ? null
                        : AppColors.goldGradient,
                    color: isLoading
                        ? AppColors.getSurfaceElevated(context)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.getPrimary(context),
                            ),
                          ),
                        )
                      : const Icon(Icons.send_rounded,
                          color: Colors.black, size: 20),
                ),
              ),
            ],
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
                  child: const Text('👑',
                      style: TextStyle(fontSize: 16)),
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
                        'You have used your ${SubscriptionNotifier.freeAiQueryLimit} free chat queries today. Upgrade to VIP to chat 24/7.',
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
                  'Upgrade to VIP 👑',
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
    );
  }
}
