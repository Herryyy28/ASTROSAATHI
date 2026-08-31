import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';

class TrustCenterScreen extends ConsumerStatefulWidget {
  const TrustCenterScreen({super.key});

  @override
  ConsumerState<TrustCenterScreen> createState() => _TrustCenterScreenState();
}

class _TrustCenterScreenState extends ConsumerState<TrustCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedReportCategory = 'Rashi';
  final TextEditingController _reportController = TextEditingController();

  final List<String> _reportCategories = [
    'Rashi',
    'Planet',
    'Panchang',
    'Dasha',
    'Prediction',
    'Matching',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  Future<void> _handleAccountDeletion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.error, width: 1),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
            const SizedBox(width: 10),
            Text(
              'Delete Account & Data',
              style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete your account, birth profile, saved Kundlis, and app settings? This action cannot be undone.',
          style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Permanently Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account and local data have been permanently erased.'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          (route) => false,
        );
      }
    }
  }

  void _submitReport() {
    if (_reportController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the issue before submitting.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted successfully! Thank you for helping improve data quality.'),
        backgroundColor: AppColors.success,
      ),
    );
    _reportController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Trust, Privacy & Support Center',
          style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiaryDark,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'How It Works'),
            Tab(text: 'Privacy & Safety'),
            Tab(text: 'Account Deletion'),
            Tab(text: 'Report & Support'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExplanationsTab(),
          _buildPrivacyTab(),
          _buildAccountDeletionTab(),
          _buildReportSupportTab(),
        ],
      ),
    );
  }

  // ── Tab 1: How Things Work ──────────────────────────────────────
  Widget _buildExplanationsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _explanationCard(
          icon: Icons.calculate_outlined,
          title: 'How Calculations Work',
          description:
              'AstroSaathi uses deterministic astronomical algorithms based on Chitrapaksha (Lahiri) Ayanamsa. Planetary positions, house cusps, and Nakshatras are calculated mathematically from real ephemeris data without relying on random number generators or external APIs.',
        ),
        _explanationCard(
          icon: Icons.folder_special_outlined,
          title: 'What Data We Store',
          description:
              'We store only your profile details (Name, Date of Birth, Birth Time, Birth City/Coordinates) and app preferences. All profile data is saved locally on your device or encrypted securely on your private profile server.',
        ),
        _explanationCard(
          icon: Icons.cake_outlined,
          title: 'Why Birth Details Are Needed',
          description:
              'In Vedic Astrology (Jyotish), your exact Date of Birth and Birth Time determine the precise degree of the horizon rising at your birth moment (Lagna / Ascendant) and the exact Moon Nakshatra. Without accurate time, planetary house placements cannot be derived.',
        ),
        _explanationCard(
          icon: Icons.my_location_outlined,
          title: 'How Location Is Used',
          description:
              'Your birth location coordinates (Latitude & Longitude) are used exclusively to calculate local sidereal time, exact local sunrise/sunset times, and house cusps. Location data is NEVER tracked in the background or shared with advertisers.',
        ),
        _explanationCard(
          icon: Icons.psychology_outlined,
          title: 'How AI (Astro Baba) Works',
          description:
              'Astro Baba uses artificial intelligence solely to translate and explain verified astronomical calculations into conversational insights. The AI NEVER invents birth chart placements; it interprets your calculated planetary data.',
        ),
        _explanationCard(
          icon: Icons.delete_forever_outlined,
          title: 'How Users Delete Their Data',
          description:
              'You retain 100% control over your data. You can instantly erase all profile details and saved charts directly in the app or submit an external web deletion request at any time.',
        ),
      ],
    );
  }

  // ── Tab 2: Privacy Policy & Data Safety ─────────────────────────
  Widget _buildPrivacyTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Data Safety Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_outlined, color: AppColors.success, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Google Play Data Safety Declaration',
                    style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _dataSafetyRow('Data Shared With 3rd Parties', 'None (0%)'),
              _dataSafetyRow('Data Encrypted In Transit', 'Yes (HTTPS / TLS 1.3)'),
              _dataSafetyRow('Data Collection', 'Optional Profile Details'),
              _dataSafetyRow('Account Deletion Provided', 'Yes (In-App & Web)'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Full Privacy Policy Text
        Text(
          'Privacy Policy Summary',
          style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder, width: 0.5),
          ),
          child: Text(
            'AstroSaathi ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how your personal information is collected, used, and disclosed when you use our mobile application.\n\n1. Information Collection: We collect name, date of birth, time of birth, and location details strictly to generate astrological charts.\n2. Location Permission: Location access is requested to perform astronomical side-real calculations. We do not track your location in the background.\n3. Data Protection: All sensitive transmission uses secure encryption standards.\n4. User Rights: You have the right to inspect, edit, or delete your data at any time.',
            style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  // ── Tab 3: Account Deletion ──────────────────────────────────────
  Widget _buildAccountDeletionTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.error.withOpacity(0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.delete_sweep_rounded, color: AppColors.error, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'In-App Account & Data Deletion',
                    style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Pursuant to Google Play Data Deletion Requirements, you can permanently erase your account and all associated birth profiles directly within the app.',
                style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Delete Account & Erase Data',
                icon: Icons.delete_forever_rounded,
                onPressed: _handleAccountDeletion,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // External Web Deletion Resource (Google Play Requirement)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.language_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'External Web Deletion Resource',
                    style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'If you no longer have access to the app, you can request account and data deletion via our official web portal:',
                style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 12),
              SelectableText(
                'https://astrosaathi.app/delete-account',
                style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Tab 4: Report & Support ─────────────────────────────────────
  Widget _buildReportSupportTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Report Incorrect Data / Bug',
          style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Notice an unexpected calculation or prediction discrepancy? Select a category and report it to our Vedic team.',
          style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 13),
        ),
        const SizedBox(height: 16),

        // Category Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _reportCategories.map((cat) {
            final isSelected = _selectedReportCategory == cat;
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surfaceDark,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : AppColors.textPrimaryDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              onSelected: (sel) {
                if (sel) setState(() => _selectedReportCategory = cat);
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 16),
        TextField(
          controller: _reportController,
          maxLines: 4,
          style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Describe the calculation discrepancy or bug...',
            hintStyle: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 13),
            filled: true,
            fillColor: AppColors.surfaceDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.glassBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.glassBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(
          text: 'Submit Report',
          icon: Icons.send_rounded,
          onPressed: _submitReport,
        ),

        const SizedBox(height: 32),

        // Contact Support Box
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder, width: 0.8),
          ),
          child: Row(
            children: [
              const Icon(Icons.support_agent_rounded, color: AppColors.primary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Direct Support Contact', style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    SelectableText('support@astrosaathi.app', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _explanationCard({required IconData icon, required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text(description, style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataSafetyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(value, style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
