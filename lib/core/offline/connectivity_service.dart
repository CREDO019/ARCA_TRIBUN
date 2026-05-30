import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

/// İnternet bağlantısı durumunu izleyen servis.
/// Bağlantı değişikliklerini stream üzerinden yayar.
class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  static final Logger _logger = Logger();

  final Connectivity _connectivity = Connectivity();

  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isConnected = true;

  /// Bağlantı durumu stream'i (true = bağlı, false = bağlantı yok)
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Anlık bağlantı durumu
  bool get isConnected => _isConnected;

  /// Servisi başlat
  Future<void> initialize() async {
    // İlk bağlantı durumunu kontrol et
    final results = await _connectivity.checkConnectivity();
    _isConnected = _isAnyConnected(results);

    // Değişiklikleri dinle
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );

    _logger.i('[ConnectivityService] Initialized. Connected: $_isConnected');
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = _isAnyConnected(results);

    if (wasConnected != _isConnected) {
      _connectivityController.add(_isConnected);
      _logger.i(
        '[ConnectivityService] Connection changed: $_isConnected',
      );
    }
  }

  bool _isAnyConnected(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  /// Servisi kapat
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _connectivityController.close();
  }
}
