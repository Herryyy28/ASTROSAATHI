import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data_privacy_screen.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/responsive_layout.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'About AstroSaathi',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryDark,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: ResponsiveLayout(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldSubtleGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldGlow,
                      blurRadius: 30,
                      spreadRadius: -5,
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('✦', style: TextStyle(fontSize: 48, color: AppColors.primary))),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'AstroSaathi',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Version 2.0.0 (Cosmic Edition)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ),
            const SizedBox(height: 48),
            GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildListTile(
                    title: 'Terms of Service',
                    icon: Icons.description_outlined,
                    onTap: () async {
                      final url = Uri.parse('https://astrosaathi.com/terms');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  Divider(color: AppColors.glassBorder),
                  _buildListTile(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DataPrivacyScreen()),
                      );
                    },
                  ),
                  Divider(color: AppColors.glassBorder),
                  _buildListTile(
                    title: 'Contact Support',
                    icon: Icons.support_agent_rounded,
                    onTap: () async {
                      final url = Uri(
                        scheme: 'mailto',
                        path: 'support@astrosaathi.com',
                        query: 'subject=AstroSaathi%20Support%20Request',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  Divider(color: AppColors.glassBorder),
                  _buildListTile(
                    title: 'Rate App',
                    icon: Icons.star_border_rounded,
                    onTap: () async {
                      // Note: Update with actual app store link
                      final url = Uri.parse('market://details?id=com.astrosaathi.app');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        final webUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.astrosaathi.app');
                        if (await canLaunchUrl(webUrl)) {
                          await launchUrl(webUrl);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Made with ❤️ & 🌌',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textTertiaryDark,
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiaryDark,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
