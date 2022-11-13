import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// デバイスのローカルストレージ操作を提供するクラス
class LocalStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(); ///< https://pub.dev/packages/flutter_secure_storage

  /// 全データ取得
  Future<Map<String, String>> readAll() => _storage.readAll();

  /// 書き込み
  /// keyが既に存在する場合は上書きする
  Future write({required final String key, required final String value})
      => _storage.write(key: key, value: value);

  /// 削除
  Future delete({ required final String key}) => _storage.delete(key: key);
}