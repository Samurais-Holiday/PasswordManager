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
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const AuthenticationPage(title: 'Authenticate', nextPage: PasswordListPage(title: 'List')),
    );
  }
}
