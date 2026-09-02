import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../kundli/presentation/screens/kundli_screen.dart';
import '../../../explore/presentation/screens/explore_screen.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../../l10n/app_localizations.dart';

/// Provider for managing main navigation tab index globally
final mainNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    KundliScreen(),
    ExploreScreen(),
    AstroBabaScreen(),
    ProfileScreen(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: 'Kundli'),
    _NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Explore'),
    _NavItem(icon: Icons.psychology_outlined, activeIcon: Icons.psychology_rounded, label: 'Astro AI'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  String _getNavLabel(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context, ref);
    switch (index) {
      case 0:
        return l10n.navHome;
      case 1:
        return l10n.navKundli;
      case 2:
        return l10n.navExplore;
      case 3:
        return l10n.navAstroAi;
      case 4:
        return l10n.navProfile;
      default:
        return _navItems[index].label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawIndex = ref.watch(mainNavIndexProvider);
    final currentIndex = (rawIndex >= 0 && rawIndex < _screens.length) ? rawIndex : 0;

    if (!context.isMobile) {
      return _buildWideLayout(context, currentIndex);
    }
    return _buildMobileLayout(context, currentIndex);
  }

  Widget _buildMobileLayout(BuildContext context, int currentIndex) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: _screens,
          ),

          // Floating Glass Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(context, currentIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, int currentIndex) {
    final isDesktop = context.isDesktop;
    final railWidth = isDesktop ? 220.0 : 80.0;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: Row(
          children: [
            _buildSideRail(context, isDesktop, railWidth, currentIndex),
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideRail(BuildContext context, bool isDesktop, double width, int currentIndex) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final railBgColor = isLight
        ? AppColors.surfaceLight.withOpacity(0.94)
        : const Color(0x1A0F1219);
    final railBorderColor = isLight ? AppColors.borderLight : AppColors.glassBorder;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: railBgColor,
            border: Border(right: BorderSide(color: railBorderColor, width: 0.5)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                if (isDesktop) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.goldGradient,
                          ),
                          child: const Center(
                            child: Text('✦', style: TextStyle(fontSize: 14, color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'AstroSaathi',
                          style: TextStyle(
                            color: AppColors.getTextPrimary(context),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ] else ...[
                  const SizedBox(height: 8),
                ],
                Expanded(
                  child: ListView.builder(
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      return _buildSideNavItem(index, isDesktop, currentIndex);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideNavItem(int index, bool isDesktop, int currentIndex) {
    final isActive = currentIndex == index;
    final item = _navItems[index];
    final isLight = Theme.of(context).brightness == Brightness.light;
    final activeColor = AppColors.getPrimary(context);
    final inactiveColor = isLight ? AppColors.textMutedLight : AppColors.textTertiaryDark;
    final inactiveLabelColor = isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;

    return GestureDetector(
      onTap: () {
        if (currentIndex != index) {
          ref.read(mainNavIndexProvider.notifier).state = index;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 14 : 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(color: activeColor.withOpacity(0.30), width: 0.8)
              : null,
        ),
        child: Row(
          mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                color: isActive ? activeColor : inactiveColor,
                size: 22,
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 12),
              Text(
                _getNavLabel(context, index),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? activeColor : inactiveLabelColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final navBgColor = isLight
        ? AppColors.surfaceLight.withOpacity(0.96)
        : AppColors.surfaceDark.withOpacity(0.96);
    final navBorderColor = isLight ? AppColors.borderLight : AppColors.glassBorder;
    final shadowOpacity = isLight ? 0.10 : 0.40;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: BoxDecoration(
        color: navBgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: navBorderColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (index) {
                  return Expanded(
                    child: _buildBottomNavItem(context, index, currentIndex),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(BuildContext context, int index, int currentIndex) {
    final isActive = currentIndex == index;
    final item = _navItems[index];
    final isLight = Theme.of(context).brightness == Brightness.light;

    final activeColor = AppColors.getPrimary(context);
    final inactiveColor = isLight ? AppColors.textMutedLight : AppColors.textTertiaryDark;

    return GestureDetector(
      onTap: () {
        if (currentIndex != index) {
          ref.read(mainNavIndexProvider.notifier).state = index;
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Active Capsule Background
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 48 : 36,
              height: 28,
              decoration: BoxDecoration(
                color: isActive
                    ? activeColor.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isActive
                    ? Border.all(
                        color: activeColor.withOpacity(0.40),
                        width: 1.0,
                      )
                    : null,
              ),
              child: Center(
                child: AnimatedScale(
                  scale: isActive ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    isActive ? item.activeIcon : item.icon,
                    color: isActive ? activeColor : inactiveColor,
                    size: 19,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
                letterSpacing: isActive ? 0.2 : 0,
              ),
              child: Text(
                _getNavLabel(context, index),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
