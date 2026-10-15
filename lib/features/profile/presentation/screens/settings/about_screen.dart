import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/astro_components.dart';
import 'data_privacy_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => AstroDetailScaffold(
    title: 'About AstroSaathi',
    child: Column(
      children: [
        const AstroPageIntro(
          icon: Icons.auto_awesome_rounded,
          tag: 'ASTROSAATHI',
          title: 'Astrology, made personal',
          subtitle:
              'Thoughtful Vedic guidance, practical daily insights, and your celestial tools in one calm space.',
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Container(
                width: 82,
                height: 82,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D25283A),
                      blurRadius: 18,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primaryLightMode,
                      size: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Version 2.0.0',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AstroCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            children: [
              _AboutRow(
                icon: Icons.description_outlined,
                title: 'Terms of service',
                onTap: () => _launch('https://astrosaathi.com/terms'),
              ),
              const Divider(),
              _AboutRow(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy policy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DataPrivacyScreen()),
                ),
              ),
              const Divider(),
              _AboutRow(
                icon: Icons.support_agent_rounded,
                title: 'Contact support',
                onTap: () => _launch(
                  'mailto:support@astrosaathi.com?subject=AstroSaathi%20Support%20Request',
                ),
              ),
              const Divider(),
              _AboutRow(
                icon: Icons.star_outline_rounded,
                title: 'Rate the app',
                onTap: () => _launch(
                  'https://play.google.com/store/apps/details?id=com.astrosaathi.app',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Made with care for your cosmic journey',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    ),
  );

  Future<void> _launch(String value) async {
    final uri = Uri.parse(value);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    minVerticalPadding: 14,
    leading: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.softLavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.primaryLightMode, size: 20),
    ),
    title: Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
    ),
    trailing: const Icon(
      Icons.chevron_right_rounded,
      color: AppColors.textSecondaryLight,
    ),
  );
}
