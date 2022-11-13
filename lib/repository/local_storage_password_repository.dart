import 'package:password_manager/common/logger/logger.dart';
import 'package:password_manager/common/storage/local_storage.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/repository/password_repository.dart';

/// Value値に格納されるデータ種別
enum _ValueType {
  id,
  password,
  description
}

/// ローカルストレージを使用し、データの永続化を行うクラス
/// key: title, value: id/password/description
class LocalStoragePasswordRepository implements PasswordRepository {
  static const String _splitChar = r'/';          ///< 区切り文字
  static const String _escapeChar = r'&';         ///< エスケープ文字
  static final RegExp _splitPattern
      = RegExp(r'(?<=[^' + _escapeChar + r']|(' + (_escapeChar * 2) + r')+)' + _splitChar); ///< 前の文字が「&」以外 or「&&」* 1以上の「/」に一致する正規表現

  late LocalStorage _storage; ///< ストレージへの操作を行うインスタンス

  /// エスケープする
  static String _escape(final String src) => src.replaceAll(_splitChar, _escapeChar + _splitChar);
  /// エスケープを元に戻す
  static String _unescape(final String src) => src.replaceAll(_escapeChar + _splitChar, _splitChar);

  /// コンストラクタ
  /// 単体テスト可能にするため、ストレージ操作を行うクラスはDI可能とする
  LocalStoragePasswordRepository([final LocalStorage? storage]) {
    _storage = storage ?? LocalStorage();
  }

  @override
  /// 全件取得
  Future<List<PasswordInfo>> findAll() async {
    final List<PasswordInfo> passwords = [];
    final Map<String, String> all = await _storage.readAll();
    all.forEach((key, value) {
      final List<String> escapedValues = value.split(_splitPattern);
      if (escapedValues.length == _ValueType.values.length) {
        passwords.add(
            PasswordInfo(
              title: key,
              id: _unescape(escapedValues[_ValueType.id.index]),
              password: _unescape(escapedValues[_ValueType.password.index]),
              description: _unescape(escapedValues[_ValueType.description.index]),
            )
        );
      } else {
        Logger.error('Split is Failed (size=${escapedValues.length}, expected=${_ValueType.values.length}).');
      }
    });
    return passwords;
  }

  @override
  /// パスワード追加
  /// 既にkeyが存在する場合はvalue値を上書きする
  void add(final PasswordInfo password) {
    _storage.write(
      key: password.title,
      value: _escape(password.id)
          + _splitChar + _escape(password.password)
          + _splitChar + _escape(password.description),
    );
  }

  @override
  /// パスワード更新
  void update({required final String oldTitle, required final PasswordInfo newPassword}) {
    if (oldTitle != newPassword.title) {
      delete(oldTitle);
    }
    add(newPassword);
  }

  @override
  /// パスワード削除
  void delete(final String title) => _storage.delete(key: title);
}
