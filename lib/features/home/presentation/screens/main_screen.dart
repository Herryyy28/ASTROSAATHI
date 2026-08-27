import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../horoscope/presentation/screens/horoscope_screen.dart';
import '../../../panchang/presentation/screens/panchang_screen.dart';
import '../../../muhurat/presentation/screens/muhurat_screen.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HoroscopeScreen(),
    PanchangScreen(),
    MuhuratScreen(),
    AstroBabaScreen(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: 'Game Plan'),
    _NavItem(icon: Icons.auto_awesome_mosaic_outlined, activeIcon: Icons.auto_awesome_mosaic_rounded, label: 'Horoscope'),
    _NavItem(icon: Icons.wb_sunny_outlined, activeIcon: Icons.wb_sunny_rounded, label: 'Panchang'),
    _NavItem(icon: Icons.access_time_rounded, activeIcon: Icons.access_time_filled_rounded, label: 'Muhurat'),
    _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: 'Astro Baba'),
  ];

  @override
  Widget build(BuildContext context) {
    // Use side nav on tablet/desktop, bottom nav on mobile
    if (!context.isMobile) {
      return _buildWideLayout(context);
    }
    return _buildMobileLayout(context);
  }

  // ── Mobile Layout: bottom nav bar ────────────────────────────────
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _screens[_currentIndex],
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ── Tablet/Desktop Layout: side rail ─────────────────────────────
  Widget _buildWideLayout(BuildContext context) {
    final isDesktop = context.isDesktop;
    final railWidth = isDesktop ? 220.0 : 80.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.cosmicRadialGradient),
        child: Row(
          children: [
            // ── Side Navigation Rail ──────────────────────────────
            _buildSideRail(context, isDesktop, railWidth),

            // ── Main Content ──────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _screens[_currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideRail(BuildContext context, bool isDesktop, double width) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            color: Color(0x1A0F1219),
            border: Border(
              right: BorderSide(color: AppColors.glassBorder, width: 0.5),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // ── Logo / App name ──────────────────────────────
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
                // ── Nav Items ────────────────────────────────────
                ...List.generate(_navItems.length, (index) {
                  return _buildSideNavItem(index, isDesktop);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideNavItem(int index, bool isDesktop) {
    final isActive = _currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) setState(() => _currentIndex = index);
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
                item.label,
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

  // ── Bottom Nav (mobile) ───────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (index) {
                  return _buildBottomNavItem(index);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index) {
    final isActive = _currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) setState(() => _currentIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 24 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [BoxShadow(color: AppColors.goldGlow, blurRadius: 8)]
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
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textTertiaryDark,
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
