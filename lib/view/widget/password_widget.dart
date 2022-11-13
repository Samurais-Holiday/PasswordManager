import 'package:flutter/material.dart';
import 'package:password_manager/common/logger/logger.dart';
import 'package:password_manager/service/password_service.dart';
import 'package:password_manager/view/view_password_page.dart';

/// パスワードに対する操作種別
enum _Action {
  view,
  edit,
  delete,
}

/// パスワード一覧を表示するWidgetを返却するクラス
class PasswordWidget {
  /// パスワード一覧を表示するWidgetを返却
  static Widget getList({required BuildContext context, final String searchWord = ''}) {
    PasswordService().find(searchWord).then((passwords) {
      // 読み込み完了後の表示
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                  title: Text(passwords[index].title),
                  subtitle: Text(passwords[index].description),
                  trailing: PopupMenuButton<_Action>(
                    onSelected: (action) => _action(context: context, action: action),
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: _Action.view,
                        child: Text('表示'),
                      ),
                      const PopupMenuItem(
                        value: _Action.edit,
                        child: Text('編集'),
                      ),
                      const PopupMenuItem(
                        value: _Action.delete,
                        child: Text('削除'),
                      )
                    ],
                  ),
                  onTap: () => _action(context: context, action: _Action.view)
              ),
            );
          }
      );
    });
    // 読み込み中の表示
    return const Center(
      child: Icon(Icons.autorenew),
    );
  }

  /// アクション種別に応じて画面遷移/ダイアログ表示を行う
  static void _action({required BuildContext context, required final _Action action}) {
    switch (action) {
      case _Action.view:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ViewPasswordPage(title: '表示'))
        );
        break;
      case _Action.edit:
      // TODO: 編集ページへ遷移
        break;
      case _Action.delete:
      // TODO: 削除確認ダイアログ表示
      default:
        Logger.error('${action.name} is not supported.');
        break;
    }
  }
}