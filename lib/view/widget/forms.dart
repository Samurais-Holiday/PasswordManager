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


  /// パスワード情報追加ボタン
  static Widget addPasswordInfoButton() {
    return FloatingActionButton.extended(
      label: const Text('追加'),
      onPressed: () {
        // TODO: 追加ページへ遷移
      },
    );
  }

}