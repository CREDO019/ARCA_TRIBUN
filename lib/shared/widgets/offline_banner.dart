import 'dart:async';

import 'package:arca_tribun/core/offline/connectivity_service.dart';
import 'package:arca_tribun/core/offline/sync_queue.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Çevrimdışı mod banner'ı.
/// Bağlantı kesilince sarı banner yukarıdan kayar.
/// Bağlantı gelince otomatik kapanır ve SyncQueue tetiklenir.
class OfflineBanner extends ConsumerStatefulWidget {
  const OfflineBanner({super.key});

  @override
  ConsumerState<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends ConsumerState<OfflineBanner> {
  bool _isVisible = false;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    _isVisible = !ConnectivityService.instance.isConnected;

    _subscription = ConnectivityService.instance.connectivityStream.listen(
      (isConnected) {
        if (mounted) {
          setState(() => _isVisible = !isConnected);

          if (isConnected) {
            // Bağlantı gelince sync queue'yu tetikle
            SyncQueue.instance.processQueue();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isVisible ? 40 : 0,
      child: _isVisible
          ? Container(
              width: double.infinity,
              color: AppColors.warning,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: AppSpacing.iconSm,
                    color: AppColors.deepBlack,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Çevrimdışı moddasınız',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.deepBlack),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
