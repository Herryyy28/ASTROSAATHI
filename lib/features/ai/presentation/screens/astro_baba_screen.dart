import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/engine/models/ai_data.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';
import '../providers/astro_baba_provider.dart';

class AstroBabaScreen extends ConsumerStatefulWidget {
  const AstroBabaScreen({super.key, this.initialMessage});
  final String? initialMessage;
  @override
  ConsumerState<AstroBabaScreen> createState() => _AstroBabaScreenState();
}

class _AstroBabaScreenState extends ConsumerState<AstroBabaScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _send(widget.initialMessage!),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;
    final subscription = ref.read(subscriptionProvider.notifier);
    if (!subscription.canAskAiQuery()) {
      if (mounted) PremiumUpgradeModal.show(context);
      return;
    }
    _controller.clear();
    await subscription.recordAiQuery();
    await ref.read(astroBabaProvider.notifier).sendMessage(query);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(astroBabaProvider);
    final loading = ref.watch(astroBabaLoadingProvider);
    final remaining = ref.watch(
      subscriptionProvider.select(
        (s) => s.isPremium ? 999 : 3 - s.aiQueriesToday,
      ),
    );
    final showSuggestions = messages.length <= 1;
    final suggestions = _suggestionsFor(
      ref.watch(activeProfileProvider).focusAreas,
    );
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AstroPrimaryHeader(
              eyebrow: 'Chart intelligence',
              title: 'Ask AstroSaathi',
              subtitle: 'Your chart-aware astrology guide',
              trailing: Container(
                constraints: const BoxConstraints(minHeight: 34),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softLavender,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: AppColors.primaryLightMode,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      remaining > 100
                          ? 'Premium'
                          : '${remaining.clamp(0, 3)} questions left',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLightMode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  if (showSuggestions) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'SUGGESTED FOR YOU',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: .7,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...suggestions.map(
                      (q) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AstroCard(
                          onTap: () => _send(q),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 17,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                size: 18,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  q,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (!showSuggestions) ...[
                    const SizedBox(height: 20),
                    ...messages.map(_bubble),
                  ],
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _TypingDots(),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                border: Border(top: BorderSide(color: AppColors.softLavender)),
              ),
              child: AstroInput(
                controller: _controller,
                hintText: 'Ask AstroSaathi anything…',
                onSubmitted: loading ? null : _send,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(5),
                  child: IconButton(
                    onPressed: loading ? null : () => _send(_controller.text),
                    icon: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.actionPurple,
                      disabledBackgroundColor: AppColors.highlightSurface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _suggestionsFor(List<String> focusAreas) {
    const prompts = <String, String>{
      'Love & Relationships': 'What relationship pattern should I notice?',
      'Marriage': 'What does my chart show about marriage?',
      'Career': 'How is my current career period?',
      'Money & Wealth': 'What should I know about money right now?',
      'Health & Wellness': 'How can I support my wellbeing today?',
      'Family': 'What patterns are active around family?',
      'Education': 'What supports learning and study right now?',
      'Business': 'What should I prioritize in business?',
      'Spiritual Growth': 'What supports my spiritual growth now?',
      'Life Purpose': 'What theme is guiding my life purpose?',
      'Personal Growth': 'Where is my strongest growth opportunity?',
      'Timing & Decisions': 'What is the best timing theme for decisions?',
    };
    final values =
        focusAreas.map((area) => prompts[area]).whereType<String>().toList()
          ..addAll(const [
            'How is the current transit affecting me?',
            'What should I focus on today?',
            'What theme is shaping my month ahead?',
          ]);
    return values.toSet().take(5).toList();
  }

  Widget _bubble(ChatMessage message) => Align(
    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 310),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: message.isUser
            ? AppColors.secondary
            : message.isError
            ? AppColors.softLavender
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isUser ? 20 : 5),
          bottomRight: Radius.circular(message.isUser ? 5 : 20),
        ),
        border: message.isUser
            ? null
            : Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: TextStyle(
              height: 1.45,
              color: message.isUser ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          if (message.isError)
            TextButton(
              onPressed: () =>
                  ref.read(astroBabaProvider.notifier).retryLastError(),
              child: const Text('Retry'),
            ),
        ],
      ),
    ),
  );
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AstroCard(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (i) => Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(
                alpha: .35 + (((_c.value * 3).floor() % 3) == i ? .65 : 0),
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ),
  );
}
