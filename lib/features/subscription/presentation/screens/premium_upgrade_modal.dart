import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/services/razorpay_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/screens/auth_screen.dart';
import 'payment_status_screens.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/cosmic_notification.dart';

class PremiumUpgradeModal extends ConsumerStatefulWidget {
  const PremiumUpgradeModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) => const PremiumUpgradeModal(),
    );
  }

  @override
  ConsumerState<PremiumUpgradeModal> createState() =>
      _PremiumUpgradeModalState();
}

class _PremiumUpgradeModalState extends ConsumerState<PremiumUpgradeModal> {
  PlanTier _selectedTier = PlanTier.yearlyVip;
  bool _isProcessing = false;
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionProvider);
    final isAlreadyVip = subState.isPremium;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: isLight
                ? AppColors.surfaceLight.withOpacity(0.96)
                : const Color(0xF20F141C),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            border: Border.all(
              color: const Color(0xFFFFD700).withOpacity(0.4),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x60D4AF37),
                blurRadius: 40,
                spreadRadius: -5,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Modal Handle
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.getTextMuted(context),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 16),

                // Top Header Row with Close Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Expanded(
                      child: Text(
                        'ASTROSAATHI VIP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          color: const Color(0xFFFFD700),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.getTextSecondary(context),
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                // Glowing Crown Emblem
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFFFD700).withOpacity(0.4),
                                  const Color(0xFFD4AF37).withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(
                            duration: 1800.ms,
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.2, 1.2),
                          ),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isLight
                                ? [
                                    const Color(0xFFFFF7E6),
                                    const Color(0xFFFEEDC9),
                                  ]
                                : [
                                    const Color(0xFF382909),
                                    const Color(0xFF1E1705),
                                  ],
                          ),
                          border: Border.all(
                            color: const Color(0xFFFFD700),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0x80FFD700), blurRadius: 20),
                          ],
                        ),
                        child: const Text('👑', style: TextStyle(fontSize: 42)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Main Title & Tagline
                Text(
                  isAlreadyVip
                      ? 'You Are a VIP Member!'
                      : 'Unlock AstroSaathi VIP',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isAlreadyVip
                      ? 'Enjoy 100% ad-free experience, unlimited AI Baba guidance, and complete 25+ page PDF Kundlis.'
                      : 'Get 100% Ad-Free Access, Unlimited AI Consultations & Full 25+ Page Vedic PDF Exports.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.getTextSecondary(context),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Premium Features List (Show Value First)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isLight
                        ? AppColors.getSurfaceSecondary(context)
                        : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.getGlassBorder(context),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VIP INCLUDED PERKS',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureRow(
                        context,
                        Icons.block_rounded,
                        '100% Ad-Free Experience',
                        'No banner ads or promotional popups',
                      ),
                      _buildFeatureRow(
                        context,
                        Icons.smart_toy_rounded,
                        'Unlimited 24/7 AI Astro Baba Chat',
                        'Free users limited to 5 queries/day',
                      ),
                      _buildFeatureRow(
                        context,
                        Icons.picture_as_pdf_rounded,
                        'Full 25+ Page Vedic PDF Export',
                        'High-res downloadable Kundli reports',
                      ),
                      _buildFeatureRow(
                        context,
                        Icons.people_alt_rounded,
                        'Unlimited Family Birth Profiles',
                        'Save all your relatives & friends',
                      ),
                      _buildFeatureRow(
                        context,
                        Icons.favorite_rounded,
                        'Ashtakoot 36-Point Matchmaking',
                        'Deep compatibility breakdown',
                      ),
                      _buildFeatureRow(
                        context,
                        Icons.auto_awesome_rounded,
                        'Personalized Gemstones & Puja Guide',
                        'Custom remedies for your chart',
                      ),
                      _buildFeatureRow(
                        context,
                        Icons.public_rounded,
                        'Saturn & Rahu/Ketu Transit Alerts',
                        'In-depth Sade Sati analysis',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Plan Tiers Selection Cards (Pricing Options)
                if (!isAlreadyVip) ...[
                  _buildPlanCard(
                    tier: PlanTier.weeklyVip,
                    title: 'Weekly VIP',
                    price: '₹19 / week',
                    subtext: '\$0.25/week, cancel anytime',
                    badge: 'TRIAL PASS',
                  ),
                  const SizedBox(height: 12),
                  _buildPlanCard(
                    tier: PlanTier.monthlyVip,
                    title: 'Monthly VIP',
                    price: '₹49 / month',
                    subtext: '\$0.65/month, cancel anytime',
                  ),
                  const SizedBox(height: 12),
                  _buildPlanCard(
                    tier: PlanTier.yearlyVip,
                    title: 'Yearly VIP',
                    price: '₹199 / year',
                    subtext: 'Just ₹16/month (\$2.49/yr)',
                    badge: 'SAVE 60% • BEST VALUE',
                    isRecommended: true,
                  ),
                  const SizedBox(height: 24),
                ],

                // CTA Button (BUY IT Below Price Options)
                if (isAlreadyVip) ...[
                  Builder(
                    builder: (context) {
                      final remainingDays = ref
                          .watch(subscriptionProvider.notifier)
                          .remainingDaysOfSubscription;
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFFFD700),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.verified_rounded,
                                      color: Color(0xFFFFD700),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Active VIP Pass: ${subState.tier.displayName}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFD700),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$remainingDays Days Remaining • Non-Recurring Pass',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFFFD700),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Color(0xFFFFD700),
                              ),
                              label: Text(
                                'RE-BUY / EXTEND VIP PASS',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFFD700),
                                ),
                              ),
                              onPressed: _handleSubscribe,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.goldGlow,
                      ),
                      onPressed: _isProcessing ? null : _handleSubscribe,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: _isProcessing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF1E1705),
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '👑',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'BUY IT - Unlock ${_selectedTier.displayName}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF1B1403),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Footer Links
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Purchases restored successfully!'),
                              backgroundColor: AppColors.surfaceHighlightDark,
                            ),
                          );
                        },
                        child: Text(
                          'Restore Purchases',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ),
                      Text(
                        '•',
                        style: TextStyle(color: AppColors.getTextMuted(context)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Privacy Policy & Terms',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required PlanTier tier,
    required String title,
    required String price,
    required String subtext,
    String? badge,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedTier == tier;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = tier),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isLight
                    ? const Color(0xFFFFF7E6)
                    : const Color(0xFF2E2410).withOpacity(0.9))
              : AppColors.getSurfaceSecondary(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : AppColors.getGlassBorder(context),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Radio<PlanTier>(
              value: tier,
              groupValue: _selectedTier,
              activeColor: const Color(0xFFFFD700),
              onChanged: (val) {
                if (val != null) setState(() => _selectedTier = val);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1A1200),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtext,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? const Color(0xFFFFD700)
                    : AppColors.getTextPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFFD700), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubscribe() async {
    await ref.read(subscriptionProvider.notifier).upgradeToTier(_selectedTier);
    if (mounted) {
      Navigator.pop(context);
      CosmicNotification.showSuccess(
        context,
        title: 'VIP Pass Unlocked! 👑',
        message: '${_selectedTier.displayName} is now active. All VIP features are unlocked.',
      );
    }
  }

  void _showAuthRequiredSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) {
        final isLight = Theme.of(ctx).brightness == Brightness.light;

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: isLight
                  ? AppColors.surfaceLight.withOpacity(0.96)
                  : const Color(0xF20B0F19),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.getTextMuted(ctx),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('🔐', style: TextStyle(fontSize: 44)),
                  const SizedBox(height: 12),
                  Text(
                    'Account Login Required',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(ctx),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To maintain privacy and save your VIP membership receipt, please sign in with your Google Account or Email before payment.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.getTextSecondary(ctx),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLight
                            ? AppColors.surfaceElevatedLight
                            : Colors.white,
                        foregroundColor: AppColors.getTextPrimary(ctx),
                        elevation: isLight ? 1 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: AppColors.getBorder(ctx),
                            width: 0.8,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 32,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Sign In with Google',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(ctx),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final success = await ref
                            .read(userSessionProvider.notifier)
                            .loginWithGoogle();
                        if (success && mounted) {
                          _handleSubscribe();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.getBorder(ctx)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(
                        Icons.email_rounded,
                        color: AppColors.getTextPrimary(ctx),
                      ),
                      label: Text(
                        'Sign In with Email',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(ctx),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _currentOrderId = '';

  Future<void> _startRazorpayCheckout(
    double amount,
    String planName,
    String userId,
    String userEmail,
  ) async {
    setState(() => _isProcessing = true);

    Map<String, dynamic> options;

    try {
      final req = RazorpayPaymentRequest(
        amount: amount,
        planName: planName,
        userId: userId,
        userEmail: userEmail,
        paymentMethod: 'Razorpay Gateway',
      );

      final orderRes = await RazorpayService.instance.createRazorpayOrder(req);

      if (orderRes['success'] == true) {
        _currentOrderId = orderRes['orderId'];
        options = {
          'key': RazorpayConfig.keyId,
          'amount': orderRes['amount'],
          'currency': RazorpayConfig.currency,
          'name': RazorpayConfig.merchantName,
          'order_id': _currentOrderId,
          'description': 'AstroSaathi VIP Subscription - $planName',
          'prefill': {
            'contact': '9876543210',
            'email': userEmail.isNotEmpty ? userEmail : 'user@astrosaathi.com',
          },
          'theme': {'color': '#7C4DFF', 'backdrop_color': '#0A0C16'},
          'retry': {'enabled': true, 'max_count': 3},
          'send_sms_hash': true,
          'external': {
            'wallets': ['paytm'],
          },
        };
      } else {
        throw Exception('Server order failed');
      }
    } catch (e) {
      // Fallback: If backend server order creation fails or times out, launch Razorpay directly
      options = {
        'key': RazorpayConfig.keyId,
        'amount': (amount * 100).toInt(),
        'currency': RazorpayConfig.currency,
        'name': RazorpayConfig.merchantName,
        'description': 'AstroSaathi VIP Subscription - $planName',
        'prefill': {
          'contact': '91xxxxxxxx',
          'email': userEmail.isNotEmpty ? userEmail : 'user@astrosaathi.com',
        },
        'theme': {'color': '#7C4DFF', 'backdrop_color': '#0A0C16'},
        'retry': {'enabled': true, 'max_count': 3},
        'send_sms_hash': true,
        'external': {
          'wallets': ['paytm'],
        },
      };
    }

    try {
      if (_razorpay != null) {
        _razorpay!.open(options);
        return;
      }
    } catch (e) {
      debugPrint('Native Razorpay open error: $e');
    }

    try {
      final launched = await RazorpayService.instance
          .launchRazorpayHostedCheckout(
            orderId: _currentOrderId,
            amount: amount,
            userEmail: userEmail,
          );
      if (launched) {
        if (mounted) {
          setState(() => _isProcessing = false);
          CosmicNotification.show(
            context,
            message: 'Payment opened in browser! Please complete it there.',
            icon: Icons.open_in_browser_rounded,
          );
        }
        return;
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isProcessing = false);
      CosmicNotification.show(
        context,
        message: 'Payment initiation failed. Please try again.',
        icon: Icons.error_outline_rounded,
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;
    setState(() => _isProcessing = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const PaymentProcessingOverlay(),
    );

    final session = ref.read(userSessionProvider);

    final isVerified = await RazorpayService.instance.verifyRazorpayPayment(
      orderId: response.orderId ?? _currentOrderId,
      paymentId: response.paymentId ?? '',
      signature: response.signature ?? '',
      userId: session.userId ?? 'user',
      userEmail: session.email ?? '',
    );

    if (!mounted) return;
    Navigator.pop(context); // close processing overlay

    if (isVerified) {
      await ref
          .read(subscriptionProvider.notifier)
          .grantPremiumAccess(_selectedTier, _currentOrderId);

      Navigator.pop(context); // Close VIP upgrade modal

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            amount: _selectedTier == PlanTier.weeklyVip
                ? 19
                : (_selectedTier == PlanTier.monthlyVip ? 49 : 199),
            planName: _selectedTier.displayName,
            transactionId: response.paymentId ?? '',
            dateStr: DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(
            errorMessage:
                "We couldn't verify your payment with the server. If money was deducted, it will be refunded automatically.",
            onRetry: () {
              Navigator.pop(context);
              _startRazorpayCheckout(
                _selectedTier == PlanTier.weeklyVip
                    ? 19
                    : (_selectedTier == PlanTier.monthlyVip ? 49 : 199),
                _selectedTier.displayName,
                session.userId ?? 'user',
                session.email ?? '',
              );
            },
          ),
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    if (!mounted) return;
    setState(() => _isProcessing = false);

    debugPrint(
      'Razorpay Failure Code: ${response.code}, Message: ${response.message}',
    );

    // If native Razorpay SDK fails (e.g., Key ID not active on native SDK), attempt Web Browser fallback!
    final session = ref.read(userSessionProvider);
    final double amount = _selectedTier == PlanTier.weeklyVip
        ? 19
        : (_selectedTier == PlanTier.monthlyVip ? 49 : 199);

    final launched = await RazorpayService.instance
        .launchRazorpayHostedCheckout(
          orderId: _currentOrderId,
          amount: amount,
          userEmail: session.email ?? '',
        );

    if (launched) {
      if (mounted) {
        CosmicNotification.show(
          context,
          message: 'Opening Razorpay Payment Checkout in your browser...',
          icon: Icons.open_in_browser_rounded,
        );
      }
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentFailedScreen(
          errorMessage: response.message ?? 'Payment cancelled or failed.',
          onRetry: () {
            Navigator.pop(context);
            _startRazorpayCheckout(
              amount,
              _selectedTier.displayName,
              session.userId ?? 'user',
              session.email ?? '',
            );
          },
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    setState(() => _isProcessing = false);
    CosmicNotification.show(
      context,
      message: 'External Wallet Selected: ${response.walletName}',
      icon: Icons.account_balance_wallet_rounded,
    );
  }
}

class _PaymentGatewaySheet extends StatefulWidget {
  final double amount;
  final String planName;
  final String userId;
  final String userEmail;
  final VoidCallback onPaymentSuccess;

  const _PaymentGatewaySheet({
    required this.amount,
    required this.planName,
    required this.userId,
    required this.userEmail,
    required this.onPaymentSuccess,
  });

  @override
  State<_PaymentGatewaySheet> createState() => _PaymentGatewaySheetState();
}

class _PaymentGatewaySheetState extends State<_PaymentGatewaySheet> {
  int _step =
      0; // 0: Razorpay Selection, 1: Creating Razorpay Order, 2: Verifying Signature, 3: Verified Success
  bool _acceptedPolicy = true;
  String _selectedMethod = 'Razorpay Instant UPI';
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _cardExpiry = TextEditingController();
  final TextEditingController _cardCvv = TextEditingController();
  String _statusMessage = 'Initializing Razorpay 256-bit SSL Secure Session...';
  String _razorpayOrderId = '';
  String _razorpayPaymentId = '';

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _cardNumber.dispose();
    _cardExpiry.dispose();
    _cardCvv.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _razorpayPaymentId = response.paymentId ?? '';
      _step = 2; // Verifying Signature
      _statusMessage =
          'Verifying Razorpay HMAC-SHA256 Signature with Bank Server...';
    });

    final isVerified = await RazorpayService.instance.verifyRazorpayPayment(
      orderId: response.orderId ?? _razorpayOrderId,
      paymentId: response.paymentId ?? '',
      signature: response.signature ?? '',
      userId: widget.userId,
      userEmail: widget.userEmail,
    );

    if (!mounted) return;

    if (isVerified) {
      setState(() {
        _step = 3; // Success checkmark
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Razorpay Signature Verification Failed. Please contact support.',
          ),
        ),
      );
      setState(() {
        _step = 0;
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
        backgroundColor: Colors.redAccent,
      ),
    );
    setState(() {
      _step = 0;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
      ),
    );
  }

  void _processRazorpayPayment(String method) async {
    if (!_acceptedPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept Razorpay Gateway Terms & Conditions to proceed.',
          ),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _selectedMethod = method;
      _step = 1;
      _statusMessage = 'Creating Secure Razorpay Order...';
    });

    final req = RazorpayPaymentRequest(
      amount: widget.amount,
      planName: widget.planName,
      userId: widget.userId,
      userEmail: widget.userEmail,
      paymentMethod: method,
    );

    final orderRes = await RazorpayService.instance.createRazorpayOrder(req);

    if (!mounted) return;

    if (orderRes['success'] == true) {
      _razorpayOrderId = orderRes['orderId'];

      var options = {
        'key': RazorpayConfig.keyId,
        'amount': orderRes['amount'], // in paise
        'name': RazorpayConfig.merchantName,
        'order_id': _razorpayOrderId,
        'description': 'Payment for ${widget.planName}',
        'prefill': {
          'contact': '9876543210', // Or dynamically load from user profile
          'email': widget.userEmail,
        },
        'theme': {'color': '#0066FF'},
        'send_sms_hash': true,
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint('Error launching Razorpay: $e');
        setState(() => _step = 0);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create secure Razorpay order.'),
        ),
      );
      setState(() => _step = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          color: isLight
              ? AppColors.surfaceLight.withOpacity(0.96)
              : const Color(0xF2090D16),
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.getTextMuted(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                if (_step == 0) _buildRazorpaySelectionStep(context),
                if (_step == 1) _buildRazorpayLoaderStep(context),
                if (_step == 2) _buildRazorpayVerificationStep(context),
                if (_step == 3) _buildRazorpaySuccessStep(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRazorpaySelectionStep(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Razorpay Header Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isLight ? const Color(0xFFEBF3FF) : const Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0066FF).withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('⚡', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RAZORPAY SECURE GATEWAY',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: const Color(0xFF0066FF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'AstroSaathi Technologies • 256-Bit SSL Encrypted',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppColors.getTextSecondary(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '₹${widget.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF1B1403),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Razorpay Payment Methods Section
        Text(
          'SELECT RAZORPAY PAYMENT METHOD',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: const Color(0xFF0066FF),
          ),
        ),
        const SizedBox(height: 12),

        // Responsive Razorpay UPI Options Row
        Row(
          children: [
            _buildRazorpayOptionButton(
              context,
              'Google Pay',
              'Razorpay UPI (GPay)',
              Icons.account_balance_wallet_rounded,
            ),
            _buildRazorpayOptionButton(
              context,
              'PhonePe',
              'Razorpay UPI (PhonePe)',
              Icons.payment_rounded,
            ),
            _buildRazorpayOptionButton(
              context,
              'Paytm',
              'Razorpay UPI (Paytm)',
              Icons.account_balance_rounded,
            ),
            _buildRazorpayOptionButton(
              context,
              'BHIM UPI',
              'Razorpay UPI (BHIM)',
              Icons.qr_code_scanner_rounded,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Razorpay Card Payment Option
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.getSurfaceSecondary(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.getGlassBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.credit_card_rounded,
                    color: Color(0xFF0066FF),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Credit / Debit Card (Razorpay Gateway)',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Visa • MC • RuPay',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: AppColors.getTextMuted(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _cardNumber,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: AppColors.getTextPrimary(context),
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: 'Card Number (4532 XXXX XXXX 8921)',
                  hintStyle: TextStyle(
                    color: AppColors.getTextMuted(context),
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: isLight ? Colors.white : Colors.black12,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.getGlassBorder(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cardExpiry,
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(
                        color: AppColors.getTextPrimary(context),
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'MM/YY',
                        hintStyle: TextStyle(
                          color: AppColors.getTextMuted(context),
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: isLight ? Colors.white : Colors.black12,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.getGlassBorder(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _cardCvv,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: TextStyle(
                        color: AppColors.getTextPrimary(context),
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        hintStyle: TextStyle(
                          color: AppColors.getTextMuted(context),
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: isLight ? Colors.white : Colors.black12,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.getGlassBorder(context),
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
        const SizedBox(height: 14),

        // Terms & Policy Checkbox
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.getSurfaceSecondary(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.getGlassBorder(context)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _acceptedPolicy,
                  activeColor: const Color(0xFF0066FF),
                  checkColor: Colors.white,
                  onChanged: (v) =>
                      setState(() => _acceptedPolicy = v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'I agree to Razorpay Terms of Service (Non-Refundable 1-Time VIP Pass)',
                  style: GoogleFonts.outfit(
                    color: AppColors.getTextSecondary(context),
                    fontSize: 11,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Single Primary Razorpay Pay Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              if (_cardNumber.text.isNotEmpty) {
                _processRazorpayPayment('Razorpay Card');
              } else {
                _processRazorpayPayment(_selectedMethod);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⚡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Pay ₹${widget.amount.toStringAsFixed(0)} via Razorpay',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRazorpayOptionButton(
    BuildContext context,
    String display,
    String method,
    IconData icon,
  ) {
    final isSelected = _selectedMethod == method;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0066FF).withOpacity(0.12)
                : AppColors.getSurfaceSecondary(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0066FF)
                  : AppColors.getGlassBorder(context),
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF0066FF)
                    : AppColors.getPrimary(context),
                size: 20,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  display,
                  style: GoogleFonts.outfit(
                    color: isSelected
                        ? const Color(0xFF0066FF)
                        : AppColors.getTextSecondary(context),
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRazorpayLoaderStep(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: Color(0xFF0066FF),
              strokeWidth: 3.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AppColors.getTextPrimary(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Razorpay 256-Bit SSL Encrypted Transaction',
            style: TextStyle(
              color: AppColors.getTextMuted(context),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRazorpayVerificationStep(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x1F0066FF),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFF0066FF),
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              color: Color(0xFF0066FF),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AppColors.getTextPrimary(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'End-to-End Secure Processing',
            style: TextStyle(
              color: AppColors.getTextMuted(context),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRazorpaySuccessStep(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.green,
              size: 44,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Razorpay Payment Verified!',
            style: GoogleFonts.outfit(
              color: AppColors.getTextPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Payment ID: $_razorpayPaymentId',
              style: TextStyle(
                color: AppColors.getTextSecondary(context),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: widget.onPaymentSuccess,
              child: Text(
                'Unlock VIP Features',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
