import 'package:flutter/material.dart';
import 'package:to_do_list/auth/log_in.dart';
import 'package:to_do_list/auth/sign_up.dart';
import 'package:to_do_list/confirm_works.dart';
import 'package:to_do_list/personal.dart';
import 'main_page.dart';
import 'group_works.dart';
import 'data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth/auth_main_page.dart';

Datas data = Datas();

void main() async {
  await Hive.initFlutter();
  Hive.openBox('app_configure');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/groups_work": (context) => const GroupWorks(),
        "/main_page": (context) => const todoList(),
        "/confirm_works": (context) => const ConfirmWorks(),
        "/sign_up": (context) => const SignUpPage(),
        "/log_in": (context) => const LogIn(),
        "/personal_process": (context) => const Personal(),
        "/intro_page": (context) => const IntroPage(),
      },
      home: const IntroPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
