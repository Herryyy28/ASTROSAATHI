import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

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
    final primaryColor = AppColors.getPrimary(context);
    const textColor = Color(0xFF0D131F);

    return Scaffold(
      backgroundColor: AppColors.getSurface(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Successful',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: GoogleFonts.outfit(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceSecondary(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.getGlassBorder(context)),
                ),
                child: Column(
                  children: [
                    _buildRow(context, 'Product', planName),
                    Divider(height: 24, color: AppColors.getDivider(context)),
                    _buildRow(context, 'Transaction ID', transactionId),
                    Divider(height: 24, color: AppColors.getDivider(context)),
                    _buildRow(context, 'Date', dateStr),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Explore VIP Perks',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppColors.getTextSecondary(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimary(context),
            ),
          ),
        ),
      ],
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
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimary(context);
    const textColor = Color(0xFF0D131F);

    return Scaffold(
      backgroundColor: AppColors.getSurface(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 72),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Failed',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage.isNotEmpty ? errorMessage : 'We couldn\'t complete your payment. Please try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: onRetry,
                  child: Text(
                    'Retry Payment',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: AppColors.getTextSecondary(context),
                    fontWeight: FontWeight.w600,
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

class PaymentProcessingOverlay extends StatelessWidget {
  const PaymentProcessingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.getSurfaceSecondary(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.getGlassBorder(context)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.getPrimary(context)),
              const SizedBox(height: 24),
              Text(
                'Processing payment',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we confirm your transaction.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppColors.getTextSecondary(context),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

