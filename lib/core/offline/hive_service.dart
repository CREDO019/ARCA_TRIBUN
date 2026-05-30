import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';

/// Hive yerel veritabanı başlatma ve yönetimi.
class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  static final Logger _logger = Logger();

  bool _isInitialized = false;

  /// Hive'ı başlat ve adaptörleri kaydet.
  /// main.dart'ta Hive.initFlutter()'dan sonra çağrılmalı.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Adaptörleri kaydet (generated adapter'lar eklenince buraya eklenir)
      _registerAdapters();

      // Temel box'ları aç
      await _openBoxes();

      _isInitialized = true;
      _logger.i('[HiveService] Initialized successfully');
    } catch (e, st) {
      _logger.e('[HiveService] Failed to initialize', error: e, stackTrace: st);
      rethrow;
    }
  }

  void _registerAdapters() {
    // Örnek: Hive.registerAdapter(SyncOperationAdapter());
    // Freezed modeller ile otomatik oluşturulacak
  }

  Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox<dynamic>(AppConstants.hiveBoxSettings),
      Hive.openBox<dynamic>(AppConstants.hiveBoxSyncQueue),
      Hive.openBox<dynamic>(AppConstants.hiveBoxCache),
    ]);
    _logger.d('[HiveService] All boxes opened');
  }

  /// Belirli bir box'ı al
  Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw StateError(
          'Hive box "$boxName" is not open. Call initialize() first.');
    }
    return Hive.box<T>(boxName);
  }

  /// Tüm önbelleği temizle (çıkış yaparken)
  Future<void> clearCache() async {
    final cacheBox = Hive.box<dynamic>(AppConstants.hiveBoxCache);
    await cacheBox.clear();
    _logger.d('[HiveService] Cache cleared');
  }

  /// Tüm box'ları kapat
  Future<void> closeAll() async {
    await Hive.close();
    _isInitialized = false;
  }
}
