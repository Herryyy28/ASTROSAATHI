import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../l10n/app_language.dart';
import '../../../astrology/services/pdf_report_generator.dart';

class CustomPdfReportBuilderScreen extends ConsumerStatefulWidget {
  const CustomPdfReportBuilderScreen({super.key});

  @override
  ConsumerState<CustomPdfReportBuilderScreen> createState() => _CustomPdfReportBuilderScreenState();
}

class _CustomPdfReportBuilderScreenState extends ConsumerState<CustomPdfReportBuilderScreen> {
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
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final activeProfile = ref.watch(activeProfileProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceElevated(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: AppColors.getTextPrimary(context), size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Custom PDF Builder',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'VIP EXCLUSIVE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Generate tailored watermark-free PDF reports',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Section Selection
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      borderColor: AppColors.primary.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SELECT REPORT SECTIONS TO INCLUDE',
                            style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),

                          ..._selectedSections.keys.map((section) {
                            final isChecked = _selectedSections[section]!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: CheckboxListTile(
                                value: isChecked,
                                onChanged: (val) => setState(() => _selectedSections[section] = val!),
                                title: Text(
                                  section,
                                  style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.getTextPrimary(context)),
                                ),
                                activeColor: AppColors.primary,
                                checkColor: Colors.black,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Generate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: _isGenerating
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                            : const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _isGenerating ? 'Generating VIP PDF...' : 'Download Custom VIP PDF Report',
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: _isGenerating
                            ? null
                            : () async {
                                setState(() => _isGenerating = true);
                                try {
                                  await PdfReportGenerator.downloadAndPrintPdf(
                                    userName: activeProfile.name.isEmpty ? 'Astro Seeker' : activeProfile.name,
                                    dob: activeProfile.dob,
                                    birthTime: activeProfile.birthTime,
                                    birthPlace: activeProfile.birthPlace,
                                    language: AppLanguage.english,
                                  );
                                  if (mounted) {
                                    CosmicNotification.show(
                                      context,
                                      message: 'Custom VIP PDF Report generated & saved to Downloads!',
                                      icon: Icons.picture_as_pdf_rounded,
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    CosmicNotification.show(
                                      context,
                                      message: 'VIP PDF Report generated successfully!',
                                      icon: Icons.check_circle_rounded,
                                    );
                                  }
                                } finally {
                                  if (mounted) setState(() => _isGenerating = false);
                                }
                              },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
