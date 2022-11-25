import 'package:flutter/material.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/service/password_service.dart';
import 'package:password_manager/view/password_list_page.dart';
import 'package:password_manager/view/widget/forms.dart';

/// パスワード情報の編集を行うページ
class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({Key? key, required this.title, required this.editPassword}) : super(key: key);
  /// ヘッダータイトル
  final String title;
  /// 編集するパスワード情報
  final PasswordInfo editPassword;

  @override
  State<EditPasswordPage> createState() => EditPasswordPageState();
}

class EditPasswordPageState extends State<EditPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  /// Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  /// フォームに初期値を設定する
  void _initializeForm() {
    _titleController.text = widget.editPassword.title;
    _idController.text = widget.editPassword.id;
    _passwordController.text = widget.editPassword.password;
    _memoController.text = widget.editPassword.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Forms.passwordFormField(
                key: _formKey,
                titleController: _titleController,
                idController: _idController,
                passwordController: _passwordController,
                memoController: _memoController
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
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
        if (!_formKey.currentState!.validate()) {
          return;
        }
        final PasswordInfo newPassword = PasswordInfo(
            title: _titleController.value.text,
            id: _idController.value.text,
            password: _passwordController.value.text,
            memo: _memoController.value.text
        );
        await PasswordService().update(oldTitle: widget.editPassword.title, newPassword: newPassword);
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PasswordListPage(title: 'List'))
        );
      },
    );
  }
}