import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';

/// Cihaz doğrulama ve güvenlik kontrolleri.
/// Emülatör/simulator tespiti ve cihaz bilgisi toplama.
class DeviceCheckService {
  DeviceCheckService._();

  static final DeviceCheckService instance = DeviceCheckService._();

  static final Logger _logger = Logger();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  String? _deviceId;
  bool? _isEmulator;

  String? get deviceId => _deviceId;

  /// Cihaz kontrollerini başlat
  Future<void> initialize() async {
    await _fetchDeviceInfo();
    _logger.i(
      '[DeviceCheckService] Device: $_deviceId, Emulator: $_isEmulator',
    );
  }

  Future<void> _fetchDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        _deviceId = info.id;
        _isEmulator = !info.isPhysicalDevice;
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        _deviceId = info.identifierForVendor;
        _isEmulator = !info.isPhysicalDevice;
      }
    } catch (e) {
      _logger.e('[DeviceCheckService] Failed to fetch device info: $e');
    }
  }

  /// Emülatör/simulator'da mı çalışıyor?
  bool get isEmulator => _isEmulator ?? false;

  /// Cihaz gerçek fiziksel cihaz mı?
  bool get isPhysicalDevice => !isEmulator;

  /// Platform bilgisi
  String get platform => Platform.isIOS ? 'ios' : 'android';

  /// FCM için cihaz profili (Firestore'a kaydedilir)
  Map<String, dynamic> get deviceProfile => {
        'deviceId': _deviceId,
        'platform': platform,
        'isEmulator': isEmulator,
        'timestamp': DateTime.now().toIso8601String(),
      };
}
