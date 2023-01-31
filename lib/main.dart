import 'package:flutter/material.dart';
import 'package:password_manager/screens/screen_splash.dart';

void main() {
  runApp(const MyApp());
}

const LOGIN_STATUS = 'user_logged_in';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
