import 'package:flutter/material.dart';
import 'package:todolist_app/page/CalenderPage.dart';
import 'package:todolist_app/page/CategoryPage.dart';
import 'package:todolist_app/page/DetailTask.dart';
import 'package:todolist_app/page/HistoryPage.dart';
import 'package:todolist_app/page/Home.dart';
import 'package:todolist_app/page/Task.dart';
import 'package:todolist_app/page/login.dart';
import 'package:todolist_app/page/test.dart';
import 'package:todolist_app/page/test3.dart';


void main() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}