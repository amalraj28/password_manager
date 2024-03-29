import 'package:flutter/material.dart';
import 'package:password_manager/encryption/encryption.dart';
import 'package:password_manager/functions/functions.dart';
import 'package:password_manager/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool obscured = true;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login / Setup Master Password'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return TextFormField(
                      obscureText: obscured,
                      controller: _pwdController,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                obscured = !obscured;
                              },
                            );
                          },
                          icon: Icon(
                            obscured
                                ? Icons.visibility_sharp
                                : Icons.visibility_off_sharp,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                    );
                  },
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
    final pwd = _pwdController.text.trim();
    const emptyFields = 'One or more fields are empty';
    const wrongPassword = 'Wrong password. Please try again';
    const tooLong = 'Master Password can have a maximum of 26 characters only';

    if (pwd.isEmpty) {
      getSnackBar(text: emptyFields, color: Colors.red, context: ctx);
    } 
    
    else if (await _checkIfFirstTime()) {
      var storage = Encryption.secureStorage;

      if (pwd.length > 26) {
        getSnackBar(text: tooLong, color: Colors.red, context: ctx);
        return;
      }

      await storage.write(key: 'key', value: pwd);
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool(LOGIN_STATUS, true);
      if (ctx.mounted) {
        await Navigator.of(ctx).popAndPushNamed('/display_passwords');
      }
    } else if (await _validateMasterPassword(_pwdController.text.trim())) {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool(LOGIN_STATUS, true);
      if (ctx.mounted) {
        await Navigator.of(ctx).popAndPushNamed('/display_passwords');
      }
    } else if (ctx.mounted) {
      getSnackBar(text: wrongPassword, color: Colors.red, context: ctx);
    }
  }

  _validateMasterPassword(text) async {
    var storage = Encryption.secureStorage;

    return await storage.read(key: 'key') == text;
  }

  _checkIfFirstTime() async {
    var storage = Encryption.secureStorage;
    return !(await storage.containsKey(key: 'key'));
  }
}
