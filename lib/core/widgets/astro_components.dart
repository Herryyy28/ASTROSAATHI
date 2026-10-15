import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/design_tokens.dart';

/// Canonical vector-font glyphs used across astrology surfaces.
/// Noto Sans Symbols keeps every planet and zodiac mark in one visual family.
abstract final class AstroSymbols {
  static const Map<String, String> _planets = {
    'sun': '☉',
    'surya': '☉',
    'moon': '☽',
    'chandra': '☽',
    'mercury': '☿',
    'budha': '☿',
    'venus': '♀',
    'shukra': '♀',
    'mars': '♂',
    'mangal': '♂',
    'jupiter': '♃',
    'guru': '♃',
    'saturn': '♄',
    'shani': '♄',
    'uranus': '♅',
    'neptune': '♆',
    'pluto': '♇',
    'rahu': '☊',
    'north node': '☊',
    'ketu': '☋',
    'south node': '☋',
  };

  static const Map<String, String> _zodiac = {
    'aries': '♈',
    'taurus': '♉',
    'gemini': '♊',
    'cancer': '♋',
    'leo': '♌',
    'virgo': '♍',
    'libra': '♎',
    'scorpio': '♏',
    'sagittarius': '♐',
    'capricorn': '♑',
    'aquarius': '♒',
    'pisces': '♓',
  };

  static String planet(String name) {
    final normalized = name.toLowerCase();
    for (final entry in _planets.entries) {
      if (normalized.contains(entry.key)) return entry.value;
    }
    return '✦';
  }

  static String zodiac(String name) =>
      _zodiac[name.toLowerCase().trim()] ?? '✦';
}

/// A compact, consistent title treatment for the five primary destinations.
class AstroPrimaryHeader extends StatelessWidget {
  const AstroPrimaryHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.eyebrow,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 12),
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final String? eyebrow;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Text(
                  eyebrow!.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 5),
              ],
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 27,
                  height: 1.12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLightMode,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  height: 1.35,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    ),
  );
}

/// A unified celestial glyph treatment that avoids mixing icon families.
class AstroGlyphIcon extends StatelessWidget {
  const AstroGlyphIcon({
    super.key,
    required this.glyph,
    this.size = 44,
    this.emphasized = false,
    this.semanticLabel,
  });

  final String glyph;
  final double size;
  final bool emphasized;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    image: true,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: emphasized ? AppColors.highlightSurface : AppColors.softLavender,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceLight, width: 2),
      ),
      child: Text(
        glyph,
        style: GoogleFonts.notoSansSymbols2(
          fontSize: size * .46,
          height: 1,
          color: AppColors.primaryLightMode,
        ),
      ),
    ),
  );
}

/// Responsive shell for secondary routes. It keeps app-bar, safe-area,
/// readable-width and bottom inset behavior consistent without owning content.
class AstroDetailScaffold extends StatelessWidget {
  const AstroDetailScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.scrollable = true,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 32),
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );

    return AstroScaffold(
      appBar: AstroAppBar(
        title: title,
        onBack: () => Navigator.maybePop(context),
        actions: actions,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: scrollable
            ? SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: padding,
                child: content,
              )
            : Padding(padding: padding, child: content),
      ),
    );
  }
}

class AstroPageIntro extends StatelessWidget {
  const AstroPageIntro({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.auto_awesome_rounded,
    this.tag,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? tag;

  @override
  Widget build(BuildContext context) => AstroCard(
    color: AppColors.highlightSurface,
    radius: AppRadius.featureCard,
    padding: const EdgeInsets.all(20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: AppColors.surfaceLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryLightMode, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tag != null) ...[
                Text(
                  tag!.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.primaryLightMode,
                  ),
                ),
                const SizedBox(height: 5),
              ],
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 19,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class AstroScaffold extends StatelessWidget {
  const AstroScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
  });
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.backgroundLight,
    appBar: appBar,
    bottomNavigationBar: bottomNavigationBar,
    body: SafeArea(bottom: false, child: child),
  );
}

class AstroAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AstroAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
  });
  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.backgroundLight,
    leading: onBack == null
        ? null
        : Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onBack,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.primaryLightMode,
                ),
              ),
            ),
          ),
    title: Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
    ),
    actions: actions,
  );
}

class AstroCard extends StatelessWidget {
  const AstroCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.radius = AppRadius.card,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: AppMotion.standard,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D25283A),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
    return onTap == null
        ? card
        : Semantics(
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
              child: card,
            ),
          );
  }
}

class AstroSectionHeader extends StatelessWidget {
  const AstroSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onAction,
          child: Text(
            action!,
            style: const TextStyle(color: AppColors.secondary),
          ),
        ),
    ],
  );
}

class AstroPrimaryButton extends StatelessWidget {
  const AstroPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: AppControlHeight.button,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
        ),
        icon: loading
            ? const SizedBox.square(
                dimension: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : icon == null
            ? const SizedBox.shrink()
            : Icon(icon, size: 19),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

class AstroSecondaryButton extends StatelessWidget {
  const AstroSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLightMode,
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
    ),
  );
}

class AstroInput extends StatelessWidget {
  const AstroInput({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.enabled = true,
  });
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    enabled: enabled,
    onSubmitted: onSubmitted,
    style: GoogleFonts.inter(color: AppColors.textPrimaryLight),
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: AppColors.textSecondaryLight),
      suffixIcon: suffixIcon,
      fillColor: AppColors.surfaceLight,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
    ),
  );
}

