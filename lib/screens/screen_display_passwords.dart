import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/db/database.dart';
import 'package:password_manager/encryption/encryption.dart';

late bool _isDataAvailable;

class DisplayPasswords extends StatefulWidget {
  const DisplayPasswords({super.key});

  @override
  State<DisplayPasswords> createState() => _DisplayPasswordsState();
}

class _DisplayPasswordsState extends State<DisplayPasswords> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      _isDataAvailable = UserDatabase.checkIfDataPresent();
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Visibility(
            visible: _isDataAvailable,
            child: TextButton(
              onPressed: () {
                _displayDeletionWarning(context);
              },
              child: const Text(
                'Clear Data',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isDataAvailable ? _displayList() : _noDataScreen(),
    );
  }

  _displayList() {
    var data = UserDatabase.getData();
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(data[index].platform),
          subtitle: Text(data[index].username),
          trailing: IconButton(
            onPressed: () {
              _deleteFromDatabase(data[index].platform, ctx);
            },
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.redAccent,
            ),
          ),
          onTap: () => {
            _enterMasterPassword(data[index].platform),
          },
        );
      },
      separatorBuilder: (ctx, index) => const Divider(),
      itemCount: data.length,
    );
  }

  _noDataScreen() {
    return const Center(
      child: Text('Stored Passwords will be displayed here'),
    );
  }

  _clearDatabase() {
    setState(() {
      _isDataAvailable = false;
    });
    UserDatabase.clearData();
  }

  _displayDeletionWarning(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx1) {
        return AlertDialog(
          title: const Text('Warning!!!'),
          content: const Text(
              'This will delete all user data from the database. Do you wish to continue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx1).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _clearDatabase();
                Navigator.of(ctx1).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  _deleteFromDatabase(platform, ctx) {
    showDialog(
      context: ctx,
      builder: (ctx1) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx1).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  UserDatabase.deleteItemFromDb(platform);
                });
                Navigator.of(ctx1).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  _enterMasterPassword(pltfm) {
    showDialog(
      context: context,
      builder: (ctx1) {
        var alertTextController = TextEditingController();
        var textFieldFocusNode = FocusNode();
        bool obscured = true;
        bool isPwdCorrect = true;
        final formKey = GlobalKey<FormState>();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: alertTextController,
                      focusNode: textFieldFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password can\'t be empty';
                        } else if (!isPwdCorrect) {
                          return 'Incorrect Password Entered';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: 'Enter Master Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscured = !obscured;
                            });
                          },
                          icon: Icon(
                            obscured
                                ? Icons.visibility_sharp
                                : Icons.visibility_off_sharp,
                          ),
                        ),
                      ),
                      obscureText: obscured,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx1).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    var pwd = await _validatePassword(alertTextController.text,
                        pltfm); // Why async and await here? Some expert help me figure it out!!!
                    setState(() {
                      isPwdCorrect = pwd;
                    });
                    if (formKey.currentState!.validate() && ctx1.mounted) {
                      _displayPassword(pltfm, ctx1);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _validatePassword(String enteredPassword, String platform) async {
    var mPass = await Encryption.masterPassword();
    return (enteredPassword == mPass);
  }

  _displayPassword(platform, ctx) async {
    Navigator.of(ctx).pop();

    var pwd = await Encryption.getDecryptedPassword(platform);

    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (ctx1) {
        return AlertDialog(
          title: const Text('Password'),
          content: Text('Password:\n$pwd'),
          actions: [
            TextButton(
              onPressed: () {
                FlutterClipboard.copy(pwd);
                Navigator.of(ctx1).pop();
              },
              child: const Text('COPY'),
            )
          ],
        );
      },
    );
  }
}
