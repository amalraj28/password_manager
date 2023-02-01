import 'package:flutter/material.dart';

class CreateNewEntry extends StatelessWidget {
  CreateNewEntry({super.key});

  final _platformController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _platformFocus = FocusNode();

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
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            focusNode: _passwordFocus,
            onTapOutside: (event) => _passwordFocus.unfocus(),
            obscureText: false,
            controller: _passwordController,
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
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  onSubmit(context);
                },
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
  }

  savedSuccess(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Data Saved Successfully'),
      ),
    );
    clearControllers();
  }
}