import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/screens/auth_screen.dart';

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
  ConsumerState<PremiumUpgradeModal> createState() => _PremiumUpgradeModalState();
}

class _PremiumUpgradeModalState extends ConsumerState<PremiumUpgradeModal> {
  PlanTier _selectedTier = PlanTier.yearlyVip;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionProvider);
    final isAlreadyVip = subState.isPremium;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xF20F141C),
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
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 16),

                // Top Header Row with Close Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32),
                    Text(
                      'ASTROSAATHI VIP',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 24),
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
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                       .scale(duration: 1800.ms, begin: const Offset(0.9, 0.9), end: const Offset(1.2, 1.2)),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF382909), Color(0xFF1E1705)],
                          ),
                          border: Border.all(color: const Color(0xFFFFD700), width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x80FFD700),
                              blurRadius: 20,
                            ),
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
                  isAlreadyVip ? 'You Are a VIP Member!' : 'Unlock AstroSaathi VIP',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Premium Features List (Show Value First)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                      _buildFeatureRow(Icons.block_rounded, '100% Ad-Free Experience', 'No banner ads or promotional popups'),
                      _buildFeatureRow(Icons.smart_toy_rounded, 'Unlimited 24/7 AI Astro Baba Chat', 'Free users limited to 5 queries/day'),
                      _buildFeatureRow(Icons.picture_as_pdf_rounded, 'Full 25+ Page Vedic PDF Export', 'High-res downloadable Kundli reports'),
                      _buildFeatureRow(Icons.people_alt_rounded, 'Unlimited Family Birth Profiles', 'Save all your relatives & friends'),
                      _buildFeatureRow(Icons.favorite_rounded, 'Ashtakoot 36-Point Matchmaking', 'Deep compatibility breakdown'),
                      _buildFeatureRow(Icons.auto_awesome_rounded, 'Personalized Gemstones & Puja Guide', 'Custom remedies for your chart'),
                      _buildFeatureRow(Icons.public_rounded, 'Saturn & Rahu/Ketu Transit Alerts', 'In-depth Sade Sati analysis'),
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
                  Builder(builder: (context) {
                    final remainingDays = ref.watch(subscriptionProvider.notifier).remainingDaysOfSubscription;
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFFFD700)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.verified_rounded, color: Color(0xFFFFD700), size: 22),
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
                              side: const BorderSide(color: Color(0xFFFFD700)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.add_shopping_cart_rounded, color: Color(0xFFFFD700)),
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
                  }),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                                  child: CircularProgressIndicator(color: Color(0xFF1E1705), strokeWidth: 2.5),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('👑', style: TextStyle(fontSize: 20)),
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
                ],
                const SizedBox(height: 16),

                // Footer Links
                Row(
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
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54),
                      ),
                    ),
                    const Text('•', style: TextStyle(color: Colors.white24)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Privacy Policy & Terms',
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54),
                      ),
                    ),
                  ],
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

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = tier),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2E2410).withOpacity(0.9)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.12),
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
                          color: Colors.white,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      color: Colors.white70,
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
                color: isSelected ? const Color(0xFFFFD700) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.white54,
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
    final session = ref.read(userSessionProvider);
    if (!session.isAuthenticated) {
      _showAuthRequiredSheet(context);
      return;
    }

    final double amount = _selectedTier == PlanTier.weeklyVip ? 19 : (_selectedTier == PlanTier.monthlyVip ? 49 : 199);
    final String planName = _selectedTier.displayName;

    _showOnlinePaymentGateway(context, amount, planName, session.userId ?? 'user', session.email ?? '');
  }

  void _showAuthRequiredSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: const Color(0xF20B0F19),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To maintain privacy and save your VIP membership receipt, please sign in with your Google Account or Email before payment.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 32, color: Colors.red),
                      label: Text(
                        'Sign In with Google',
                        style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final success = await ref.read(userSessionProvider.notifier).loginWithGoogle();
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
                        side: const BorderSide(color: Colors.white38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.email_rounded, color: Colors.white),
                      label: Text(
                        'Sign In with Email',
                        style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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

  void _showOnlinePaymentGateway(BuildContext context, double amount, String planName, String userId, String userEmail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) {
        return _PaymentGatewaySheet(
          amount: amount,
          planName: planName,
          onPaymentSuccess: () async {
            await ref.read(subscriptionProvider.notifier).processRazorpayPayment(
              _selectedTier,
              userId: userId,
              userEmail: userEmail,
            );
            if (mounted) {
              Navigator.pop(ctx); // Close payment sheet
              Navigator.pop(context); // Close VIP upgrade modal
              _showSuccessDialog();
            }
          },
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141923),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
        ),
        title: Center(
          child: Column(
            children: [
              const Text('🎉👑✨', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                'Welcome to AstroSaathi VIP!',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFD700),
                ),
              ),
            ],
          ),
        ),
        content: Text(
          'Your VIP status is now active. Enjoy 100% ad-free experience, unlimited AI consultation, and premium Vedic report exports!',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF1E1705),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Explore VIP Perks',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentGatewaySheet extends StatefulWidget {
  final double amount;
  final String planName;
  final VoidCallback onPaymentSuccess;

  const _PaymentGatewaySheet({
    required this.amount,
    required this.planName,
    required this.onPaymentSuccess,
  });

  @override
  State<_PaymentGatewaySheet> createState() => _PaymentGatewaySheetState();
}

