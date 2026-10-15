import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final double amount;
  final String planName;
  final String transactionId;
  final String dateStr;

  const PaymentSuccessScreen({
    super.key,
    required this.amount,
    required this.planName,
    required this.transactionId,
    required this.dateStr,
  });

  @override
  Widget build(BuildContext context) {
    final isDemo = transactionId.startsWith('DEMO_');
    return AstroScaffold(
      child: _PaymentResultLayout(
        icon: Icons.check_rounded,
        eyebrow: isDemo ? 'DEMO ONLY' : 'PAYMENT COMPLETE',
        title: isDemo ? 'Premium preview active' : 'You’re all set',
        message: isDemo
            ? 'No payment was processed. Premium access is enabled locally for this demo.'
            : 'Your AstroSaathi access is active and ready to explore.',
        iconColor: AppColors.secondary,
        details: [
          ('Amount', '₹${amount.toStringAsFixed(0)}'),
          ('Plan', planName),
          ('Transaction ID', transactionId),
          ('Date', dateStr),
        ],
        primaryLabel: isDemo
            ? 'Explore demo features'
            : 'Explore premium features',
        onPrimary: () => Navigator.pop(context),
      ),
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const PaymentFailedScreen({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => AstroScaffold(
    child: _PaymentResultLayout(
      icon: Icons.close_rounded,
      eyebrow: 'PAYMENT NOT COMPLETED',
      title: 'Let’s try that again',
      message: errorMessage.isNotEmpty
          ? errorMessage
          : 'We couldn’t complete your payment. No charge was confirmed.',
      iconColor: AppColors.pink,
      primaryLabel: 'Retry payment',
      onPrimary: onRetry,
      secondaryLabel: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    ),
  );
}

class _PaymentResultLayout extends StatelessWidget {
  const _PaymentResultLayout({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.message,
    required this.iconColor,
    required this.primaryLabel,
    required this.onPrimary,
    this.details = const [],
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String message;
  final Color iconColor;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final List<(String, String)> details;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight - 56),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Icon(icon, color: iconColor, size: 38),
                ),
                const SizedBox(height: 24),
                Text(
                  eyebrow,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.primaryLightMode,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  AstroCard(
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < details.length;
                          index++
                        ) ...[
                          _DetailRow(
                            label: details[index].$1,
                            value: details[index].$2,
                          ),
                          if (index != details.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                AstroPrimaryButton(label: primaryLabel, onPressed: onPrimary),
                if (secondaryLabel != null && onSecondary != null) ...[
                  const SizedBox(height: 10),
                  AstroSecondaryButton(
                    label: secondaryLabel!,
                    onPressed: onSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ),
      const SizedBox(width: 16),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ),
    ],
  );
}

class PaymentProcessingOverlay extends StatelessWidget {
  const PaymentProcessingOverlay({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.textPrimaryLight.withValues(alpha: 0.32),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: const AstroCard(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Confirming your payment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please keep this screen open for a moment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textSecondaryLight,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
