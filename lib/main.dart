import 'package:flutter/material.dart';
import 'package:password_manager/screens/screen_splash.dart';
import 'package:password_manager/screens/screen_login.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeData(
				primarySwatch: Colors.lightGreen,
			),
			home: const HomeScreen(),
			debugShowCheckedModeBanner: false,
		);
	}
}