class _PaymentGatewaySheetState extends State<_PaymentGatewaySheet> {
  int _step = 0; // 0: Select, 1: Connecting/App open, 2: OTP, 3: Success
  bool _acceptedPolicy = true;
  String _selectedMethod = '';
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _cardExpiry = TextEditingController();
  final TextEditingController _cardCvv = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  String _statusMessage = 'Connecting securely with payment provider...';

  @override
  void dispose() {
    _cardNumber.dispose();
    _cardExpiry.dispose();
    _cardCvv.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _processPayment(String method) async {
    if (!_acceptedPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Non-Refundable Policy to proceed.'),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _selectedMethod = method;
      _step = 1;
      _statusMessage = 'Opening $method transaction portal...';
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    if (method == 'Credit / Debit Card') {
      setState(() {
        _step = 2; // Go to OTP entry
      });
    } else {
      setState(() {
        _statusMessage = 'Awaiting payment confirmation from $method...';
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() {
        _step = 3; // Success checkmark
      });
    }
  }

  void _verifyOtp() async {
    if (_otp.text.trim().isEmpty) return;
    setState(() {
      _step = 1;
      _statusMessage = 'Verifying secure OTP with card issuer...';
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() {
      _step = 3; // Success checkmark
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: const Color(0xF20B0F19),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              if (_step == 0) _buildSelectionStep(),
              if (_step == 1) _buildLoaderStep(),
              if (_step == 2) _buildOtpStep(),
              if (_step == 3) _buildSuccessStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Online Checkout',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
              ),
              child: Text(
                'PAY ₹${widget.amount.toStringAsFixed(0)}',
                style: GoogleFonts.outfit(color: const Color(0xFFFFD700), fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text('Plan: ${widget.planName}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 16),
        const Divider(color: Colors.white10, height: 1),
        const SizedBox(height: 16),

        // UPI Options
        const Text('UPI INSTANT PAYMENT', style: TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildUpiAppButton('Google Pay', 'Google Pay', Icons.payment_rounded),
            _buildUpiAppButton('PhonePe', 'PhonePe', Icons.account_balance_wallet_rounded),
            _buildUpiAppButton('Paytm', 'Paytm', Icons.account_balance_rounded),
            _buildUpiAppButton('BHIM UPI', 'BHIM UPI', Icons.qr_code_scanner_rounded),
          ],
        ),
        const SizedBox(height: 20),

        // Card details inputs
        const Text('CREDIT / DEBIT CARD', style: TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
        const SizedBox(height: 10),
        TextField(
          controller: _cardNumber,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Card Number (XXXX XXXX XXXX XXXX)',
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: Colors.white.withOpacity(0.04),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            prefixIcon: const Icon(Icons.credit_card_rounded, color: Colors.white54, size: 20),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cardExpiry,
                keyboardType: TextInputType.datetime,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'MM/YY',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.04),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _cardCvv,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'CVV',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.04),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Terms & Policy Disclosure Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _acceptedPolicy,
                  activeColor: const Color(0xFFFFD700),
                  checkColor: Colors.black,
                  onChanged: (v) => setState(() => _acceptedPolicy = v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'I agree to Terms & Privacy Policy (Non-Refundable 1-Time VIP Pass, No Auto-Renewal)',
                  style: GoogleFonts.outfit(color: Colors.white70, fontSize: 11, height: 1.2),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _acceptedPolicy ? const Color(0xFFFFD700) : Colors.white24,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              if (_cardNumber.text.isNotEmpty) {
                _processPayment('Credit / Debit Card');
              } else {
                _processPayment('Online Checkout');
              }
            },
            child: Text('Pay ₹${widget.amount.toStringAsFixed(0)} Securely', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildUpiAppButton(String display, String method, IconData fallbackIcon) {
    return GestureDetector(
      onTap: () => _processPayment(method),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Icon(fallbackIcon, color: const Color(0xFFFFD700), size: 24),
            const SizedBox(height: 6),
            Text(display, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaderStep() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(color: Color(0xFFFFD700), strokeWidth: 3),
          ),
          const SizedBox(height: 24),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('Do not close the application or press back.', style: TextStyle(color: Colors.white30, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Icon(Icons.shield_rounded, color: Color(0xFFFFD700), size: 40),
          const SizedBox(height: 12),
          Text('Enter 3D Secure OTP', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Enter mock OTP code: 123456 to verify.', style: TextStyle(color: Colors.white54, fontSize: 11), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          TextField(
            controller: _otp,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 6, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: '123456',
              hintStyle: const TextStyle(color: Colors.white24, letterSpacing: 0),
              filled: true,
              fillColor: Colors.white.withOpacity(0.04),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _verifyOtp,
              child: Text('Submit OTP', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Icon(Icons.check_rounded, color: Colors.green, size: 44),
          ),
          const SizedBox(height: 24),
          Text('Payment Successful!', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('₹${widget.amount.toStringAsFixed(0)} received for ${widget.planName}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: widget.onPaymentSuccess,
              child: Text('Unlock VIP Features', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
