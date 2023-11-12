import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/firebase_options.dart';
import 'package:team_husky/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}
