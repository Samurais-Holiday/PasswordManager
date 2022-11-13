import 'package:flutter/material.dart';
import 'package:password_manager/view/widget/forms.dart';
import 'package:password_manager/view/widget/password_widget.dart';

/// パスワード一覧を表示するページ
class PasswordListPage extends StatefulWidget {
  const PasswordListPage({Key? key, required this.title}) : super(key: key);

  final String title; ///< ヘッダータイトル

  @override
  State<PasswordListPage> createState() => _PasswordListPageState();
}

class _PasswordListPageState extends State<PasswordListPage> {
  final TextEditingController _searchFormController = TextEditingController(); ///< 検索フォームコントローラー

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
          PasswordWidget.getList(
            context: context,
            searchWord: _searchFormController.value.text,
          ),
        ],
      ),
      floatingActionButton: Forms.addPasswordInfoButton(),
    );
  }
}
