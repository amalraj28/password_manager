import 'package:flutter/material.dart';
import 'package:password_manager/encryption/encryption.dart';

class ChangeMasterPassword extends StatelessWidget {
  const ChangeMasterPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMPassController = TextEditingController();
    final newMPassController = TextEditingController();
    final formKey = GlobalKey<FormFieldState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Master Password'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                obscureText: true,
                controller: currentMPassController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Current Master Password',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              controller: newMPassController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'New Master Password',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (await _validatePassword(currentMPassController.text)) {
                      _updateMPass(newMPassController.text, context);
                      newMPassController.clear();
                      currentMPassController.clear();
                    } else {
                      _displayError(context);
                    }
                  },
                  child: const Text('Change Password'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _validatePassword(String enteredPassword) async {
    var mPass = await Encryption.masterPassword();
    return (enteredPassword == mPass);
  }

  _updateMPass(newPass, context) async {
    var storage = Encryption.secureStorage;
    storage.delete(key: 'key');
    storage.write(key: 'key', value: newPass);

    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Master Password updated successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  _displayError(context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Incorrect Password'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