class AstroSelectCard extends StatelessWidget {
  const AstroSelectCard({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.titleStyle,
  });
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: AnimatedContainer(
      duration: AppMotion.standard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: selected ? AppColors.highlightSurface : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.primaryLightMode : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.surfaceLight
                    : AppColors.secondaryBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 19,
                color: selected
                    ? AppColors.primaryLightMode
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      titleStyle ??
                      GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (selected)
            const CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.primaryLightMode,
              child: Icon(Icons.check, color: Colors.white, size: 15),
            ),
        ],
      ),
    ),
  );
}

class AstroChip extends StatelessWidget {
  const AstroChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
    selectedColor: AppColors.highlightSurface,
    backgroundColor: AppColors.surfaceLight,
    side: BorderSide(
      color: selected ? AppColors.primaryLightMode : AppColors.borderLight,
    ),
    labelStyle: TextStyle(
      color: selected
          ? AppColors.primaryLightMode
          : AppColors.textSecondaryLight,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  );
}

class AstroProfileSwitcher extends StatelessWidget {
  const AstroProfileSwitcher({super.key, required this.name, this.onTap});
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softLavender,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: AppColors.primaryLightMode,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: AppColors.primaryLightMode,
          ),
        ],
      ),
    ),
  );
}

class AstroInsightCard extends AstroCard {
  const AstroInsightCard({
    super.key,
    required super.child,
    super.onTap,
    super.padding,
  }) : super(color: AppColors.highlightSurface, radius: AppRadius.featureCard);
}

class AstroCalendarCard extends AstroCard {
  const AstroCalendarCard({super.key, required super.child, super.onTap})
    : super(radius: AppRadius.featureCard);
}

class AstroReportCard extends StatelessWidget {
  const AstroReportCard({
    super.key,
    required this.title,
    required this.onTap,
    this.locked = false,
    this.subtitle,
    this.icon = Icons.auto_awesome_outlined,
  });
  final String title;
  final VoidCallback onTap;
  final bool locked;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AstroCard(
    onTap: onTap,
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: subtitle == null ? 62 : 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 17, color: AppColors.secondary),
              Icon(
                locked
                    ? Icons.lock_outline_rounded
                    : Icons.chevron_right_rounded,
                size: 18,
                color: locked
                    ? AppColors.secondary
                    : AppColors.textSecondaryLight,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}

class AstroBottomNav extends StatelessWidget {
  const AstroBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;
  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.calendar_month_outlined, Icons.calendar_month_rounded, 'Calendar'),
    (Icons.auto_awesome_outlined, Icons.auto_awesome, 'Ask'),
    (Icons.description_outlined, Icons.description_rounded, 'Reports'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surfaceLight,
    elevation: 0,
    child: SafeArea(
      top: false,
      child: Container(
        height: AppControlHeight.bottomNav,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.softLavender)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D25283A),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final active = currentIndex == index;
            final item = _items[index];
            final ask = index == 2;
            return Expanded(
              child: Semantics(
                button: true,
                selected: active,
                label: '${item.$3} tab',
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: AppMotion.standard,
                        width: ask ? 44 : 36,
                        height: ask ? 40 : 30,
                        transform: ask
                            ? Matrix4.translationValues(0, -3, 0)
                            : Matrix4.identity(),
                        decoration: BoxDecoration(
                          gradient: ask ? AppColors.purpleGradient : null,
                          color: ask
                              ? null
                              : active
                              ? AppColors.softLavender
                              : Colors.transparent,
                          shape: ask ? BoxShape.circle : BoxShape.rectangle,
                          borderRadius: ask ? null : BorderRadius.circular(16),
                        ),
                        child: Icon(
                          active ? item.$2 : item.$1,
                          size: ask ? 21 : 21,
                          color: ask
                              ? Colors.white
                              : active
                              ? AppColors.primaryLightMode
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, ask ? -1 : 0),
                        child: Text(
                          item.$3,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: active
                                ? AppColors.primaryLightMode
                                : AppColors.textSecondaryLight,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    ),
  );
}

class AstroLoadingState extends StatelessWidget {
  const AstroLoadingState({super.key, this.label = 'Reading the stars…'});
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 108,
            decoration: BoxDecoration(
              color: AppColors.softLavender,
              borderRadius: AppRadius.borderFeatureCard,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _skeletonBlock(62)),
              const SizedBox(width: 12),
              Expanded(child: _skeletonBlock(62)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    ),
  );

  Widget _skeletonBlock(double height) => Container(
    height: height,
    decoration: BoxDecoration(
      color: AppColors.secondaryBackground,
      borderRadius: AppRadius.borderCard,
    ),
  );
}

class AstroEmptyState extends StatelessWidget {
  const AstroEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.auto_awesome_outlined,
  });
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: AppColors.softLavender,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryLightMode, size: 27),
        ),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondaryLight),
            ),
          ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 14),
          AstroSecondaryButton(label: actionLabel!, onPressed: onAction),
        ],
      ],
    ),
  );
}

class AstroErrorState extends StatelessWidget {
  const AstroErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: AppColors.softLavender,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.refresh_rounded,
            color: AppColors.primaryLightMode,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'The stars are taking a moment',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondaryLight),
        ),
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}
