import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/db/database.dart';
import 'package:password_manager/encryption/encryption.dart';
import 'package:password_manager/models/data_models.dart';
import 'package:password_manager/scripts/password_generator.dart';

class CreateNewEntry extends StatefulWidget {
  const CreateNewEntry({super.key});

  @override
  State<CreateNewEntry> createState() => _CreateNewEntryState();
}

class _CreateNewEntryState extends State<CreateNewEntry> {
  final _platformController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _platformFocus = FocusNode();
  final _sizedBoxPadding = 15.0;
  late bool _isButtonEnabled;
  late bool _duplicatePlatform;

  @override
  void initState() {
    _isButtonEnabled = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              focusNode: _platformFocus,
              onTapOutside: (event) => _platformFocus.unfocus(),
              controller: _platformController,
              decoration: const InputDecoration(
                label: Text('Website/App/Platform'),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  _isButtonEnabled = _dataInAllFields();
                });
              },
            ),
            SizedBox(height: _sizedBoxPadding),
            TextFormField(
                focusNode: _usernameFocus,
                onTapOutside: (event) => _usernameFocus.unfocus(),
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text('Username/Email'),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    _isButtonEnabled = _dataInAllFields();
                  });
                }),
            SizedBox(height: _sizedBoxPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    focusNode: _passwordFocus,
                    onTapOutside: (event) => _passwordFocus.unfocus(),
                    obscureText: false,
                    controller: _passwordController,
                    onChanged: (text) {
                      setState(() {
                        _isButtonEnabled = _dataInAllFields();
                      });
                    },
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _generatePasswordButtonExecution(context);
                  },
                  child: const Text(
                    'Generate Password',
                    style: TextStyle(backgroundColor: Colors.cyanAccent),
                  ),
                ),
              ],
            ),
            SizedBox(height: _sizedBoxPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          _onSubmit(context);
                        }
                      : null,
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _onReset(context);
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onSubmit(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx1) {
        return AlertDialog(
          title: const Text('Confirm Data'),
          scrollable: true,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('The following data was entered: '),
                const SizedBox(height: 5.0),
                Text('Platform: ${_platformController.text.trim()}'),
                Text('Username: ${_usernameController.text.trim()}'),
                Text('Password: ${_passwordController.text.trim()}'),
                const SizedBox(height: 5.0),
                const Text('Do you wish to save this data?')
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx1).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _savedSuccess(ctx);
                Navigator.of(ctx1).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  _onReset(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx1) {
        return AlertDialog(
          content: const Text('Are you sure to reset all fields?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx1).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _clearControllers();
                Navigator.of(ctx1).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  _clearControllers() {
    _passwordController.clear();
    _usernameController.clear();
    _platformController.clear();
    setState(() {
      _isButtonEnabled = false;
    });
  }

  _savedSuccess(BuildContext ctx) async {
    final user = _usernameController.text.trim();
    final platform = _platformController.text.trim().toUpperCase();

    var encryptedData = await Encryption.encryptText(_passwordController.text.trim());

    final encryptedPassword = encryptedData[0].base64;
    final salt = encryptedData[1];
    final iv = encryptedData[2].base64;

    PasswordSalt pwdMetadata = PasswordSalt(platform, salt, iv);
    DataModel userData = DataModel(user, encryptedPassword, platform);

    _duplicatePlatform = await UserDatabase.addData(
        data: userData, encryptionMetadata: pwdMetadata);

    if (_duplicatePlatform && ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Website or platform entered is already present in the database.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else if (ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Data Saved Successfully'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    _clearControllers();
  }

  bool _dataInAllFields() {
    final pwd = _passwordController.text.trim();
    final username = _usernameController.text.trim();
    final platform = _platformController.text.trim();

    return pwd.isNotEmpty && username.isNotEmpty && platform.isNotEmpty;
  }

  void _generatePasswordButtonExecution(BuildContext ctx) {
    _passwordController.text = generatePassword();
    setState(() {
      _isButtonEnabled = _dataInAllFields();
    });
    FlutterClipboard.copy(_passwordController.text);
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: const Text('Password Copied to Clipboard'),
        backgroundColor: Colors.green.shade400,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
