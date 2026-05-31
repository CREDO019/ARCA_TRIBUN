import 'dart:convert';

import 'package:arca_tribun/core/constants/app_constants.dart';
import 'package:arca_tribun/core/offline/connectivity_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

/// Offline iken gerçekleşen işlemleri kuyruğa alan sistem.
/// Bağlantı gelince otomatik olarak işler.
class SyncQueue {
  SyncQueue._();

  static final SyncQueue instance = SyncQueue._();

  static final Logger _logger = Logger();

  late Box<dynamic> _box;
  bool _isProcessing = false;

  /// SyncQueue'yu başlat ve bağlantı dinlemesini kur
  Future<void> initialize() async {
    _box = Hive.box<dynamic>(AppConstants.hiveBoxSyncQueue);

    // Bağlantı gelince kuyruğu işle
    ConnectivityService.instance.connectivityStream.listen((isConnected) {
      if (isConnected) {
        processQueue();
      }
    });

    // Başlangıçta bağlantı varsa işle
    if (ConnectivityService.instance.isConnected) {
      await processQueue();
    }

    _logger.d('[SyncQueue] Initialized with ${_box.length} pending operations');
  }

  /// Kuyruğa offline işlem ekle
  Future<void> enqueue(SyncOperation operation) async {
    final key =
        '${operation.type}_${operation.timestamp.millisecondsSinceEpoch}';
    await _box.put(key, jsonEncode(operation.toJson()));
    _logger.d('[SyncQueue] Enqueued: ${operation.type}');
  }

  /// Kuyruktaki tüm işlemleri işle
  Future<void> processQueue() async {
    if (_isProcessing || _box.isEmpty) return;
    if (!ConnectivityService.instance.isConnected) return;

    _isProcessing = true;
    _logger.i('[SyncQueue] Processing ${_box.length} operations...');

    final keys = _box.keys.cast<String>().toList();
    for (final key in keys) {
      final rawValue = _box.get(key);
      if (rawValue == null) continue;

      final operation = SyncOperation.fromJson(
        jsonDecode(rawValue as String) as Map<String, dynamic>,
      );

      final success = await _processOperation(operation);

      if (success) {
        await _box.delete(key);
        _logger.d('[SyncQueue] Processed and removed: ${operation.type}');
      } else if (operation.retryCount >= AppConstants.maxSyncRetries) {
        // Max retry aşıldı — dead letter queue'ya taşı
        await _moveToDeadLetter(key, operation);
      } else {
        // Retry sayısını artır
        final updatedOperation = operation.copyWith(
          retryCount: operation.retryCount + 1,
        );
        await _box.put(key, jsonEncode(updatedOperation.toJson()));
        _logger.w(
          '[SyncQueue] Retry ${updatedOperation.retryCount}/${AppConstants.maxSyncRetries}: ${operation.type}',
        );
      }
    }

    _isProcessing = false;
    _logger.i('[SyncQueue] Queue processing complete');
  }

  Future<bool> _processOperation(SyncOperation operation) async {
    try {
      // İşlemi tipine göre çalıştır
      // Gerçek implementasyon her use case'de tanımlanır
      switch (operation.type) {
        case SyncOperationType.submitPrediction:
          // PredictionRepository.submitPrediction(operation.payload)
          return true;
        case SyncOperationType.updateProfile:
          // FanProfileRepository.updateProfile(operation.payload)
          return true;
        default:
          _logger.w('[SyncQueue] Unknown operation type: ${operation.type}');
          return false;
      }
    } catch (e) {
      _logger.e('[SyncQueue] Failed to process ${operation.type}: $e');
      return false;
    }
  }

  Future<void> _moveToDeadLetter(String key, SyncOperation operation) async {
    _logger.e(
      '[SyncQueue] Moving to dead letter: ${operation.type} (${operation.retryCount} retries)',
    );
    await _box.delete(key);
    // Dead letter box'a ekle (monitoring için)
    final deadLetterBox = await Hive.openBox<dynamic>('dead_letter_queue');
    await deadLetterBox.put(key, jsonEncode(operation.toJson()));
  }

  /// Kuyruktaki işlem sayısı
  int get pendingCount => _box.length;
}

/// Sync işlem tipleri
class SyncOperationType {
  SyncOperationType._();

  static const String submitPrediction = 'submit_prediction';
  static const String updateProfile = 'update_profile';
  static const String checkIn = 'check_in';
}

/// Tek bir sync işlemini temsil eden model
class SyncOperation {
  const SyncOperation({
    required this.type,
    required this.payload,
    required this.timestamp,
    this.retryCount = 0,
  });

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
        type: json['type'] as String,
        payload: json['payload'] as Map<String, dynamic>,
        timestamp: DateTime.parse(json['timestamp'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
      );

  final String type;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final int retryCount;

  SyncOperation copyWith({
    String? type,
    Map<String, dynamic>? payload,
    DateTime? timestamp,
    int? retryCount,
  }) =>
      SyncOperation(
        type: type ?? this.type,
        payload: payload ?? this.payload,
        timestamp: timestamp ?? this.timestamp,
        retryCount: retryCount ?? this.retryCount,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
        'retryCount': retryCount,
      };
}
