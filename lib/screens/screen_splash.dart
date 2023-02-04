import 'package:flutter/material.dart';
import 'package:password_manager/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    if (context.mounted) {
      Navigator.of(context).popAndPushNamed('/login');
    }
  }

  Future<void> checkUserLoggedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final loginStatus = sharedPrefs.getBool(LOGIN_STATUS);

    if ((loginStatus == null || loginStatus == false) && context.mounted) {
      goToLoginPage(context);
    } else {
      Navigator.of(context).popAndPushNamed('/main');
    }
  }
}
