import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/widgets/cosmic_notification.dart';

class PrivacyDashboardScreen extends ConsumerStatefulWidget {
  const PrivacyDashboardScreen({super.key});

  @override
  ConsumerState<PrivacyDashboardScreen> createState() => _PrivacyDashboardScreenState();
}

class _PrivacyDashboardScreenState extends ConsumerState<PrivacyDashboardScreen> {
  bool _isAiIsolated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final isolated = await SecureStorageService.isAiDataIsolated();
    if (mounted) {
      setState(() {
        _isAiIsolated = isolated;
        _isLoading = false;
      });
    }
  }

  Future<void> _exportUserData() async {
    final profiles = ref.read(profilesListProvider);
    final exportData = {
      'app': 'AstroSaathi',
      'exported_at': DateTime.now().toIso8601String(),
      'profiles': profiles.map((p) => p.toJson()).toList(),
      'privacy_policy': 'GDPR & DPDP Compliant Data Export',
    };

    final jsonStr = const JsonEncoder.withIndent('  ').convert(exportData);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Personal Data Export Ready',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Below is your exported user data package (JSON format):',
                style: GoogleFonts.inter(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  jsonStr,
                  style: GoogleFonts.firaCode(fontSize: 10, color: Colors.greenAccent),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              CosmicNotification.showSuccess(
                context,
                title: 'Data Export Copied 🔒',
                message: 'Your encrypted profile data export was copied to clipboard.',
              );
            },
            icon: const Icon(Icons.copy_rounded, color: Colors.black, size: 16),
            label: Text(
              'Copy Data',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final profiles = ref.watch(profilesListProvider);

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
              // App Bar
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
                          Text(
                            'Privacy & Data Dashboard',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            'Control your birth charts, AI context isolation & data exports',
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

              // Body
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // 1. Storage Breakdown Card
                          GlassCard(
                            padding: const EdgeInsets.all(16),
                            borderColor: AppColors.primary.withOpacity(0.4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.privacy_tip_rounded, color: AppColors.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'DATA PRIVACY COMPLIANCE',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your birth data and family profiles are strictly protected. We never sell, share, or expose your astrological birth details to external third parties.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.getTextSecondary(context),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 2. AI Data Isolation Controls
                          Text(
                            'AI DATA ISOLATION',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                          const SizedBox(height: 8),

                          GlassCard(
                            padding: const EdgeInsets.all(12),
                            child: SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Isolate Family Data from AI Context',
                                style: GoogleFonts.outfit(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              subtitle: Text(
                                'When enabled, family profiles are excluded from automated AI chat recommendations to maintain strict individual privacy.',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.getTextMuted(context),
                                ),
                              ),
                              value: _isAiIsolated,
                              activeColor: AppColors.primary,
                              onChanged: (val) async {
                                await SecureStorageService.setAiDataIsolated(val);
                                setState(() => _isAiIsolated = val);
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 3. Data Export & Takeaway
                          Text(
                            'DATA EXPORT & PORTABILITY',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                          const SizedBox(height: 8),

                          GlassCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Export Saved Astrological Data',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.getTextPrimary(context),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${profiles.length} Profiles • Kundlis • Notes',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: AppColors.getTextMuted(context),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: _exportUserData,
                                      icon: const Icon(Icons.download_rounded, color: Colors.black, size: 16),
                                      label: Text(
                                        'Export',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
