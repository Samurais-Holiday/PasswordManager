import 'package:flutter/material.dart';
import 'package:password_manager/api/url/url_launcher.dart';
import 'package:password_manager/service/password_service.dart';
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
  var _passwords = PasswordService().findAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Forms.searchForm(
              controller: _searchFormController,
              onChanged: (_) => setState(() {
                _passwords = PasswordService().search(_searchFormController.value.text);
              }),
          ),
          Flexible(
            child: PasswordWidget.futureListView(passwords: _passwords),
          ),
        ],
      ),
      floatingActionButton: PasswordWidget.addPasswordInfoButton(context: context),
    );
  }

  /// ドロワー
  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                UrlLauncher.launchPrivacyPolicy();
              }
          ),
        ],
      ),
    );
  }
}
