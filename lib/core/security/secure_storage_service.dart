import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

/// Hassas verileri (auth token, kullanıcı bilgileri) güvenli depolamada saklar.
/// iOS: Keychain, Android: EncryptedSharedPreferences kullanılır.
class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  static final Logger _logger = Logger();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ─── Keys ──────────────────────────────────────────────────────────────
  static const String _keyUserToken = 'user_auth_token';
  static const String _keyRefreshToken = 'user_refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyBiometricEnabled = 'biometric_enabled';

  // ─── Auth Token ────────────────────────────────────────────────────────
  Future<void> saveAuthToken(String token) async {
    await _write(_keyUserToken, token);
  }

  Future<String?> getAuthToken() async => _read(_keyUserToken);

  Future<void> deleteAuthToken() async => _delete(_keyUserToken);

  // ─── Refresh Token ─────────────────────────────────────────────────────
  Future<void> saveRefreshToken(String token) async {
    await _write(_keyRefreshToken, token);
  }

  Future<String?> getRefreshToken() async => _read(_keyRefreshToken);

  // ─── User ID ───────────────────────────────────────────────────────────
  Future<void> saveUserId(String uid) async => _write(_keyUserId, uid);
  Future<String?> getUserId() async => _read(_keyUserId);

  // ─── Biometric ─────────────────────────────────────────────────────────
  Future<void> setBiometricEnabled({required bool enabled}) async {
    await _write(_keyBiometricEnabled, enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _read(_keyBiometricEnabled);
    return value == 'true';
  }

  // ─── Oturum Kapatma ────────────────────────────────────────────────────
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      _logger.d('[SecureStorageService] All secure data cleared');
    } catch (e) {
      _logger.e('[SecureStorageService] Failed to clear: $e');
    }
  }

  // ─── Private Helpers ───────────────────────────────────────────────────
  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      _logger.e('[SecureStorageService] Write failed for key: $key - $e');
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      _logger.e('[SecureStorageService] Read failed for key: $key - $e');
      return null;
    }
  }

  Future<void> _delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      _logger.e('[SecureStorageService] Delete failed for key: $key - $e');
    }
  }
}
