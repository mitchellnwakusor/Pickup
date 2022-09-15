import 'package:flutter/material.dart';
import 'package:pickup_driver/widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an account'),
        elevation: 0,
      ),
      body: const SignupForm(),
      bottomNavigationBar: const Disclaimer(text: 'By proceeding you agree to our ', actionText: 'Terms & Conditions',),
    );
  }
}
