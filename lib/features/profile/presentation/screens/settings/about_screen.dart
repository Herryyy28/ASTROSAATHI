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
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
        elevation: 0,
        title: Text(
          'About AstroSaathi',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A1F0D), Color(0xFF140E05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x80FFD700),
                      blurRadius: 28,
                      spreadRadius: -2,
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFFFD700),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF1A1407),
                      child: const Center(
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 46,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ),
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
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Version 2.0.0 (Cosmic Edition)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.getTextSecondary(context),
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
                    context: context,
                    title: 'Terms of Service',
                    icon: Icons.description_outlined,
                    onTap: () async {
                      final url = Uri.parse('https://astrosaathi.com/terms');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildListTile(
                    context: context,
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DataPrivacyScreen()),
                      );
                    },
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildListTile(
                    context: context,
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
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildListTile(
                    context: context,
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
                  color: AppColors.getTextMuted(context),
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
    required BuildContext context,
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
          color: AppColors.getTextPrimary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.getTextMuted(context),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
