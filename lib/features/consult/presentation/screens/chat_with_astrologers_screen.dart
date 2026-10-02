import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../search/presentation/widgets/astro_command_center_modal.dart';
import '../../data/models/astrologer_model.dart';
import 'personal_astrologer_chat_screen.dart';

class ChatWithAstrologersScreen extends ConsumerStatefulWidget {
  const ChatWithAstrologersScreen({super.key});

  @override
  ConsumerState<ChatWithAstrologersScreen> createState() => _ChatWithAstrologersScreenState();
}

class _ChatWithAstrologersScreenState extends ConsumerState<ChatWithAstrologersScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Vedic Astrology',
    'KP System',
    'Lal Kitab',
    'Numerology',
    'Tarot',
  ];

  bool _isSearching = false;
  String _searchQuery = '';

  List<Astrologer> get _filteredAstrologers {
    final list = AstrologerRepository.directoryAstrologers;
    var filtered = list;

    if (_selectedFilter != 'All') {
      if (_selectedFilter == 'Vedic Astrology') {
        filtered = filtered.where((a) => a.category == AstrologerCategory.vedic || a.category == AstrologerCategory.marriage).toList();
      } else if (_selectedFilter == 'KP System') {
        filtered = filtered.where((a) => a.category == AstrologerCategory.kpSystem).toList();
      } else if (_selectedFilter == 'Lal Kitab') {
        filtered = filtered.where((a) => a.category == AstrologerCategory.lalKitab).toList();
      } else if (_selectedFilter == 'Numerology') {
        filtered = filtered.where((a) => a.category == AstrologerCategory.numerology).toList();
      }
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) => a.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFFBFBFB) : AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            _buildAppBar(context),

            // Horizontal Filter Chips
            if (!_isSearching) _buildFiltersBar(),

            // Astrologer Cards List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 90),
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredAstrologers.length,
                separatorBuilder: (_, __) => Divider(height: 1, indent: 84, color: AppColors.getGlassBorder(context)),
                itemBuilder: (context, index) {
                  final a = _filteredAstrologers[index];
                  return _buildAstrologerListCard(a, isLight);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        border: Border(bottom: BorderSide(color: AppColors.getGlassBorder(context), width: 0.8)),
      ),
      child: _isSearching
          ? Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.getTextPrimary(context),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchQuery = '';
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: TextStyle(color: AppColors.getTextPrimary(context)),
                    decoration: InputDecoration(
                      hintText: 'Search Astrologer...',
                      hintStyle: TextStyle(color: AppColors.getTextSecondary(context)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                if (Navigator.canPop(context)) ...[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.getTextPrimary(context),
                    onPressed: () => Navigator.pop(context),
                  ),
                ] else ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFFF9800), size: 22),
                  ),
                ],
                Expanded(
                  child: Text(
                    'AstroSaathi Consult',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFF6D00),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined, size: 22),
                  color: AppColors.getTextSecondary(context),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filter by experience, language and price active.')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded, size: 22),
                  color: AppColors.getTextSecondary(context),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildFiltersBar() {
    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF6D00) : AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFF6D00) : AppColors.getGlassBorder(context),
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAstrologerListCard(Astrologer a, bool isLight) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PersonalAstrologerChatScreen(astrologer: a),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Avatar like WhatsApp
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [a.primaryAccent, const Color(0xFFFF8F00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      a.name.substring(0, 1),
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // WhatsApp online dot (bottom right)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366), // WhatsApp Green
                      shape: BoxShape.circle,
                      border: Border.all(color: isLight ? Colors.white : AppColors.surfaceDark, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            // Name and Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          a.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '12:45 PM', // Mocked time for WhatsApp feel
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.getTextMuted(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.done_all, size: 16, color: Color(0xFF34B7F1)), // WhatsApp blue ticks
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${a.specialty} expert available for chat.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.getTextSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
