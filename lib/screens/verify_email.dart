import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/providers.dart';
import '../widgets/widgets.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

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
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter your email address'),
                      const SizedBox(height: 8,),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required.';
                          }
                          String pattern = r'\w+@\w+\.\w+';
                          if (!RegExp(pattern).hasMatch(value)) {
                            return 'Invalid E-mail address format.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[!#/\$~&*]')),
                          FilteringTextInputFormatter.deny(RegExp('[A-Z]'))
                        ],
                        decoration: InputDecoration(
                            label: const Text('Email Address'),
                            hintText: 'johndoe@gmail.com',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.shade900))),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String value) =>
                            Provider.of<Providers>(context, listen: false)
                                .setEmailAddressValue(value),
                      ),
                      const SizedBox(height: 16,),
                      const Text('Enter your email address again'),
                      const SizedBox(height: 8,),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required.';
                          }
                          String pattern = r'\w+@\w+\.\w+';
                          if (!RegExp(pattern).hasMatch(value)) {
                            return 'Invalid E-mail address format.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[!#/\$~&*]')),
                          FilteringTextInputFormatter.deny(RegExp('[A-Z]'))
                        ],
                        decoration: InputDecoration(
                            label: const Text('Email Address'),
                            hintText: 'johndoe@gmail.com',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.shade900))),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String value) =>
                            Provider.of<Providers>(context, listen: false)
                                .setEmailAddressValue(value),
                      ),
                      const SizedBox(height: 16,),
                      Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                const LoadingWidget().showLoadingWidget(context);
                              }
                            },
                            child: const Text('NEXT')),
                      ),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}




