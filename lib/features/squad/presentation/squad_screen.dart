import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/content_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../domain/player_model.dart';
import 'squad_provider.dart';

/// Kadro ekranı — pozisyona göre gruplu oyuncu listesi
class SquadScreen extends ConsumerWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final squadAsync = ref.watch(groupedSquadProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kadro')),
      body: squadAsync.when(
        loading: () => const LoadingShimmer(itemCount: 8),
        error: (_, __) => ContentErrorState(
          onRetry: () => ref.invalidate(groupedSquadProvider),
        ),
        data: (positions) {
          if (positions.isEmpty) {
            return const BrandedEmptyState(
              icon: Icons.groups_outlined,
              title: 'Kadro bilgileri hazırlanıyor',
              message: 'Oyuncular eklendiğinde burada yerini alacak.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: positions.entries.map((entry) {
              return _PositionSection(
                title: entry.key,
                players: entry.value,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _PositionSection extends StatelessWidget {
  const _PositionSection({
    required this.title,
    required this.players,
  });

  final String title;
  final List<PlayerModel> players;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(title.toUpperCase(),
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.secondaryGray)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return GestureDetector(
              onTap: () => context.push(RouteNames.playerDetailPath(player.id)),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          AppColors.primaryRed.withValues(alpha: 0.2),
                      child: Text('${player.number}',
                          style: AppTypography.headlineMedium
                              .copyWith(color: AppColors.primaryRed)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(player.name,
                        style: AppTypography.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 2),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
