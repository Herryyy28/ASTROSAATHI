import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/nine_languages_modal.dart';
import '../../../home/presentation/screens/main_screen.dart';
import 'kundli_screen.dart';

class NewKundliInputScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const NewKundliInputScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<NewKundliInputScreen> createState() => _NewKundliInputScreenState();
}

class _NewKundliInputScreenState extends ConsumerState<NewKundliInputScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController(text: 'Agra (027N09, 078E00 +5.5)');
  final TextEditingController _kpHoraryController = TextEditingController();

  DateTime _selectedDate = DateTime(2000, 5, 31);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 5, minute: 32);

  String _gender = 'Male';
  bool _shouldSave = true;

  String _ayanamsa = 'N.C.Lahiri';
  final List<String> _ayanamsas = ['N.C.Lahiri', 'B.V. Raman', 'KP Old', 'KP New', 'Sayan'];

  String _dst = '0';
  final List<String> _dstOptions = ['0', '1'];

  @override
  void initState() {
    super.initState();
    // Default to "NEW KUNDLI" tab (Index 1) matching Image 5
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

    final active = ref.read(activeProfileProvider);
    if (active.name.isNotEmpty) {
      _nameController.text = active.name;
      try {
        _selectedDate = DateTime.parse(active.dob);
      } catch (_) {}
      try {
        final parts = active.birthTime.split(':');
        if (parts.length >= 2) {
          _selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      } catch (_) {}
      if (active.birthPlace.isNotEmpty) {
        _placeController.text = active.birthPlace;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _placeController.dispose();
    _kpHoraryController.dispose();
    super.dispose();
  }

  void _onGetHoroscope() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name to generate Kundli.')),
      );
      return;
    }

    if (_shouldSave) {
      final dobStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final timeStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      final newProfile = BirthProfileData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        relationship: 'Self',
        dob: dobStr,
        birthTime: timeStr,
        birthPlace: _placeController.text.trim().isNotEmpty
            ? _placeController.text.trim()
            : 'Agra, India',
        latitude: 27.1767,
        longitude: 78.0081,
        timezone: '5.5',
      );
      ref.read(profilesListProvider.notifier).addProfile(newProfile);
    }

    // Switch to Kundli screen or push
    ref.read(mainNavIndexProvider.notifier).state = 1;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KundliScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final savedProfiles = ref.watch(profilesListProvider);

    final bodyContent = Column(
      children: [
        if (!widget.isEmbedded) _buildAppBar(context),

            // ── Tabs: SAVED KUNDLI | NEW KUNDLI ──────────────────
            _buildTabs(context),

            // ── Tab Views ──────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildSavedKundliList(savedProfiles, isLight),
                  _buildNewKundliForm(context, isLight), // Image 5 Form
                ],
              ),
            ),
          ],
        );

    if (widget.isEmbedded) {
      return Container(
        color: isLight ? const Color(0xFFF9F9F9) : AppColors.backgroundDark,
        child: bodyContent,
      );
    }

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF9F9F9) : AppColors.backgroundDark,
      body: SafeArea(
        child: bodyContent,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF5A623), // AstroSage Golden Yellow
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: () => NineLanguagesModal.show(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Predictions',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black87, size: 26),
            onPressed: () {
              ref.read(mainNavIndexProvider.notifier).state = 0;
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFFFF9800),
        indicatorWeight: 3.5,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.black54,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'SAVED KUNDLI'),
          Tab(text: 'NEW KUNDLI'),
        ],
      ),
    );
  }

  Widget _buildNewKundliForm(BuildContext context, bool isLight) {
    final dateFormat = DateFormat('dd - MMM - yyyy');
    final formattedDate = dateFormat.format(_selectedDate).toUpperCase();
    final formattedTime = _selectedTime.format(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Name Field ─────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline_rounded, color: Colors.black87, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(color: Colors.grey),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFB74D)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF9800), width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Date & Time Pickers Side-by-Side ───────────────────
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: Colors.black87, size: 22),
              const SizedBox(width: 14),
              // Date Box
              Expanded(
                flex: 6,
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(1930),
                      lastDate: DateTime(2035),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isLight ? Colors.white : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFB74D), width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        formattedDate,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Time Box
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) {
                      setState(() => _selectedTime = picked);
                    }
                  },
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isLight ? Colors.white : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFB74D), width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        formattedTime,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Place of Birth Field ───────────────────────────────
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.black87, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isLight ? Colors.white : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFB74D), width: 1.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _placeController.text,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextPrimary(context),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Gender Toggle: [Male] / [Female] ────────────────────
          Row(
            children: [
              const Icon(Icons.transgender_rounded, color: Colors.black87, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isLight ? Colors.white : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFB74D), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _gender = 'Male'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _gender == 'Male'
                                  ? const Color(0xFFF5A623) // Active orange/gold
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                            ),
                            child: Center(
                              child: Text(
                                'Male',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _gender == 'Male' ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _gender = 'Female'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _gender == 'Female'
                                  ? const Color(0xFFF5A623)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
                            ),
                            child: Center(
                              child: Text(
                                'Female',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _gender == 'Female' ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Save Checkbox & Settings Link ──────────────────────
          Row(
            children: [
              const SizedBox(width: 34),
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _shouldSave,
                  activeColor: const Color(0xFFE65100),
                  onChanged: (val) => setState(() => _shouldSave = val ?? true),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Save',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Text(
                  'Settings —',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFE65100)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Other Calc. Options ────────────────────────────────
          Text(
            'Other Calc. Options',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 8),

          // KP Horary No.
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'KP Horary No.',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 6,
                child: TextField(
                  controller: _kpHoraryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '(1-249)',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFB74D)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Ayanamsa Selector
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Ayanamsa',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 6,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _ayanamsa,
                    isDense: true,
                    items: _ayanamsas.map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _ayanamsa = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // D.S.T.
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'D.S.T.',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 6,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _dst,
                    isDense: true,
                    items: _dstOptions.map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _dst = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── Big Orange CTA Button: GET HOROSCOPE ───────────────
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE65100), // AstroSage Bright Orange
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _onGetHoroscope,
              child: Text(
                'GET HOROSCOPE',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedKundliList(List<BirthProfileData> profiles, bool isLight) {
    if (profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search_rounded, size: 54, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'No Saved Kundlis',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Create a new horoscope to save it here for instant access.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: profiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final p = profiles[index];
        return Material(
          color: isLight ? Colors.white : AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.getGlassBorder(context)),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFFF3E0),
              child: Text(
                p.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(p.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            subtitle: Text('${p.dob} • ${p.birthPlace}'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {
              ref.read(activeProfileIndexProvider.notifier).state = index;
              ref.read(mainNavIndexProvider.notifier).state = 1;
              Navigator.push(context, MaterialPageRoute(builder: (_) => const KundliScreen()));
            },
          ),
        );
      },
    );
  }
}
