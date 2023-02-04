import 'package:flutter/material.dart';

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
                _isButtonEnabled = dataInAllFields();
              });
            },
          ),
          const SizedBox(height: 10.0),
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
                  _isButtonEnabled = dataInAllFields();
                });
              }),
          const SizedBox(height: 10.0),
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
                      _isButtonEnabled = dataInAllFields();
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
                  // _passwordController.text = 'hello';
                  // _passwordFocus.requestFocus();
                },
                child: const Text(
                  'Generate Password',
                  style: TextStyle(backgroundColor: Colors.cyanAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        onSubmit(context);
                      }
                    : null,
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  onReset(context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onSubmit(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx1) {
        return AlertDialog(
          title: const Text('Confirm Data'),
          scrollable: true,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                savedSuccess(ctx);
                Navigator.of(ctx1).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  onReset(BuildContext ctx) {
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
                clearControllers();
                Navigator.of(ctx1).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  clearControllers() {
    _passwordController.clear();
    _usernameController.clear();
    _platformController.clear();
    setState(() {
      _isButtonEnabled = false;
    });
  }

  savedSuccess(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Data Saved Successfully'),
      ),
    );
    clearControllers();
  }

  bool dataInAllFields() {
    final pwd = _passwordController.text;
    final username = _usernameController.text;
    final platform = _platformController.text;

    if (pwd.isNotEmpty && username.isNotEmpty && platform.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
