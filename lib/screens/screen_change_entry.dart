// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:password_manager/db/database.dart';

class UpdateEntry extends StatelessWidget {
  final String platform;
  const UpdateEntry({super.key, required this.platform});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Update details of $platform'),
        leading: IconButton(
          onPressed: () async {
            await Navigator.of(context)
                .pushReplacementNamed('/display_passwords');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username (Leave blank for existing username)',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password (Leave blank for existing password)',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateDetails(
                      context,
                      username: usernameController.text,
                      password: passwordController.text,
                    );
                  },
                  child: const Text('Update Details'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _updateDetails(context, {username, password}) async {
    if ((username == null || username == '') &&
        (password == null || password == '')) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing has been updated'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }

    await UserDatabase.updateItem(platform, username, password);

    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Credentials updated successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
