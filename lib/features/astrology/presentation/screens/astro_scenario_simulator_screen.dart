import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';

class AstroScenarioSimulatorScreen extends StatefulWidget {
  const AstroScenarioSimulatorScreen({super.key});

  @override
  State<AstroScenarioSimulatorScreen> createState() => _AstroScenarioSimulatorScreenState();
}

class _AstroScenarioSimulatorScreenState extends State<AstroScenarioSimulatorScreen> {
  int _selectedScenarioType = 0; // 0: Location Shift, 1: Timing Shift, 2: Future Date

  // Scenario 0: Location Shift State
  String _originCity = 'Ahmedabad';
  String _targetCity = 'Dubai';

  // Scenario 1: Timing Shift State
  String _timeOptionA = '10:15 AM (Abhijit Muhurat)';
  String _timeOptionB = '02:30 PM (Rahu Kaal Window)';

  // Scenario 2: Future Date State
  String _targetMonth = 'October 2026';

  final List<String> _cities = ['Ahmedabad', 'Dubai', 'London', 'Toronto', 'Mumbai', 'Singapore', 'New York'];

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
              // Top Header
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
                                  'Astro Scenario Simulator',
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
                                  color: AppColors.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
                                ),
                                child: Text(
                                  'LABS',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Simulate location, timing & future date variations',
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

              // Scenario Type Selector Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildTypeChip(0, Icons.flight_takeoff_rounded, 'Location Shift'),
                    const SizedBox(width: 8),
                    _buildTypeChip(1, Icons.access_time_rounded, 'Timing Window'),
                    const SizedBox(width: 8),
                    _buildTypeChip(2, Icons.calendar_month_rounded, 'Future Date'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (_selectedScenarioType == 0) _buildLocationSimulator(context),
                    if (_selectedScenarioType == 1) _buildTimingSimulator(context),
                    if (_selectedScenarioType == 2) _buildFutureDateSimulator(context),
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

  Widget _buildTypeChip(int index, IconData icon, String label) {
    final isSelected = _selectedScenarioType == index;
    return ChoiceChip(
      showCheckmark: false,
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedScenarioType = index),
      avatar: Icon(icon, size: 16, color: isSelected ? Colors.black : AppColors.primary),
      label: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.black : Colors.white,
        ),
      ),
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white.withOpacity(0.06),
      side: BorderSide(color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildLocationSimulator(BuildContext context) {
    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMPARE ASTROCARTOGRAPHY & RELOCATION',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CURRENT LOCATION', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white54)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _originCity,
                          items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.inter(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (val) => setState(() => _originCity = val!),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.06),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 20),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TARGET LOCATION', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white54)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _targetCity,
                          items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.inter(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (val) => setState(() => _targetCity = val!),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.06),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Results Card
        GlassCard(
          padding: const EdgeInsets.all(18),
          borderColor: AppColors.primary.withOpacity(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'SIMULATION VERDICT',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.getTextSecondary(context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                    ),
                    child: Text(
                      'HIGH SYNERGY (▲ +1.4 PTS)',
                      style: GoogleFonts.outfit(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Text(
                'Moving from $_originCity ➔ $_targetCity aligns Jupiter on your Midheaven (10th House).',
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
              ),
              const SizedBox(height: 8),
              Text(
                '• Career Prominence: Boosted by 28% due to zenith angle shift.\n'
                '• Financial Stability: 11th House Lord becomes prominent in zenith.\n'
                '• Emotional Grounding: Moon Remains neutral.',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context), height: 1.4),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.smart_toy_rounded, size: 16),
                  label: Text(
                    'Ask Astro Baba: "Should I move to $_targetCity?"',
                    style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AstroBabaScreen(
                          initialMessage: 'Analyze my natal chart relocation suitability for moving from $_originCity to $_targetCity.',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimingSimulator(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIMING WINDOW COMPARISON',
            style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          _buildTimingOptionCard(context, 'OPTION A (RECOMMENDED)', _timeOptionA, '8.8/10 Score • Abhijit Muhurat • Rahu-free', Colors.greenAccent),
          const SizedBox(height: 12),
          _buildTimingOptionCard(context, 'OPTION B (CAUTION)', _timeOptionB, '4.2/10 Score • Rahu Kaal Active • Gulika Kaal', Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildTimingOptionCard(BuildContext context, String badge, String title, String detail, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(badge, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 2),
          Text(detail, style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildFutureDateSimulator(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FUTURE MONTH PROJECTION: $_targetMonth',
            style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            'Jupiter Mahadasha + Saturn Direct Transit Alignment',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'October 2026 brings an auspicious window for major career milestones, business launch, and long-term asset acquisition.',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context), height: 1.4),
          ),
        ],
      ),
    );
  }
}
