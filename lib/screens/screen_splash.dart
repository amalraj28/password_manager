import 'package:flutter/material.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/screens/screen_bio_auth.dart';
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
    _checkUserLoggedIn();
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
          'assets/images/image.webp',
          height: 300,
        ),
      ),
    );
  }

  Future<void> _goToLoginPage(BuildContext context) async {
    // await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.of(context).popAndPushNamed('/login');
    }
  }

  Future<void> _checkUserLoggedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final loginStatus = sharedPrefs.getBool(LOGIN_STATUS);

    while (true) {
      if (await BiometricAuthScreen.authenticate()) {
        if (loginStatus == null || loginStatus == false) {
          _goToLoginPage(context);
        } else {
          await Navigator.of(context).popAndPushNamed('/display_passwords');
        }
        break;
      } /*else {*/
      // continue;
      // }
    }
  }
}
