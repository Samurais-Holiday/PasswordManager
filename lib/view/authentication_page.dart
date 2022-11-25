import 'package:flutter/material.dart';
import 'package:password_manager/view/widget/authentication_navigator.dart';

/// ユーザ認証を行うページ
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key, required this.title, required this.nextPage}) : super(key: key);
  /// ヘッダータイトル
  final String title;
  /// 認証完了後の遷移先ページ
  final Widget nextPage;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  @override
  void initState() {
    super.initState();
    AuthenticationNavigator.pushReplacement(
        context: context,
        successPage: widget.nextPage,
        failurePage: AuthenticationPage(title: 'Authentication', nextPage: widget.nextPage)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
          child: CircularProgressIndicator()
      ),
    );
  }
}