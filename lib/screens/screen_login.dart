import 'package:flutter/material.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/screens/screen_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _userController = TextEditingController();
  final _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  label: Text('Username or email'),
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: _pwdController,
                decoration: const InputDecoration(
                  label: Text('Password'),
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Login'),
                onPressed: () => actionOnButtonPressed(context),
              ),
            ],
          ),
        ));
  }

  void actionOnButtonPressed(BuildContext ctx) async {
    final user = _userController.text;
    final pwd = _pwdController.text;
    const emptyFields = 'One or more fields are empty';
    const incorrectData = 'Username and password do not match';

    if (user.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text(emptyFields),
        padding: EdgeInsets.all(10.0),
        backgroundColor: Colors.red,
      ));
    } else if (user != pwd) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(10.0),
          backgroundColor: Colors.red,
          content: Text(incorrectData),
        ),
      );
    } else {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool(LOGIN_STATUS, true);
      Navigator.of(ctx).popAndPushNamed('/main');
      _userController.clear();
      _pwdController.clear();
    }
  }
}
