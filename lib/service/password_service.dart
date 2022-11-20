import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/repository/local_storage_password_repository.dart';
import 'package:password_manager/repository/password_repository.dart';

/// パスワードに関するservice機能を提供するクラス
class PasswordService {
  late final PasswordRepository _repository; ///< リポジトリクラス

  /// コンストラクタ
  PasswordService([PasswordRepository? repository]) {
    _repository = repository ?? LocalStoragePasswordRepository();
  }

  /// パスワード情報のリストを取得する
  Future<List<PasswordInfo>> findAll() => _repository.findAll();

  /// 検索ワードにヒットしたパスワード情報のリストを取得する
  Future<List<PasswordInfo>> search(String searchWord) async {
    final List<PasswordInfo> all = await findAll();
    if (searchWord.isEmpty) {
      return all;
    }
    List<PasswordInfo> returnPasswords = [];
    for (var password in all) {
      if (password.hits(searchWord)) {
        returnPasswords.add(password);
      }
    }
    return returnPasswords;
  }

  /// 既にデータが存在するか
  Future<bool> contains({required String title}) async
      => await _repository.find(title: title) != null;

  ///　パスワードを追加する
  /// 既に存在する場合は上書きする
  Future add(PasswordInfo password) => _repository.add(password);

  /// パスワードを更新する
  Future update({required final String oldTitle, required final PasswordInfo newPassword})
      => _repository.update(oldTitle: oldTitle, newPassword: newPassword);

  /// パスワードを削除する
  Future delete(final String title) => _repository.delete(title: title);
}