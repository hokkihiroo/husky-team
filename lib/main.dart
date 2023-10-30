import 'package:flutter/material.dart';
import 'package:team_husky/user/user_screen.dart';
import 'package:team_husky/view/main_view.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: UserScreen(),
          //UserScreen
          //MainView
        ),
      ),
    ),
  );
}
