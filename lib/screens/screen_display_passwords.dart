import 'package:flutter/material.dart';
import 'package:password_manager/db/database.dart';
import 'package:password_manager/models/data_models.dart';
import 'package:realm/realm.dart';

class DisplayPasswords extends StatelessWidget {
  const DisplayPasswords({super.key});

  @override
  Widget build(BuildContext context) {
    var data = readDatabase();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(data[index].platform),
            subtitle: Text(data[index].username),
          );
        },
        separatorBuilder: (ctx, index) => const Divider(),
        itemCount: data.length,
      ),
    );
  }

  List<DataModel> readDatabase() {
    var realm = UserDatabase.openDatabase();
    var data = UserDatabase.getData();
    realm.close();
    return data;
  }
}
