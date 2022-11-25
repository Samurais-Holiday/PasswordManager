import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ダイアログを提供するクラス
class Dialogs {
  /// OK/Cancelダイアログを表示する
  /// onPressedOKがnullの場合はキャンセルボタンを表示しない
  /// ボタン押下時処理の前にDialogの表示はpopされるものとする
  static Future showOkCancel({required BuildContext context, void Function()? onPressedOk, void Function()? onPressedCancel,
    Widget? title, Widget? description}) async {
    if (Platform.isIOS) {
       await showDialog(
           context: context,
           builder: (_) => CupertinoAlertDialog(
             title: title,
             content: description,
             actions: [
               if (onPressedOk != null)
                 CupertinoDialogAction(
                   child: const Text('Cancel'),
                   onPressed: () {
                     Navigator.pop(context);
                     onPressedCancel?.call();
                   }
                 ),
               CupertinoDialogAction(
                 child: const Text('OK'),
                 onPressed: () {
                   Navigator.pop(context);
                   onPressedOk?.call();
                 },
               )
             ]
           )
       );
    } else {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: title,
          content: SingleChildScrollView(child: description),
          actions: [
            if (onPressedOk != null)
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                  onPressedCancel?.call();
                },
              ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                onPressedOk?.call();
              },
            )
          ]
        )
      );
    }
  }
}