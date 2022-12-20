import 'package:flutter/material.dart';
import 'package:pickup_driver/widgets/widgets.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: const OTPForm(),
      floatingActionButton: const VerifyOTPButton(),
    );
  }
}

class VerifyOTPResetNumber extends StatefulWidget {
  const VerifyOTPResetNumber({Key? key}) : super(key: key);

  @override
  State<VerifyOTPResetNumber> createState() => _VerifyOTPResetNumberState();
}

class _VerifyOTPResetNumberState extends State<VerifyOTPResetNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: const OTPForm(),
      floatingActionButton: const VerifyNumberOTPButton(),
    );
  }
}