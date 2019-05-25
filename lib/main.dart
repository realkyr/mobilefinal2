import 'package:flutter/material.dart';
import './LoginForm.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Home', home: Login());
  }
}

class Login extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginForm()
      ),
    );
  }
}
