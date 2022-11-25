import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// フォームに関するWidgetを提供するクラス
class Forms {
  /// 検索フォーム
  static Widget searchForm({required TextEditingController controller, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }

  /// パスワード情報入力フォーム
  static Widget passwordFormField({required BuildContext context,
                                   required TextEditingController titleController,
                                   required TextEditingController idController,
                                   required TextEditingController passwordController,
                                   required TextEditingController memoController,
                                   GlobalKey<FormState>? key,
                                   bool readOnly = false}) {
    return Form(
        key: key,
        child: ListView(
          shrinkWrap: true,
          children: [
            // Title
            Card(
              child: ListTile(
                title: TextFormField(
                  autofocus: !readOnly,
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  readOnly: readOnly,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder()
                  ),
                  validator: (input) {
                    return input == null || input.isEmpty
                        ? '`Title` is required.'
                        : null;
                  },
                ),
              ),
            ),

            // Login ID
            Card(
              child: ListTile(
                title: TextFormField(
                  controller: idController,
                  textInputAction: TextInputAction.next,
                  readOnly: readOnly,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Login ID *',
                    border: OutlineInputBorder()
                  ),
                ),
                trailing: readOnly
                    ? IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: idController.value.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied!'))
                          );
                        },)
                    : null,
              ),
            ),

            // Password
            Card(
              child: ListTile(
                title: TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  readOnly: readOnly,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Password *',
                    border: OutlineInputBorder()
                  ),
                ),
                trailing: readOnly
                    ? IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: passwordController.value.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied!'))
                          );
                        })
                    : null,
              ),
            ),

            // memo
            Card(
              child: ListTile(
                title: TextFormField(
                  controller: memoController,
                  textInputAction: TextInputAction.done,
                  readOnly: readOnly,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Memo',
                    border: OutlineInputBorder()
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}