import 'package:password_manager/model/password_info.dart';

/// リポジトリ基底クラス
abstract class PasswordRepository {
  /// パスワード全件取得
  Future<List<PasswordInfo>> findAll();
  /// パスワード追加
  void add(final PasswordInfo password);
  /// パスワード更新
  void update({required final String oldTitle, required final PasswordInfo newPassword});
  /// パスワード削除
  void delete(final String title);
}