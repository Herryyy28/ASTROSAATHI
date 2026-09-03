import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../../core/services/secure_storage_service.dart';

class SecurityCenterScreen extends StatefulWidget {
  const SecurityCenterScreen({super.key});

  @override
  State<SecurityCenterScreen> createState() => _SecurityCenterScreenState();
}

class _SecurityCenterScreenState extends State<SecurityCenterScreen> {
  bool _isMfaEnabled = false;
  bool _isBiometricEnabled = true;
  bool _isLoading = true;
  List<UserSessionData> _sessions = [];
  List<SecurityLogEvent> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadSecurityData();
  }

  Future<void> _loadSecurityData() async {
    final mfa = await SecureStorageService.isMfaEnabled();
    final bio = await SecureStorageService.isBiometricsEnabled();
    final sessions = await SecureStorageService.getActiveSessions();
    final logs = await SecureStorageService.getSecurityAuditLogs();

    if (mounted) {
      setState(() {
        _isMfaEnabled = mfa;
        _isBiometricEnabled = bio;
        _sessions = sessions;
        _logs = logs;
        _isLoading = false;
      });
    }
  }

  Future<void> _signOutOtherDevices() async {
    await SecureStorageService.signOutOtherSessions();
    final updated = await SecureStorageService.getActiveSessions();
    final logs = await SecureStorageService.getSecurityAuditLogs();
    if (mounted) {
      setState(() {
        _sessions = updated;
        _logs = logs;
      });
      CosmicNotification.show(
        context,
        message: 'Successfully signed out of all other device sessions.',
        icon: Icons.security_rounded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

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
                          Row(
                            children: [
                              Text(
                                'Security Center',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                                ),
                                child: Text(
                                  'PROTECTED',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Manage active sessions, passkeys & authentication security',
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

              // Main Body
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // 1. Security Score Banner
                          GlassCard(
                            padding: const EdgeInsets.all(16),
                            borderColor: Colors.greenAccent.withOpacity(0.4),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.greenAccent.withOpacity(0.15),
                                    border: Border.all(color: Colors.greenAccent, width: 1.5),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.shield_rounded, color: Colors.greenAccent, size: 26),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Account Security Rating: 94%',
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getTextPrimary(context),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Tokens encrypted, passkey enabled, MFA ready.',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          color: AppColors.getTextSecondary(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 2. Active Devices & Sessions
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'ACTIVE SESSIONS (${_sessions.length})',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    color: AppColors.getTextSecondary(context),
                                  ),
                                ),
                              ),
                              if (_sessions.length > 1)
                                TextButton(
                                  onPressed: _signOutOtherDevices,
                                  child: Text(
                                    'Sign Out Others',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          ..._sessions.map((sess) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GlassCard(
                                padding: const EdgeInsets.all(12),
                                borderColor: sess.isCurrent ? AppColors.primary.withOpacity(0.5) : AppColors.getBorder(context),
                                child: Row(
                                  children: [
                                    Icon(
                                      sess.platform.contains('Android') ? Icons.phone_android_rounded : Icons.laptop_windows_rounded,
                                      color: sess.isCurrent ? AppColors.primary : AppColors.getTextSecondary(context),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                sess.deviceName,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.getTextPrimary(context),
                                                ),
                                              ),
                                              if (sess.isCurrent) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    'THIS DEVICE',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 8.5,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          Text(
                                            '${sess.platform} • ${sess.lastActive} • ${sess.location}',
                                            style: GoogleFonts.inter(
                                              fontSize: 10.5,
                                              color: AppColors.getTextMuted(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 20),

                          // 3. Multi-Factor & Authentication Methods
                          Text(
                            'AUTHENTICATION & PASSKEYS',
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
                            child: Column(
                              children: [
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Biometric / Passkey Unlock',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Use Fingerprint / FaceID / Passkey for high-risk actions.',
                                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextMuted(context)),
                                  ),
                                  value: _isBiometricEnabled,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) async {
                                    await SecureStorageService.setBiometricsEnabled(val);
                                    setState(() => _isBiometricEnabled = val);
                                  },
                                ),
                                const Divider(height: 16),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Multi-Factor Verification (MFA)',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Require SMS/Email OTP when signing in on a new device.',
                                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextMuted(context)),
                                  ),
                                  value: _isMfaEnabled,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) async {
                                    await SecureStorageService.setMfaEnabled(val);
                                    setState(() => _isMfaEnabled = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 4. Security Audit Log
                          Text(
                            'RECENT SECURITY AUDIT LOG',
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
                            child: Column(
                              children: _logs.map((log) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 16),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              log.eventType,
                                              style: GoogleFonts.outfit(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.getTextPrimary(context),
                                              ),
                                            ),
                                            Text(
                                              '${log.device} • ${log.timestamp}',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: AppColors.getTextMuted(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        log.status,
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
