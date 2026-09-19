import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config/app_constants.dart';

class SecureTokenStorage {
  const SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> readToken() => _storage.read(key: StorageKeys.jwt);
  Future<void> saveToken(String token) => _storage.write(key: StorageKeys.jwt, value: token);
  Future<void> clearToken() => _storage.delete(key: StorageKeys.jwt);
}
