import 'package:flutter/material.dart';

getSnackBar(
    {required String text, required Color color, padding = 10.0, required BuildContext context, duration = const Duration(seconds: 2)}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      padding: EdgeInsets.all(padding),
      backgroundColor: color,
      duration: duration,
    ),
  );
}
