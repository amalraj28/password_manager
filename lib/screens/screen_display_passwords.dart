import 'package:flutter/material.dart';

class DisplayPasswords extends StatelessWidget {
  const DisplayPasswords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Center(
        child: Text('Passwords will be listed here')
      ) 
      );
  }
}
