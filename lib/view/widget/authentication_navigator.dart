import 'package:flutter/material.dart';
import 'package:password_manager/api/authentication/local_authentication.dart';

/// 認証を行うWidgetを提供するクラス
class AuthenticationNavigator {
  /// 認証を行い、結果に応じて画面遷移を行う
  static Future pushReplacement({required BuildContext context, required Widget successPage, required Widget failurePage}) async {
    if (await LocalAuthentication.authenticate()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => successPage));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => failurePage));
    }
  }
}