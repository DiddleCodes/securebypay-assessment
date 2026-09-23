import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage(SharedPreferencesAsync()));

class TokenStorage {
  TokenStorage(this._prefs);

  static const _key = 'auth_token';
  final SharedPreferencesAsync _prefs;

  Future<String?> read() => _prefs.getString(_key);

  Future<void> save(String token) => _prefs.setString(_key, token);

  Future<void> clear() => _prefs.remove(_key);
}
