import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../horoscope/presentation/screens/horoscope_screen.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../profile/presentation/screens/my_kundlis_screen.dart';
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
    HoroscopeScreen(),
    AstroBabaScreen(),
    MyKundlisScreen(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: 'Game Plan'),
    _NavItem(icon: Icons.auto_awesome_mosaic_outlined, activeIcon: Icons.auto_awesome_mosaic_rounded, label: 'Horoscope'),
    _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: 'Astro Baba'),
    _NavItem(icon: Icons.account_circle_outlined, activeIcon: Icons.account_circle_rounded, label: 'My Kundlis'),
  ];

  String _getNavLabel(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context, ref);
    switch (index) {
      case 0:
        return l10n.navGamePlan;
      case 1:
        return l10n.navHoroscope;
      case 2:
        return l10n.navAstroBaba;
      case 3:
        return l10n.navMyKundlis;
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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
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

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.cosmicRadialGradient),
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
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            color: Color(0x1A0F1219),
            border: Border(right: BorderSide(color: AppColors.glassBorder, width: 0.5)),
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
                        const Text(
                          'AstroSaathi',
                          style: TextStyle(
                            color: AppColors.textPrimaryDark,
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
          color: isActive ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 0.5)
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
                color: isActive ? AppColors.primary : AppColors.textTertiaryDark,
                size: 22,
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 12),
              Text(
                _getNavLabel(context, index),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primary : AppColors.textSecondaryDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.92),
        border: const Border(
          top: BorderSide(color: AppColors.glassBorder, width: 0.5),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (index) {
                  return Expanded(
                    child: _buildBottomNavItem(index, currentIndex),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, int currentIndex) {
    final isActive = currentIndex == index;
    final item = _navItems[index];

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
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 18 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [const BoxShadow(color: AppColors.goldGlow, blurRadius: 8)]
                    : null,
              ),
            ),
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                color: isActive ? AppColors.primary : AppColors.textTertiaryDark,
                size: 20,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _getNavLabel(context, index),
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textTertiaryDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
