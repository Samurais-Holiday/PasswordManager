import 'package:flutter/material.dart';

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
  static Widget passwordFormField({required TextEditingController titleController, required TextEditingController idController,
                                   required TextEditingController passwordController, required TextEditingController memoController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        TextFormField(
          autofocus: true,
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Title *',
          ),
          validator: (input) {
            return input == null || input.isEmpty
                ? '`Title` is required.'
                : null;
          },
        ),

        // Login ID
        TextFormField(
          controller: idController,
          decoration: const InputDecoration(
            labelText: 'Login ID *',
          ),
          validator: (input) {
            return input == null || input.isEmpty
                ? '`Login ID` is required.'
                : null;
          },
        ),

        // Password
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password *',
          ),
          validator: (input) {
            return input == null || input.isEmpty
                ? '`Password` is required.'
                : null;
          },
        ),

        // memo
        TextFormField(
          controller: memoController,
          decoration: const InputDecoration(
            labelText: 'Memo',
          ),
        ),
      ],
    );
  }
}