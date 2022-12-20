import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/providers.dart';
import '../widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          title: Text('Reset Password'),
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
                      const Text('Enter a new password'),
                      const SizedBox(height: 8,),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: password,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          String pattern =
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          if (!RegExp(pattern).hasMatch(value)) {
                            return 'Password should contain an uppercase letter, lowercase letter, number, symbol and should be more than 8 digits';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: const Text('Password'),
                            // hintText: 'johndoe@gmail.com',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:Colors.blue.shade900,
                                ))),
                        obscureText: true,
                        onChanged: (String value) =>
                            Provider.of<Providers>(context, listen: false)
                                .setPasswordValue(value),
                      ),
                      const SizedBox(height: 8),
                      const Text('Re-enter your password'),
                      const SizedBox(height: 8,),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: confirmPassword,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          if (password.text.trim() != value) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: const Text('Confirm Password'),
                            // hintText: 'johndoe@gmail.com',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue.shade900,
                                ))),
                        obscureText: true,
                      ),
                      SizedBox(height: 16,),
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
