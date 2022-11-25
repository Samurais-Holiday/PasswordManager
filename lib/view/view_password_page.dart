import 'package:flutter/material.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/view/widget/password_widget.dart';

/// パスワードを閲覧するページ
class ViewPasswordPage extends StatefulWidget {
  const ViewPasswordPage({Key? key, required this.title, required this.password}) : super(key: key);
  /// ヘッダータイトル
  final String title;
  /// 表示するパスワード情報
  final PasswordInfo password;

  @override
  State<ViewPasswordPage> createState() => ViewPasswordPageState();
}

class ViewPasswordPageState extends State<ViewPasswordPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PasswordWidget.moreActionButton(context: context, password: widget.password),
          ],
        ),
        body: SingleChildScrollView(
          child: PasswordWidget.view(context: context, password: widget.password),
        ),
    );
  }
}