// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:password_manager/encryption/encryption.dart';
import 'package:password_manager/functions/functions.dart';

class ChangeMasterPassword extends StatelessWidget {
  const ChangeMasterPassword({super.key});

  @override
  Widget build(BuildContext context) {
    bool obscured = true;
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
              child: StatefulBuilder(
                builder: (context, setState) {
                  return TextFormField(
                    obscureText: obscured,
                    controller: currentMPassController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Current Master Password',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          obscured = !obscured;
                        }),
                        icon: Icon(
                          obscured
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return TextFormField(
                  obscureText: obscured,
                  controller: newMPassController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'New Master Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscured = !obscured;
                        });
                      },
                      icon: Icon(
                        obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (await _validatePassword(currentMPassController.text)) {
                      await _updateMPass(newMPassController.text, context);
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

  _updateMPass(String newPass, context) async {
    bool updated = newPass.isNotEmpty
        ? await Encryption.updateMasterPassword(newMasterPassword: newPass)
        : false;
    // return ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: updated
    //         ? const Text('Master Password updated successfully')
    //         : const Text('Failed to update :('),
    //     backgroundColor: updated ? Colors.green : Colors.red,
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
    return await getSnackBar(
      text: updated
          ? 'Master Password updated successfully'
          : 'Failed to update :(',
      color: updated ? Colors.green : Colors.red,
      context: context,
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
