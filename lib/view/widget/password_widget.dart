import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/api/logger/logger.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/service/password_service.dart';
import 'package:password_manager/view/add_password_page.dart';
import 'package:password_manager/view/edit_password_page.dart';
import 'package:password_manager/view/password_list_page.dart';
import 'package:password_manager/view/view_password_page.dart';
import 'package:password_manager/view/widget/dialogs.dart';

/// パスワードに対する操作種別
enum _Action {
  view,
  edit,
  delete,
}

/// パスワード一覧を表示するWidgetを返却するクラス
class PasswordWidget {
  /// パスワード一覧を表示するWidgetを返却
  static Widget listView({required BuildContext context, final String searchWord = ''}) {
    PasswordService().search(searchWord).then((passwords) {
      // 読み込み完了後の表示
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                  title: Text(passwords[index].title),
                  subtitle: Text(passwords[index].memo),
                  trailing: PopupMenuButton<_Action>(
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (action) => _action(context: context, action: action, password: passwords[index]),
                    itemBuilder: (BuildContext _) => [
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
                  onTap: () => _action(context: context, action: _Action.view, password: passwords[index])
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
  static void _action({required BuildContext context, required final _Action action, required final PasswordInfo password}) {
    switch (action) {
      case _Action.view:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ViewPasswordPage(title: 'View', password: password))
        );
        break;
      case _Action.edit:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditPasswordPage(title: 'Edit', editPassword: password,))
        );
        break;
      case _Action.delete:
        Dialogs.showOkCancel(
            context: context,
            title: Text('Do you want to delete `${password.title}` ?'),
            description: const Text('This operation cannot be undone.'),
            onPressedOk: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PasswordListPage(title: 'List'))
            ),
        );
        break;
      default:
        Logger.error('${action.name} is not supported.');
        break;
    }
  }

  /// 指定したパスワード情報を表示するWidgetを返却する
  static Widget view({required BuildContext context, required final PasswordInfo password}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // title
        Text(password.title, style: Theme.of(context).textTheme.titleLarge),
        // id
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Id:', style: Theme.of(context).textTheme.subtitle1),
            SelectableText(password.password, style: Theme.of(context).textTheme.displayMedium,),
            ElevatedButton(
                child: const Text('copy'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: password.password));
                  Dialogs.showOkCancel(
                      context: context,
                      description: const Text('ID has been copied to clipboard!'),
                  );
                },
            )
          ],
        ),
        // password
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Password:', style: Theme.of(context).textTheme.subtitle1),
            SelectableText(password.password, style: Theme.of(context).textTheme.displayMedium,),
            ElevatedButton(
                child: const Text('Copy'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: password.password));
                  Dialogs.showOkCancel(
                      context: context,
                      description: const Text('Password has been copied to clipboard!'),
                  );
                },
            ),
          ],
        ),
        // description
        SelectableText(password.memo, style: Theme.of(context).textTheme.bodyLarge,),
      ],
    );
  }

  /// パスワードに関する操作を提供するドロップダウンボタン
  static Widget moreActionButton({required BuildContext context, required final PasswordInfo password}) {
    return PopupMenuButton<_Action>(
        icon: const Icon(Icons.more_horiz),
        onSelected: (action) => _action(context: context, action: action, password: password),
        itemBuilder: (BuildContext _) => [
          const PopupMenuItem(
              value: _Action.edit,
              child: Text('Edit')
          ),
          const PopupMenuItem(
              value: _Action.delete,
              child: Text('Delete')
          ),
        ],
    );
  }

  /// パスワード情報追加ボタン
  static Widget addPasswordInfoButton({required BuildContext context}) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: const Text('Add'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPasswordPage(title: 'Registration')));
      },
    );
  }
}