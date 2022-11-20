import 'package:local_auth/local_auth.dart' as local_auth_library;

/// デバイスの認証機能を提供するクラス
class LocalAuthentication {
  /// 認証を実施する
  /// 認証方法を設定していない場合は即座にtrueを返却する
  static Future<bool> authenticate() async {
    final auth = local_auth_library.LocalAuthentication();
    if (!await auth.isDeviceSupported()) {
      return true;
    }
    return auth.authenticate(localizedReason: 'Please authenticate to show your passwords.');
  }
}