import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Alt navigasyon çubuğu — ShellRoute ile kullanılır
class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final colors = context.arcaColors;

    final tabs = [
      const _NavTab(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Ana Sayfa',
        path: RouteNames.home,
      ),
      const _NavTab(
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month,
        label: 'Fikstür',
        path: RouteNames.fixtures,
      ),
      const _NavTab(
        icon: Icons.bar_chart_outlined,
        activeIcon: Icons.bar_chart,
        label: 'Puan',
        path: RouteNames.standings,
      ),
      const _NavTab(
        icon: Icons.group_outlined,
        activeIcon: Icons.group,
        label: 'Kadro',
        path: RouteNames.squad,
      ),
      const _NavTab(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
        path: RouteNames.profile,
      ),
    ];

    var currentIndex = 0;
    for (var i = 0; i < tabs.length; i++) {
      if (currentLocation.startsWith(tabs[i].path)) {
        currentIndex = i;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isActive = currentIndex == index;

              return GestureDetector(
                onTap: () => context.go(tab.path),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isActive ? tab.activeIcon : tab.icon,
                          key: ValueKey(isActive),
                          color: isActive
                              ? AppColors.primaryRed
                              : colors.textSecondary,
                          size: AppSpacing.iconLg,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 9,
                          color: isActive
                              ? AppColors.primaryRed
                              : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
}
