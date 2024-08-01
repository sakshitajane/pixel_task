import 'package:flutter/material.dart';
import 'user_listpage.dart';

void main() {
  runApp(MyApp());
}

// The root widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserListPage(),
    );
  }
}
