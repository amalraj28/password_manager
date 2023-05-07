import 'package:flutter/material.dart';
import 'package:password_manager/encryption/encryption.dart';
import 'package:password_manager/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

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
                onPressed: () {
                  _actionOnButtonPressed(context);
                },
              ),
            ],
          ),
        ));
  }

  void _actionOnButtonPressed(BuildContext ctx) async {
    final pwd = _pwdController.text;
    const emptyFields = 'One or more fields are empty';
    const wrongPassword = 'Wrong password. Please try again';

    if (pwd.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(emptyFields),
          padding: EdgeInsets.all(10.0),
          backgroundColor: Colors.red,
        ),
      );
    } else if (await _validateMasterPassword(_pwdController.text)) {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool(LOGIN_STATUS, true);
      if (ctx.mounted) {
        Navigator.of(ctx).popAndPushNamed('/main');
      }
      _pwdController.clear();
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(wrongPassword),
          padding: EdgeInsets.all(10.0),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _validateMasterPassword(text) async {
    var storage = Encryption.secureStorage;

    if (await storage.read(key: 'key') == text) return true;
    return false;
  }
}
