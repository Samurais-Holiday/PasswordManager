import 'package:password_manager/model/password_info.dart';

/// リポジトリ基底クラス
abstract class PasswordRepository {
  /// パスワード全件取得
  Future<List<PasswordInfo>> findAll();
  /// パスワード取得
  Future<PasswordInfo?> find({required final String title});
  /// パスワード追加
  Future add(final PasswordInfo password);
  /// パスワード更新
  Future update({required final String oldTitle, required final PasswordInfo newPassword});
  /// パスワード削除
  Future delete({required final String title});
}