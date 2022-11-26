import 'package:flutter/material.dart';
import 'package:password_manager/view/authentication_page.dart';
import 'package:password_manager/view/password_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primarySwatch = Colors.blueGrey;
    final primarySwatchThemeData = ThemeData(primarySwatch: primarySwatch);
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        scaffoldBackgroundColor: primarySwatchThemeData.backgroundColor,
        listTileTheme: const ListTileThemeData(
          minVerticalPadding: 8,
        ),
        cardTheme: CardTheme(
          color: primarySwatchThemeData.primaryColorLight,
          margin: const EdgeInsets.all(5),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: primarySwatchThemeData.primaryColorLight,
        ),
        dialogBackgroundColor: primarySwatchThemeData.primaryColorLight,
        drawerTheme: DrawerThemeData(
          backgroundColor: primarySwatchThemeData.primaryColorLight
        ),
      ),
      home: const AuthenticationPage(title: 'Authenticate', nextPage: PasswordListPage(title: 'List')),
    );
  }
}
