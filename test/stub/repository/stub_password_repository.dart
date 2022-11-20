import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/repository/password_repository.dart';

/// テストにてリポジトリ機能を提供するスタブクラス
class StubPasswordRepository implements PasswordRepository {
  /// ストレージの代わりにメンバ変数を使用する
  /// key: タイトル, value: パスワード情報
  final Map<String, PasswordInfo> _stubStorage = {};

  /// コンストラクタ
  StubPasswordRepository([List<PasswordInfo>? passwords]) {
    if (passwords != null) {
      for (var password in passwords) {
        _stubStorage[password.title] = password;
      }
    }
  }

  @override
  Future<List<PasswordInfo>> findAll() async => List.of(_stubStorage.values);

  @override
  Future<PasswordInfo?> find({required String title}) async => _stubStorage[title];

  @override
  Future add(PasswordInfo password) async => _stubStorage[password.title] = password;

  @override
  Future update({required String oldTitle, required PasswordInfo newPassword}) async
      => _stubStorage.update(oldTitle, (value) => newPassword);

  @override
  Future delete({required String title}) async => _stubStorage.remove(title);
}