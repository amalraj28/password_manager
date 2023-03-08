import 'package:flutter/material.dart';
import 'package:password_manager/db/database.dart';

late bool isDataAvailable;

class DisplayPasswords extends StatefulWidget {
  const DisplayPasswords({super.key});

  @override
  State<DisplayPasswords> createState() => _DisplayPasswordsState();
}

class _DisplayPasswordsState extends State<DisplayPasswords> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      isDataAvailable = UserDatabase.checkIfDataPresent();
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
            visible: isDataAvailable,
            child: TextButton(
              onPressed: () {
                displayDeletionWarning(context);
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
      body: isDataAvailable ? displayList() : noDataScreen(),
    );
  }

  displayList() {
    var data = UserDatabase.getData();
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(data[index].platform),
          subtitle: Text(data[index].username),
          trailing: IconButton(
            onPressed: () {
              deleteFromDatabase(data[index].platform, ctx);
            },
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.redAccent,
            ),
          ),
        );
      },
      separatorBuilder: (ctx, index) => const Divider(),
      itemCount: data.length,
    );
  }

  noDataScreen() {
    return const Center(
      child: Text('Stored Passwords will be displayed here'),
    );
  }

  clearDatabase() {
    setState(() {
      isDataAvailable = false;
    });
    UserDatabase.clearData();
  }

  displayDeletionWarning(BuildContext ctx) {
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
                clearDatabase();
                Navigator.of(ctx1).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  deleteFromDatabase(platform, ctx) {
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
}
