import 'package:flutter/material.dart';
import 'package:password_manager/models/data_models.dart';

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
								hintText: 'Username'
							),
						),
						
						const SizedBox(height: 10),
						
						TextFormField(
							controller: _pwdController,
							decoration: const InputDecoration(
								label: Text('Password'),
								border: OutlineInputBorder(),
								hintText: 'Password'
							),
						),
						
						
						const SizedBox(height: 10),
						
						ElevatedButton(
							onPressed: () {
								actionOnButtonPressed();
							},
							child: const Text('Login')
						)
					],
				),
			)
		);
	}

	void actionOnButtonPressed(){
		final user = _userController.text;
		final pwd = _pwdController.text;

		if (user.isEmpty || pwd.isEmpty){
			return;
		}
		
		DataModel(username: user, password: pwd);
	}
}

