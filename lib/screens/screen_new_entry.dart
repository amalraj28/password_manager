import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _isButtonEnabled = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            focusNode: _platformFocus,
            onTapOutside: (event) => _platformFocus.unfocus(),
            controller: _platformController,
            decoration: const InputDecoration(
              label: Text('Website/App/Platform'),
              // hintText: 'The platform whose credentials are to be set',
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
                // hintText: 'The platform whose credentials are to be set',
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
                    // hintText: 'The platform whose credentials are to be set',
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
                Text('Platform: ${_platformController.text}'),
                Text('Username: ${_usernameController.text}'),
                Text('Password: ${_passwordController.text}'),
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

  _savedSuccess(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Data Saved Successfully'),
      ),
    );
    _clearControllers();
  }

  bool _dataInAllFields() {
    final pwd = _passwordController.text;
    final username = _usernameController.text;
    final platform = _platformController.text;

    if (pwd.isNotEmpty && username.isNotEmpty && platform.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void _generatePasswordButtonExecution(BuildContext ctx) {
    _passwordController.text = generatePassword();
    // _passwordFocus.requestFocus();
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
