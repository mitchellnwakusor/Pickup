import 'package:flutter/material.dart';
import 'package:pickup_driver/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: const Text('Sign in to your account'),
       elevation: 0,
     ),
      body: const LoginForm(),
      bottomNavigationBar: const Disclaimer(text: 'By proceeding you agree to our ', actionText: 'Terms & Conditions',),
    );
  }
}
