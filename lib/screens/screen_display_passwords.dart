import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/db/database.dart';
import 'package:password_manager/encryption/encryption.dart';
import 'package:password_manager/screens/screen_change_entry.dart';
import 'package:password_manager/screens/screen_change_master_pass.dart';
import 'package:password_manager/screens/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

late bool _isDataAvailable;

class DisplayPasswords extends StatefulWidget {
  const DisplayPasswords({super.key});
  @override
  State<DisplayPasswords> createState() => _DisplayPasswordsState();
}

class _DisplayPasswordsState extends State<DisplayPasswords> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _isDataAvailable = UserDatabase.checkIfDataPresent();
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .pushNamed('/create_entry')
              .then((_) => setState(() {}));
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          size: 50,
        ),
      ),
      appBar: AppBar(
        title: const Text('Passwords Stored'),
        actions: [
          PopupMenuButton(
            itemBuilder: ((ctx) {
              return const [
                PopupMenuItem(
                  value: 'clear',
                  child: Text('Clear Data'),
                ),
                PopupMenuItem(
                  value: 'masterPassword',
                  child: Text('Change Master Password'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            }),
            onSelected: (value) async {
              switch (value) {
                case 'clear':
                  if (_isDataAvailable) {
                    await _displayDeletionWarning(context);
                  }
                  break;
                case 'masterPassword':
                  await _changeMasterPassword(context);
                  break;
                case 'logout':
                  _logout(context);
                  break;
              }
            },
          ),
        ],
      ),
      body: _isDataAvailable ? _displayList() : _noDataScreen(),
    );
  }

  void _logout(BuildContext ctx) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
    if (ctx.mounted) {
      await Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx1) => LoginScreen()),
        (route) => false,
      );
    }
  }

  _displayList() {
    var data = UserDatabase.getData();
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTapDown: (details) {
            _getTapPosition(details);
          },
          child: ListTile(
            title: Text(data[index].platform),
            onLongPress: () {
              _showMenu(ctx, data[index].platform);
            },
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
          ),
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

  _enterMasterPassword(platform) {
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
                    var pwd = await _validatePassword(
                      alertTextController.text,
                    ); // Why async and await here? Some expert help me figure it out!!!
                    setState(() {
                      isPwdCorrect = pwd;
                    });
                    if (formKey.currentState!.validate() && ctx1.mounted) {
                      _displayPassword(platform, ctx1);
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

  _validatePassword(String enteredPassword) async {
    var mPass = await Encryption.masterPassword();
    return (enteredPassword == mPass);
  }

  _displayPassword(platform, ctx) async {
    Navigator.of(ctx).pop();

    var pwd = await Encryption.getDecryptedPassword(platform);

    if (pwd == null && context.mounted) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter previous master password',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
    var username =
        await UserDatabase.findItemFromDb(key: platform)[0]['username'];

    bool userNameCopied = false;
    bool passwordCopied = false;

    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (ctx1) {
        return StatefulBuilder(
          builder: (ctx1, setState) {
            return AlertDialog(
              title: Text('$platform'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Username:\n $username',
                      ),
                      IconButton(
                        onPressed: () async {
                          await FlutterClipboard.copy(username);
                          setState(() {
                            userNameCopied = true;
                            passwordCopied = false;
                          });
                        },
                        icon: const Icon(Icons.copy),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password:\n$pwd'),
                      IconButton(
                        onPressed: () async {
                          await FlutterClipboard.copy(pwd);
                          setState(() {
                            passwordCopied = true;
                            userNameCopied = false;
                          });
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: userNameCopied,
                    child: const Text(
                      'Username copied to clipboard',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: passwordCopied,
                    child: const Text(
                      'Password copied to clipboard',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx1).pop();
                  },
                  child: const Text('Close'),
                )
              ],
            );
          },
        );
      },
    );
  }

  _changeMasterPassword(BuildContext ctx) async {
    await Navigator.of(ctx)
        .push(
            MaterialPageRoute(builder: (ctx1) => const ChangeMasterPassword()))
        .then((_) => setState(() {}));
  }

  // Function to get the tap position
  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  _showMenu(ctx, platform) async {
    // Get position of tap down
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      context: ctx,
      // Set the position of the tap down menu
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
      items: [
        const PopupMenuItem(
          value: 0,
          child: Text('Update'),
        ),
      ],
    );

    if (result == 0) {
      // ignore: use_build_context_synchronously
      await Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (ctx1) => UpdateEntry(platform: platform),
            ),
          )
          .then((_) => setState(() {}));
    }
  }
}
