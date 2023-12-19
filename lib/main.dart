import 'package:flutter/material.dart';
import 'package:password_manager/screens/screen_display_passwords.dart';
import 'package:password_manager/screens/screen_login.dart';
import 'package:password_manager/screens/screen_new_entry.dart';
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
        fontFamily: 'CrimsonText',
        appBarTheme: const AppBarTheme(color: Colors.pink),
        useMaterial3: true
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/display_passwords': (context) => const DisplayPasswords(),
        '/create_entry': (context) => const CreateNewEntry(),
      },
    );
  }
}
