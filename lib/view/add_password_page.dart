import 'package:flutter/material.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/service/password_service.dart';
import 'package:password_manager/view/password_list_page.dart';
import 'package:password_manager/view/widget/dialogs.dart';
import 'package:password_manager/view/widget/forms.dart';

/// パスワード情報を追加するページ
class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({Key? key, required this.title}) : super(key: key);
  /// ヘッダータイトル
  final String title;

  @override
  State<AddPasswordPage> createState() => AddPasswordPageState();
}

class AddPasswordPageState extends State<AddPasswordPage> {
  final PasswordService _service = PasswordService();

  /// Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Forms.passwordFormField(
                titleController: _titleController,
                idController: _idController,
                passwordController: _passwordController,
                memoController: _memoController
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _cancelButton(),
                  _inputCompletedButton(),
                ],
              )
            ],
          ),
        ),
    );
  }

  /// キャンセルボタン
  Widget _cancelButton() {
    return ElevatedButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  /// 入力完了ボタン
  Widget _inputCompletedButton() {
    return ElevatedButton(
      child: const Text('OK'),
      onPressed: () async {
        final PasswordInfo newPassword = PasswordInfo(
            title: _titleController.value.text,
            id: _idController.value.text,
            password: _passwordController.value.text,
            memo: _memoController.value.text
        );
        if (await _service.contains(title: newPassword.title)) {
          // 上書きの警告を表示
          Dialogs.showOkCancel(
            context: context,
            description: Text('`${newPassword.title}` is already registered.\nDo you want to overwrite it?'),
            onPressedOk: () async {
              await _service.add(newPassword);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PasswordListPage(title: 'List'))
              );
            },
          );
        } else {
          await _service.add(newPassword);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PasswordListPage(title: 'List'))
          );
        }
      },
    );
  }
}