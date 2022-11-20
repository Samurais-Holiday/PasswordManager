import 'package:password_manager/api/storage/local_storage.dart';

/// テストにてストレージ操作を提供するスタブクラス
class StubStorage implements LocalStorage {
  Map<String, String> _storage = {};

  /// コンストラクタ
  StubStorage([Map<String, String>? storage]) {
    if (storage != null) {
      _storage = storage;
    }
  }

  @override
  Future<Map<String, String>> readAll() async => _storage;

  @override
  Future<String?> read({required String title}) async => _storage[title];

  @override
  Future write({required String key, required String value}) async => _storage[key] = value;

  @override
  Future delete({required String key}) async => _storage.remove(key);
}
