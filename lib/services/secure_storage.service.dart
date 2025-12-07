import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../core/config/app.config.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final _regularStorage = GetStorage();

  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  bool get _useSecureStorage => AppConfig.useSecureStorage;

  Future<void> saveAuthToken(String token) async {
    if (_useSecureStorage) {
      await _secureStorage.write(key: _authTokenKey, value: token);
    } else {
      await _regularStorage.write(_authTokenKey, token);
    }
  }

  Future<String?> getAuthToken() async {
    if (_useSecureStorage) {
      return await _secureStorage.read(key: _authTokenKey);
    } else {
      return _regularStorage.read(_authTokenKey);
    }
  }

  Future<void> removeAuthToken() async {
    if (_useSecureStorage) {
      await _secureStorage.delete(key: _authTokenKey);
    } else {
      await _regularStorage.remove(_authTokenKey);
    }
  }

  Future<bool> hasAuthToken() async {
    if (_useSecureStorage) {
      final token = await _secureStorage.read(key: _authTokenKey);
      return token != null && token.isNotEmpty;
    } else {
      return _regularStorage.hasData(_authTokenKey);
    }
  }

  Future<void> saveUserId(String userId) async {
    if (_useSecureStorage) {
      await _secureStorage.write(key: _userIdKey, value: userId);
    } else {
      await _regularStorage.write(_userIdKey, userId);
    }
  }

  Future<String?> getUserId() async {
    if (_useSecureStorage) {
      return await _secureStorage.read(key: _userIdKey);
    } else {
      return _regularStorage.read(_userIdKey);
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final jsonString = jsonEncode(userData);
    if (_useSecureStorage) {
      await _secureStorage.write(key: _userDataKey, value: jsonString);
    } else {
      await _regularStorage.write(_userDataKey, userData);
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    if (_useSecureStorage) {
      final jsonString = await _secureStorage.read(key: _userDataKey);
      if (jsonString != null) {
        try {
          final decoded = jsonDecode(jsonString);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          }
        } catch (_) {}
      }
      return null;
    } else {
      return _regularStorage.read(_userDataKey);
    }
  }

  Future<void> setLoggedIn(bool value) async {
    await _regularStorage.write(_isLoggedInKey, value);
  }

  bool isLoggedIn() {
    return _regularStorage.read(_isLoggedInKey) ?? false;
  }

  Future<void> clearAuthData() async {
    await removeAuthToken();
    await _regularStorage.remove(_userIdKey);
    await _regularStorage.remove(_userDataKey);
    await setLoggedIn(false);

    if (_useSecureStorage) {
      await _secureStorage.delete(key: _userIdKey);
      await _secureStorage.delete(key: _userDataKey);
    }
  }

  static Future<void> init() async {
    await GetStorage.init();
  }
}
