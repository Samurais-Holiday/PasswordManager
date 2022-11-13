import 'package:flutter/material.dart';
import 'package:password_manager/common/authentication/local_authentication.dart';

/// ユーザ認証を行うページ
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key, required this.title, required this.nextPage}) : super(key: key);

  final String title;    ///< ヘッダータイトル
  final Widget nextPage; ///< 認証完了後の遷移先ページ

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  @override
  void initState() {
    super.initState();
    _authenticateAndNavigatePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
          child: Text('認証中です…')
      ),
    );
  }

  /// 認証結果に応じて次のページへ遷移する
  Future<void> _authenticateAndNavigatePage() async {
    if (await LocalAuthentication.authenticate()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => widget.nextPage));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_)
              => AuthenticationPage(title: widget.title, nextPage: widget.nextPage)
          )
      );
    }
  }
}