import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Son haberler yatay kaydırmalı liste
class NewsHorizontalScroll extends StatelessWidget {
  const NewsHorizontalScroll({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo haberler
    final news = [
      {
        'title': 'Arca Çorum FK Şampiyonluk Yolunda Güçlü Başladı',
        'category': 'Kulüp',
        'time': '2 sa'
      },
      {
        'title': 'Yeni Transfer Heyecanı: Yıldız Oyuncu Geliyor!',
        'category': 'Transfer',
        'time': '5 sa'
      },
      {
        'title': 'Teknik Direktör Maç Öncesi Konuştu',
        'category': 'Basın',
        'time': '1 gün'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SON HABERLER',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.secondaryGray)),
            TextButton(onPressed: () {}, child: const Text('Tümünü Gör')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: AppSpacing.newsCardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: news.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = news[index];
              return Container(
                width: 220,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(item['category'] as String,
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.primaryRed)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: AppTypography.titleMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(item['time'] as String,
                        style: AppTypography.bodySmall),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
