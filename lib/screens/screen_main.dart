import 'package:flutter/material.dart';
import 'package:password_manager/screens/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          TextButton(
            onPressed: () => _logout(context),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/display_passwords');
              },
              child: const Text('Show saved passwords'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/create_entry');
              },
              child: const Text('Create a new entry'),
            ),
          ],
        )),
      ),
    );
  }

  void _logout(BuildContext ctx) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
    if (ctx.mounted) {
      Navigator.of(ctx).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx1) => LoginScreen()),
          (route) => false);
    }
  }
}
