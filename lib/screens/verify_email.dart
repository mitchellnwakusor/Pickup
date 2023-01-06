import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickup_driver/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../services/providers.dart';
import '../widgets/widgets.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  // GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          title: Text('Verify Email'),
        ),
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Click the button below to send a verification link to your email address'),
                    const SizedBox(height: 16,),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                              const LoadingWidget().showLoadingWidget(context);
                              await FirebaseAuthentication().verifyEmail(context);
                          },
                          child: const Text('NEXT')),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }
}




