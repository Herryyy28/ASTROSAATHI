import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
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
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _screens[_currentIndex],
      ),
      extendBody: true,
      bottomNavigationBar: _buildFloatingBottomNav(),
    );
  }

  Widget _buildFloatingBottomNav() {
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
                  return _buildNavItem(index);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = _currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator dot
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
            // Icon
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
            // Label
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
