import 'package:password_manager/api/logger/logger.dart';
import 'package:password_manager/api/storage/local_storage.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/repository/password_repository.dart';

/// Value値に格納されるデータ種別
enum _ValueType {
  id,
  password,
  memo
}

/// ローカルストレージを使用し、データの永続化を行うクラス
/// key: title, value: id/password/memo
class LocalStoragePasswordRepository implements PasswordRepository {
  /// 区切り文字
  static const String _splitChar = r'/';
  /// エスケープ文字
  static const String _escapeChar = r'&';
  /// 空を表す文字
  static const String _emptyChar = r'%';
  /// 前の文字が「&」以外 or「&&」* 1以上の「/」に一致する正規表現
  static final RegExp _splitPattern
      = RegExp(r'(?<=[^' + _escapeChar + r'](' + (_escapeChar * 2) + r')*)' + _splitChar);
  /// ストレージへの操作を行うインスタンス
  late LocalStorage _storage;

  /// エスケープする
  static String _escape(final String src) {
    if (src.isEmpty) {
      return _emptyChar;
    }
    final escapedEscapeText = src.replaceAll(_escapeChar, _escapeChar * 2);
    return escapedEscapeText.replaceAll(_splitChar, _escapeChar + _splitChar)
        .replaceAll(_emptyChar, _escapeChar + _emptyChar);
  }

  /// エスケープを元に戻す
  static String _unescape(final String src) {
    final escapedEscapeText = src.replaceAll(_escapeChar + _splitChar, _splitChar)
        .replaceAll(_escapeChar + _emptyChar, _emptyChar);
    return escapedEscapeText.replaceAll(_escapeChar * 2, _escapeChar);
  }

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
      final password = _storedTextToPasswordInfo(key: key, value: value);
      if (password != null) {
        passwords.add(password);
      }
    });
    return passwords;
  }

  @override
  /// パスワード情報取得
  Future<PasswordInfo?> find({required String title}) async {
    String? value = await _storage.read(title: title);
    if (value == null) {
      Logger.info('`$title` is not Found.');
      return null;
    }
    return _storedTextToPasswordInfo(key: title, value: value);
  }

  @override
  /// パスワード追加
  /// 既にkeyが存在する場合はvalue値を上書きする
  Future add(final PasswordInfo password)
      => _storage.write(
        key: password.title,
        value: _passwordInfoToStoredText(password),
      );

  @override
  /// パスワード更新
  Future update({required final String oldTitle, required final PasswordInfo newPassword}) async {
    if (oldTitle != newPassword.title) {
      await delete(title: oldTitle);
    }
    await add(newPassword);
  }

  @override
  /// パスワード削除
  Future delete({required String title}) => _storage.delete(key: title);

  /// 保存されたテキストからPasswordInfoインスタンス生成
  PasswordInfo? _storedTextToPasswordInfo({required String key, required String value}) {
    final List<String> escapedValues = value.split(_splitPattern);
    if (escapedValues.length != _ValueType.values.length) {
      Logger.error('Split is Failed (actual=${escapedValues.length}, expected=${_ValueType.values.length}).');
      return null;
    }
    return PasswordInfo(
        title: key,
        id: escapedValues[_ValueType.id.index] == _emptyChar ? '' : _unescape(escapedValues[_ValueType.id.index]),
        password: escapedValues[_ValueType.password.index] == _emptyChar ? '' : _unescape(escapedValues[_ValueType.password.index]),
        memo: escapedValues[_ValueType.memo.index] == _emptyChar ? '' : _unescape(escapedValues[_ValueType.memo.index])
    );
  }

  /// パスワード情報から保存するテキストを生成
  String _passwordInfoToStoredText(PasswordInfo password)
    => _escape(password.id)
        + _splitChar + _escape(password.password)
        + _splitChar + _escape(password.memo);
}
