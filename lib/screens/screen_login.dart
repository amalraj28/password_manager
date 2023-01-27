import 'package:flutter/material.dart';
import 'package:password_manager/models/data_models.dart';
import 'package:password_manager/screens/screen_main.dart';

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
                    hintText: 'Password'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Login'),
                  onPressed: () {
                    actionOnButtonPressed(context);
                  })
            ],
          ),
        ));
  }

  void actionOnButtonPressed(BuildContext ctx) {
    final user = _userController.text;
    final pwd = _pwdController.text;
    const emptyFields = 'One or more fields are empty';
    const incorrectData = 'Username and password are incorrect';

    if (user.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text(emptyFields),
      ));
    } else if (user != pwd) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(incorrectData),
        ),
      );
    } else {
      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (ctx1) => const MainScreen()));
    }
    // DataModel(username: user, password: pwd);
  }
}
