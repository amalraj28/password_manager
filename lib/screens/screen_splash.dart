import 'package:flutter/material.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/screens/screen_login.dart';
import 'package:password_manager/screens/screen_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Navigator.of(context).pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        'assets/images/buzzer.jpg',
        height: 300,
      ),
    ));
  }

  Future<void> goToLoginPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  Future<void> checkUserLoggedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final loginStatus = sharedPrefs.getBool(LOGIN_STATUS);

    if (loginStatus == null || loginStatus == false) {
      goToLoginPage(context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const MainScreen(),
        ),
        (route) => false,
      );
    }
  }
}
