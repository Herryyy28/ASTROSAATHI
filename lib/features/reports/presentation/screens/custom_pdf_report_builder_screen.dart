import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../../l10n/app_language.dart';
import '../../../astrology/services/pdf_report_generator.dart';

class CustomPdfReportBuilderScreen extends ConsumerStatefulWidget {
  const CustomPdfReportBuilderScreen({super.key});

  @override
  ConsumerState<CustomPdfReportBuilderScreen> createState() =>
      _CustomPdfReportBuilderScreenState();
}

class _CustomPdfReportBuilderScreenState
    extends ConsumerState<CustomPdfReportBuilderScreen> {
  final Map<String, bool> _selectedSections = {
    'Full Natal Birth Chart (D1 & D9 Navamsha)': true,
    'Vimshottari Dasha 5-Year Forecast': true,
    'Year Ahead 12-Month Forecast': true,
    'Planetary Transit & Sade Sati Analysis': true,
    'Astrocartography & Relocation Suitability': false,
    'Personal Remedies & Gemstone Guidance': true,
    'Astro Baba AI Custom Summary': true,
  };

  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) => AstroDetailScaffold(
    title: 'Custom PDF report',
    subtitle: 'Choose the sections you want in your personal report.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AstroPageIntro(
          icon: Icons.picture_as_pdf_outlined,
          tag: 'PREMIUM REPORT',
          title: 'Build it around your questions',
          subtitle:
              'Create a focused, watermark-free report using the readings most useful to you.',
        ),
        const SizedBox(height: 24),
        const AstroSectionHeader(title: 'Included sections'),
        const SizedBox(height: 12),
        AstroCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: _selectedSections.keys.map((section) {
              final selected = _selectedSections[section]!;
              return CheckboxListTile(
                value: selected,
                onChanged: (value) =>
                    setState(() => _selectedSections[section] = value ?? false),
                title: Text(
                  section,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                activeColor: AppColors.primaryLightMode,
                checkColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        AstroPrimaryButton(
          label: _isGenerating ? 'Generating report…' : 'Generate PDF report',
          icon: Icons.download_rounded,
          loading: _isGenerating,
          onPressed: _isGenerating ? null : _generateReport,
        ),
      ],
    ),
  );

  Future<void> _generateReport() async {
    if (!_selectedSections.values.any((selected) => selected)) {
      CosmicNotification.show(
        context,
        title: 'Select a section',
        message: 'Choose at least one section to include in your report.',
        icon: Icons.checklist_rounded,
      );
      return;
    }

    setState(() => _isGenerating = true);
    final activeProfile = ref.read(activeProfileProvider);
    try {
      await PdfReportGenerator.downloadAndPrintPdf(
        userName: activeProfile.name.isEmpty
            ? 'Astro Seeker'
            : activeProfile.name,
        dob: activeProfile.dob,
        birthTime: activeProfile.birthTime,
        birthPlace: activeProfile.birthPlace,
        language: AppLanguage.english,
        selectedSections: _selectedSections,
      );
      if (!mounted) return;
      CosmicNotification.show(
        context,
        title: 'Report generated',
        message: 'Your custom PDF report is ready to print or save.',
        icon: Icons.picture_as_pdf_rounded,
      );
    } catch (error) {
      if (!mounted) return;
      CosmicNotification.show(
        context,
        title: 'Could not generate report',
        message: error.toString().replaceAll('Exception: ', ''),
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}
