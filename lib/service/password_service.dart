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
  Future<List<PasswordInfo>> find([final String searchWord = '']) async {
    if (searchWord.isEmpty) {
      return _repository.findAll();
    }
    final List<PasswordInfo> returnPasswords = [];
    final List<PasswordInfo> all = await _repository.findAll();
    for (var password in all) {
      if (password.contains(searchWord)) {
        returnPasswords.add(password);
      }
    }
    return returnPasswords;
  }

  ///　パスワードを追加する
  void add(PasswordInfo password) => _repository.add(password);

  /// パスワードを更新する
  void update({required final String oldTitle, required final PasswordInfo newPassword})
      => _repository.update(oldTitle: oldTitle, newPassword: newPassword);

  /// パスワードを削除する
  void delete(final String title) => _repository.delete(title);
}