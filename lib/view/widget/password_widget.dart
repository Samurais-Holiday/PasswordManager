import 'package:flutter/material.dart';
import 'package:password_manager/api/logger/logger.dart';
import 'package:password_manager/model/password_info.dart';
import 'package:password_manager/service/password_service.dart';
import 'package:password_manager/view/add_password_page.dart';
import 'package:password_manager/view/edit_password_page.dart';
import 'package:password_manager/view/password_list_page.dart';
import 'package:password_manager/view/view_password_page.dart';
import 'package:password_manager/view/widget/dialogs.dart';
import 'package:password_manager/view/widget/forms.dart';

/// パスワードに対する操作種別
enum _Action {
  view,
  edit,
  delete,
}

/// パスワード一覧を表示するWidgetを返却するクラス
class PasswordWidget {
  static Future<List<PasswordInfo>> _passwords = PasswordService().findAll();

  /// パスワード一覧を表示するWidgetを返却
  static Widget listView({required BuildContext context, final String searchWord = ''}) {
    _passwords = PasswordService().search(searchWord);
    return FutureBuilder(
        future: _passwords,
        builder: (BuildContext context, AsyncSnapshot<List<PasswordInfo>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                        title: Text(snapshot.data![index].title),
                        subtitle: Text(snapshot.data![index].memo),
                        trailing: PopupMenuButton<_Action>(
                          icon: const Icon(Icons.more_horiz),
                          onSelected: (action) => _action(context: context, action: action, password: snapshot.data![index]),
                          itemBuilder: (BuildContext _) => [
                            const PopupMenuItem(
                              value: _Action.view,
                              child: Text('View'),
                            ),
                            const PopupMenuItem(
                              value: _Action.edit,
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: _Action.delete,
                              child: Text('Delete'),
                            )
                          ],
                        ),
                        onTap: () => _action(context: context, action: _Action.view, password: snapshot.data![index])
                    ),
                  );
                }
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
            title: Text('Delete `${password.title}` ?'),
            description: const Text('This operation cannot be undone.'),
            onPressedOk: () async {
              await PasswordService().delete(password.title);
              Navigator.popUntil(context, (route) => route.isFirst);
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PasswordListPage(title: 'List'))
              );
            },
        );
        break;
      default:
        Logger.error('${action.name} is not supported.');
        break;
    }
  }

  /// 指定したパスワード情報を表示するWidgetを返却する
  static Widget view({required BuildContext context, required final PasswordInfo password})
    => Forms.passwordFormField(
        context: context,
        readOnly: true,
        titleController: TextEditingController(text: password.title),
        idController: TextEditingController(text: password.id),
        passwordController: TextEditingController(text: password.password),
        memoController: TextEditingController(text: password.memo));

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
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPasswordPage(title: 'Add')));
      },
    );
  }
}