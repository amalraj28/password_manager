import 'package:flutter/material.dart';
import 'package:password_manager/screens/screen_login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    goToPage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }

  @override
  void dispose() {
    // Navigator.of(context).pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
		body: Center(
			child: Image.asset('assets/images/buzzer.jpg', height: 300,),
		)
	);
  }

  Future<void> goToPage() async{
	  await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }
}