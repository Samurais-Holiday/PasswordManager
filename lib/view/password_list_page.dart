import 'package:flutter/material.dart';
import 'package:password_manager/view/widget/forms.dart';
import 'package:password_manager/view/widget/password_widget.dart';

/// パスワード一覧を表示するページ
class PasswordListPage extends StatefulWidget {
  const PasswordListPage({Key? key, required this.title}) : super(key: key);
  /// ヘッダータイトル
  final String title;

  @override
  State<PasswordListPage> createState() => _PasswordListPageState();
}

class _PasswordListPageState extends State<PasswordListPage> {
  final TextEditingController _searchFormController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 読み込み完了時の表示
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Forms.searchForm(
              controller: _searchFormController,
              onChanged: (_) => setState(() {})
          ),
          SingleChildScrollView(
            child: PasswordWidget.listView(
              context: context,
              searchWord: _searchFormController.value.text,
            ),
          ),
        ],
      ),
      floatingActionButton: PasswordWidget.addPasswordInfoButton(context: context),
    );
  }
}
