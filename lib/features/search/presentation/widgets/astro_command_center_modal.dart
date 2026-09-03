import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../astrology/presentation/screens/astro_decision_engine_screen.dart';
import '../../../astrology/presentation/screens/transit_center_screen.dart';
import '../../../kundli/presentation/screens/kundli_screen.dart';

class AstroCommandCenterModal extends StatefulWidget {
  const AstroCommandCenterModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => const AstroCommandCenterModal(),
    );
  }

  @override
  State<AstroCommandCenterModal> createState() => _AstroCommandCenterModalState();
}

class _AstroCommandCenterModalState extends State<AstroCommandCenterModal> {
  final TextEditingController _commandController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> _quickCommands = [
    {
      'icon': Icons.lightbulb_outline_rounded,
      'label': 'What should I know today?',
      'category': 'Daily Insights',
      'action': 'ai',
      'query': 'What is my most important cosmic focus and energy score insight today?',
    },
    {
      'icon': Icons.event_available_rounded,
      'label': 'When should I schedule my interview?',
      'category': 'Best Timing',
      'action': 'decision',
      'categoryFilter': 'Career',
    },
    {
      'icon': Icons.psychology_rounded,
      'label': 'Explain Saturn in my chart',
      'category': 'Kundli AI',
      'action': 'ai',
      'query': 'Explain Saturn position in my birth chart, house lord dynamics, and core lessons.',
    },
    {
      'icon': Icons.rotate_right_rounded,
      'label': 'Show my next important transit',
      'category': 'Transits',
      'action': 'transit',
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'label': 'What changed in my score today?',
      'category': 'Daily Delta',
      'action': 'ai',
      'query': 'Why did my cosmic score change today? Explain Moon transit and Panchang shift.',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _commandController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _executeCommand(String query, {String action = 'ai', String? categoryFilter}) {
    Navigator.pop(context);

    if (action == 'decision') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AstroDecisionEngineScreen()),
      );
    } else if (action == 'transit') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TransitCenterScreen()),
      );
    } else if (action == 'kundli') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KundliScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AstroBabaScreen(initialMessage: query),
        ),
      );
    }
  }

  void _handleSubmit() {
    final text = _commandController.text.trim();
    if (text.isEmpty) return;

    final lower = text.toLowerCase();
    if (lower.contains('interview') || lower.contains('business') || lower.contains('timing') || lower.contains('when should')) {
      _executeCommand(text, action: 'decision');
    } else if (lower.contains('transit') || lower.contains('gochar')) {
      _executeCommand(text, action: 'transit');
    } else if (lower.contains('kundli') || lower.contains('house') || lower.contains('dasha')) {
      _executeCommand(text, action: 'kundli');
    } else {
      _executeCommand(text, action: 'ai');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLight
              ? AppColors.surfaceLight.withOpacity(0.96)
              : const Color(0xFF0D121F),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.getGlassBorder(context), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isLight
                  ? Colors.black.withOpacity(0.1)
                  : const Color(0x60000000),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle & Title
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.getTextMuted(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.goldGradient,
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Colors.black, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Astro Command Center',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                      Text(
                        'One command box for chart guidance, timing & AI',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(context), size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Command Input Box
            TextField(
              controller: _commandController,
              focusNode: _focusNode,
              onSubmitted: (_) => _handleSubmit(),
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.getTextPrimary(context)),
              decoration: InputDecoration(
                hintText: 'Type any question or command... e.g., "Explain Saturn"',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.getTextMuted(context)),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
                  onPressed: _handleSubmit,
                ),
                filled: true,
                fillColor: AppColors.getSurfaceElevated(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.getBorder(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 18),

            // Quick Preset Commands Header
            Text(
              'QUICK COMMAND PRESETS',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),

            // Command Chips List
            Column(
              children: _quickCommands.map((cmd) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      _executeCommand(
                        cmd['query'] ?? cmd['label'],
                        action: cmd['action'],
                        categoryFilter: cmd['categoryFilter'],
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: isLight
                            ? AppColors.getSurfaceSecondary(context)
                            : Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.getGlassBorder(context)),
                      ),
                      child: Row(
                        children: [
                          Icon(cmd['icon'] as IconData, color: AppColors.primary, size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              cmd['label'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.getTextPrimary(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cmd['category'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded, color: AppColors.getTextMuted(context), size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
