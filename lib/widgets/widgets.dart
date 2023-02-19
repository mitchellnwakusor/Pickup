import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickup_driver/services/firebase_services.dart';
import 'package:pickup_driver/services/providers.dart';
import 'package:pickup_driver/widgets/custom_color_theme.dart';
import 'package:provider/provider.dart';

import '../map/models/user_info.dart';
import 'custom_text_theme.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  CustomColorTheme colorTheme = CustomColorTheme();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    emailAddress.dispose();
    mobileNo.dispose();
    password.dispose();
    confirmPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 8,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: firstName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: const Text('First Name'),
                      hintText: 'John',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(colorTheme.backgroundColor.hashCode),
                      ))),
                  onChanged: (String value) =>
                      Provider.of<Providers>(context, listen: false)
                          .setFirstNameValue(value),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: lastName,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: const Text('Last Name'),
                      hintText: 'Doe',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(colorTheme.backgroundColor.hashCode),
                      ))),
                  onChanged: (String value) =>
                      Provider.of<Providers>(context, listen: false)
                          .setLastNameValue(value),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailAddress,
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
                              color: Color(colorTheme.appColor.hashCode)))),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) =>
                      Provider.of<Providers>(context, listen: false)
                          .setEmailAddressValue(value),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: mobileNo,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required.';
                    }
                    if (value.length < 10) {
                      return 'Mobile number is less than 11 digits';
                    }
                    if (value.length > 10) {
                      return 'Mobile number is more than 11 digits';
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      label: const Text('Mobile Number'),
                      prefix: const Text('+234'),
                      hintText: '8012345678',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(colorTheme.appColor.hashCode)))),
                  keyboardType: TextInputType.phone,
                  onChanged: (String value) =>
                      Provider.of<Providers>(context, listen: false)
                          .setMobileNoValue(value),
                ),
                const SizedBox(height: 8),
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
                        color: Color(colorTheme.appColor.hashCode),
                      ))),
                  obscureText: true,
                  onChanged: (String value) =>
                      Provider.of<Providers>(context, listen: false)
                          .setPasswordValue(value),
                ),
                const SizedBox(height: 8),
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
                        color: Color(colorTheme.appColor.hashCode),
                      ))),
                  obscureText: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
              text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                  text: 'Login',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Provider.of<Providers>(context, listen: false)
                          .setLoggedInValue();
                    },
                )
              ])),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  const LoadingWidget().showLoadingWidget(context);
                  await firebaseAuthentication.requestOTPCode(context);
                }
              },
              child: const Text('Sign up')),
        ],
      ),
    );
  }
}

class Disclaimer extends StatelessWidget {
  final String text;
  final String actionText;

  const Disclaimer({required this.text, required this.actionText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
          text: TextSpan(
              text: null,
              style: const TextStyle(color: Colors.black),
              children: [
            TextSpan(text: text),
            TextSpan(text: actionText),
          ])),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final String titleText;
  final String contentText;
  const CustomDialog(
      {required this.titleText, required this.contentText, Key? key})
      : super(
          key: key,
        );

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class CustomConfirmationDialog extends StatefulWidget {
  final String titleText;
  final String contentText;
  const CustomConfirmationDialog(
      {required this.titleText, required this.contentText, Key? key})
      : super(key: key);

  @override
  State<CustomConfirmationDialog> createState() =>
      _CustomConfirmationDialogState();
}

class _CustomConfirmationDialogState extends State<CustomConfirmationDialog> {
  FirebaseAuthentication authentication = FirebaseAuthentication();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text(widget.titleText),
        content: SingleChildScrollView(
          child: Text(widget.contentText),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
              label: Text(
                'Cancel',
                style: Theme.of(context).textTheme.labelMedium,
              )),
          TextButton.icon(
              onPressed: () async {
                await authentication.signOut(context);
              },
              icon: const Icon(
                Icons.logout,
              ),
              label: Text(
                'Sign out',
                style: Theme.of(context).textTheme.labelMedium,
              )),
        ],
      ),
    );
  }
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titleText),
      content: SingleChildScrollView(
        child: Text(widget.contentText),
      ),
    );
  }
}

class CustomInputDialog extends StatefulWidget {
  final String title;
  final String actionTitle;
  const CustomInputDialog(
      {required this.title, required this.actionTitle, Key? key})
      : super(key: key);

  @override
  State<CustomInputDialog> createState() => _CustomInputDialogState();
}

class _CustomInputDialogState extends State<CustomInputDialog> {
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  CustomColorTheme colorTheme = CustomColorTheme();
  TextEditingController inputController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: inputController,
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
                        color: Color(colorTheme.appColor.hashCode)))),
            keyboardType: TextInputType.emailAddress,
            onChanged: (String value) =>
                Provider.of<Providers>(context, listen: false)
                    .setEmailAddressValue(value),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                LoadingWidget().showLoadingWidget(context);
                await firebaseAuthentication.sendResetPasswordLink(
                    context, inputController.text);
              }
            },
            child: Text(widget.actionTitle))
      ],
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  void showLoadingWidget(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingWidget();
        });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class OTPForm extends StatefulWidget {
  const OTPForm({Key? key}) : super(key: key);

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  CustomTextTheme customTextTheme = CustomTextTheme();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  late TextStyle timerStyle;
  late String otp;
  void setTimeout() async {
    Future.delayed(const Duration(seconds: 30), () {
      timerStyle = customTextTheme.hyperlinkDark;
    });
  }

  final TextEditingController firstCode = TextEditingController();
  final TextEditingController secondCode = TextEditingController();
  final TextEditingController thirdCode = TextEditingController();
  final TextEditingController fourthCode = TextEditingController();
  final TextEditingController fifthCode = TextEditingController();
  final TextEditingController sixthCode = TextEditingController();

  final FocusNode firstCodeFocus = FocusNode();
  final FocusNode secondCodeFocus = FocusNode();
  final FocusNode thirdCodeFocus = FocusNode();
  final FocusNode fourthCodeFocus = FocusNode();
  final FocusNode fifthCodeFocus = FocusNode();
  final FocusNode sixthCodeFocus = FocusNode();

  @override
  void dispose() {
    firstCode.dispose();
    secondCode.dispose();
    thirdCode.dispose();
    fourthCode.dispose();
    fifthCode.dispose();
    sixthCode.dispose();

    firstCodeFocus.dispose();
    secondCodeFocus.dispose();
    thirdCodeFocus.dispose();
    fourthCodeFocus.dispose();
    fifthCodeFocus.dispose();
    sixthCodeFocus.dispose();

    super.dispose();
  }

  @override
  void initState() {
    timerStyle = customTextTheme.hyperlinkDark;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: 'Enter the 6-digit code sent to ',
                style: customTextTheme.bodyText),
            TextSpan(
                text:
                    '+234${Provider.of<Providers>(context, listen: false).mobileNo}',
                style: customTextTheme.bodyTextEmp),
          ])),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white),
                  width: 64.0,
                  height: 64.0,
                  child: Center(
                    child: TextField(
                      controller: firstCode,
                      focusNode: firstCodeFocus,
                      onTap: () {
                        firstCode.clear();
                      },
                      onChanged: (String value) {
                        if (value.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            firstCode.text = value;
                            print(firstCode.text);
                          });
                        }
                        if (value.isNotEmpty) {
                          secondCodeFocus.requestFocus();
                          secondCode.clear();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  // color: Colors.white,
                ),
              ),
              // const SizedBox(width: 16.0),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white),
                  width: 64.0,
                  height: 64.0,
                  child: Center(
                    child: TextField(
                      controller: secondCode,
                      focusNode: secondCodeFocus,
                      onTap: () {
                        secondCode.clear();
                      },
                      onChanged: (value) {
                        if (value.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            secondCode.text = value;
                          });
                        }
                        if (value.isNotEmpty) {
                          thirdCodeFocus.requestFocus();
                          thirdCode.clear();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  // color: Colors.white,
                ),
              ),
              // const SizedBox(width: 16.0),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white),
                  width: 64.0,
                  height: 64.0,
                  child: Center(
                    child: TextField(
                      controller: thirdCode,
                      focusNode: thirdCodeFocus,
                      onTap: () {
                        thirdCode.clear();
                      },
                      onChanged: (value) {
                        if (value.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            thirdCode.text = value;
                          });
                        }
                        if (value.isNotEmpty) {
                          fourthCodeFocus.requestFocus();
                          fourthCode.clear();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  // color: Colors.white,
                ),
              ),
              // const SizedBox(width: 16.0),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white),
                  width: 64.0,
                  height: 64.0,
                  child: Center(
                    child: TextField(
                      controller: fourthCode,
                      focusNode: fourthCodeFocus,
                      onTap: () {
                        fourthCode.clear();
                      },
                      onChanged: (value) {
                        if (value.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            fourthCode.text = value;
                          });
                        }
                        if (value.isNotEmpty) {
                          fifthCodeFocus.requestFocus();
                          fifthCode.clear();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  // color: Colors.white,
                ),
              ),
              // const SizedBox(width: 16.0),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white),
                  width: 64.0,
                  height: 64.0,
                  child: Center(
                    child: TextField(
                      controller: fifthCode,
                      focusNode: fifthCodeFocus,
                      onTap: () {
                        fifthCode.clear();
                      },
                      onChanged: (value) {
                        if (value.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            fifthCode.text = value;
                          });
                        }
                        if (value.isNotEmpty) {
                          sixthCodeFocus.requestFocus();
                          sixthCode.clear();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  // color: Colors.white,
                ),
              ),
              // const SizedBox(width: 16.0),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white),
                  width: 64.0,
                  height: 64.0,
                  child: Center(
                    child: TextField(
                      controller: sixthCode,
                      focusNode: sixthCodeFocus,
                      onTap: () {
                        sixthCode.clear();
                      },
                      onChanged: (value) {
                        if (value.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            sixthCode.text = value;
                            otp = firstCode.text +
                                secondCode.text +
                                thirdCode.text +
                                fourthCode.text +
                                fifthCode.text +
                                sixthCode.text;
                            context.read<Providers>().setOTPValue(otp);
                          });
                        }
                        if (value.isNotEmpty) {
                          sixthCodeFocus.nextFocus();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  // color: Colors.white,
                ),
              ),
              // const SizedBox(width: 16.0),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: 'Did not receive a code? ',
                style: customTextTheme.textDark),
            TextSpan(
                text: ' resend code',
                style: timerStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    LoadingWidget().showLoadingWidget(context);
                    try {
                      timerStyle = customTextTheme.textDark;
                      await firebaseAuthentication.requestOTPCode(context);
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                                titleText: e.code,
                                contentText: e.message.toString());
                          });
                    }
                  }),
          ])),
        ],
      ),
    );
  }
}



class VerifyOTPButton extends StatefulWidget {
  const VerifyOTPButton({Key? key}) : super(key: key);

  @override
  State<VerifyOTPButton> createState() => _VerifyOTPButtonState();
}

class _VerifyOTPButtonState extends State<VerifyOTPButton> {
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  FirebaseRealtimeDatabase firebaseDatabase = FirebaseRealtimeDatabase();
  @override
  Widget build(BuildContext context) {
    String firstName = Provider.of<Providers>(context).firstName;
    String lastName = Provider.of<Providers>(context).lastName;
    String email = Provider.of<Providers>(context).emailAddress;
    String mobileNo = Provider.of<Providers>(context).mobileNo;
    User user;
    return FloatingActionButton(
      onPressed: () async {
        const LoadingWidget().showLoadingWidget(context);
        bool successful = await firebaseAuthentication.verifyMobileNo(
            Provider.of<Providers>(context, listen: false).verificationCode,
            Provider.of<Providers>(context, listen: false).otpCode,
            context);
        if (successful) {
          user = firebaseAuthentication.auth.currentUser!;
          await firebaseDatabase.storePersonalInfo(
              context, firstName, lastName, email, mobileNo, user);
          await firebaseDatabase.storeDriverInfo(context, user);
        }
      },
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey,
      child: const Icon(
        Icons.arrow_forward,
        size: 32.0,
      ),
    );
  }
}

class VerifyNumberOTPButton extends StatefulWidget {
  const VerifyNumberOTPButton({Key? key}) : super(key: key);

  @override
  State<VerifyNumberOTPButton> createState() => _VerifyNumberOTPButtonState();
}

class _VerifyNumberOTPButtonState extends State<VerifyNumberOTPButton> {
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  FirebaseRealtimeDatabase firebaseDatabase = FirebaseRealtimeDatabase();
  @override
  Widget build(BuildContext context) {

    String email = Provider.of<Providers>(context).emailAddress;
    String mobileNo = Provider.of<Providers>(context).mobileNo;
    User user;
    return FloatingActionButton(
      onPressed: () async {
        const LoadingWidget().showLoadingWidget(context);

        bool successful = await firebaseAuthentication.verifyMobileNoReset( Provider.of<Providers>(context, listen: false).verificationCode,
            Provider.of<Providers>(context, listen: false).otpCode,context, Provider.of<Providers>(context, listen: false).mobileNo);

      },
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey,
      child: const Icon(
        Icons.arrow_forward,
        size: 32.0,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  CustomColorTheme colorTheme = CustomColorTheme();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  FirebaseRealtimeDatabase database = FirebaseRealtimeDatabase();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    emailAddress.dispose();
    mobileNo.dispose();
    password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 8,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailAddress,
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
                              color: Color(colorTheme.appColor.hashCode)))),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) =>
                      Provider.of<Providers>(context, listen: false)
                          .setEmailAddressValue(value),
                ),
                const SizedBox(height: 16),
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
                        color: Color(colorTheme.appColor.hashCode),
                      ))),
                  obscureText: true,
                  onChanged: (String value) =>
                      Provider.of<Providers>(context, listen: false)
                          .setPasswordValue(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
              text: TextSpan(
                  text: "Forgotten password? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                  text: 'Reset password',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomInputDialog(
                                title: 'Reset Password',
                                actionTitle: 'send reset instructions');
                          });
                    },
                )
              ])),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  const LoadingWidget().showLoadingWidget(context);
                  await firebaseAuthentication.signInEmailPassword(
                      context, emailAddress.text, password.text);
                  // await database.fetchUserInfoLogin(context,'/home');
                }
              },
              child: const Text('Sign in')),
          const SizedBox(height: 16),
          RichText(
              text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                  text: 'Register',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Provider.of<Providers>(context, listen: false)
                          .setLoggedInValue();
                    },
                )
              ])),
        ],
      ),
    );
  }
}

class PaymentCardForm extends StatefulWidget {
  const PaymentCardForm({Key? key}) : super(key: key);

  @override
  State<PaymentCardForm> createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FirebaseAuthentication authentication = FirebaseAuthentication();
  FirebaseRealtimeDatabase database = FirebaseRealtimeDatabase();
  final TextEditingController cardNumber = TextEditingController();
  final TextEditingController cardName = TextEditingController();
  final TextEditingController expDate = TextEditingController();
  final TextEditingController cvv = TextEditingController();
  String? cardIcon = 'lib/assets/icons/credit-card.png';
  String? date;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 3,
          shadowColor: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _key,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 240,
                          child: TextFormField(
                            controller: cardNumber,
                            onChanged: (String value) {
                              setState(() {
                                cardIcon = 'lib/assets/icons/credit-card.png';
                              });
                              if (value.length > 1 &&
                                  value[0] == '5' &&
                                  value.length <= 16) {
                                setState(() {
                                  cardIcon = 'lib/assets/icons/mc_symbol.png';
                                });
                              } else if (value.length > 1 &&
                                  value[0] == '4' &&
                                  value.length <= 16) {
                                setState(() {
                                  cardIcon =
                                      'lib/assets/icons/Visa_Brandmark_Blue_RGB_2021.png';
                                });
                              } else if (value.length > 1 &&
                                  value[0] == '5' &&
                                  value.length > 16) {
                                setState(() {
                                  cardIcon = 'lib/assets/icons/verve.png';
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required.';
                              }
                              if (value.length < 16) {
                                return 'Card number is less than 16 digits';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 24.0,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              label: Text('Card number'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: 'XXXX XXXX XXXX XXXX',
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(19),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                          child: Image.asset(cardIcon!),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 120.0,
                          child: TextFormField(
                            onChanged: (String value) {
                              if (value.length == 2 && !value.contains('/')) {
                                date = expDate.text;
                                TextSelection selection = expDate.selection;
                                String replacement = '/';
                                String newDate = date! + replacement;
                                // date.replaceRange(selection.start, selection.end, replacement);
                                final length = replacement.length;
                                expDate.value = TextEditingValue(
                                    text: newDate,
                                    selection: TextSelection.collapsed(
                                        offset: selection.baseOffset + length));
                                // expDate.selection = selection.copyWith(
                                //   baseOffset: selection.start + length,
                                //   extentOffset: selection.start + length,
                                // );
                                if (value == '/') {
                                  value = '';
                                }
                              }
                            },
                            controller: expDate,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.datetime,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            decoration: const InputDecoration(
                              label: Text('MONTH/YEAR'),
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'XX/XX',
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9 /]')),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 60.0,
                          child: TextFormField(
                            controller: cvv,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            decoration: const InputDecoration(
                              label: Text('CVV'),
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'XXX',
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: cardName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                    decoration: const InputDecoration(
                      label: Text('NAME ON CARD'),
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'CARD OWNER',
                      border: InputBorder.none,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
                      // FilteringTextInputFormatter.allow(RegExp(r'[ ]'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    const LoadingWidget().showLoadingWidget(context);
                    User? user = authentication.auth.currentUser;
                    await database.storePaymentInfo(context, cardName.text,
                        cardNumber.text, expDate.text, cvv.text, user!);
                  }
                },
                child: const Icon(Icons.arrow_forward_rounded),
              )),
        )
      ],
    ));
    // return ListView(
    //   children: [
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const SizedBox(height: 32.0),
    //         const Padding(
    //           padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
    //           child: Text(
    //             'Add a Payment Card',
    //             style: TextStyle(
    //                 color: Colors.blue,
    //                 fontSize: 24.0,
    //                 fontWeight: FontWeight.w600),
    //           ),
    //         ),
    //         const SizedBox(height: 16.0,),
    //         Card(
    //           margin: EdgeInsets.all(16.0),
    //           elevation: 3,
    //           shadowColor: Colors.grey[300],
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(10)
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Form(
    //               key: formKey,
    //               // autovalidateMode: AutovalidateMode.onUserInteraction,
    //               child: Column(
    //                 children: [
    //                   const SizedBox(height: 16.0,),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Expanded(
    //                         child: SizedBox(
    //                           width: 240,
    //                           child: TextFormField(
    //                             controller: cardNumber,
    //                             onChanged: (String value){
    //                               setState((){
    //                                 cardIcon = 'lib/assets/images/credit-card.png';
    //                               });
    //                               if(value.length>1 && value[0] == '5' && value.length <=16){
    //                                 setState((){
    //                                   cardIcon = 'lib/assets/images/mc_symbol.png';
    //                                 });
    //                               }
    //                               else if(value.length>1 && value[0] == '4' && value.length <=16){
    //                                 setState((){
    //                                   cardIcon = 'lib/assets/images/Visa_Brandmark_Blue_RGB_2021.png';
    //                                 });
    //                               }
    //                               else if(value.length>1 && value[0] == '5' && value.length >16){
    //                                 setState((){
    //                                   cardIcon = 'lib/assets/images/verve.png';
    //                                 });
    //                               }
    //                             },
    //                             validator: (value){
    //                               if (value == null || value.trim().isEmpty) {
    //                                 return 'This field is required.';
    //                               }
    //                               if (value.length < 16) {
    //                                 return 'Card number is less than 16 digits';
    //                               }
    //                               return null;
    //                             },
    //                             autovalidateMode: AutovalidateMode.onUserInteraction,
    //                             keyboardType: TextInputType.number,
    //                             style: const TextStyle(
    //                               fontSize: 24.0,
    //                             ),
    //                             decoration: const InputDecoration(
    //                               contentPadding: EdgeInsets.all(8.0),
    //                               label: Text('Card number'),
    //                               floatingLabelBehavior: FloatingLabelBehavior.always,
    //                               hintText: 'XXXX XXXX XXXX XXXX',
    //                               border: InputBorder.none,
    //                             ),
    //                             inputFormatters: [
    //                               LengthLimitingTextInputFormatter(19),
    //                               FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         width: 48,
    //                         child: Padding(
    //                           padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
    //                           child: Image.asset(cardIcon),
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                   const SizedBox(height: 16.0),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Expanded(
    //                         child: SizedBox(
    //                           width: 120.0,
    //                           child: TextFormField(
    //                             onChanged: (String value){
    //                               if(value.length==2 && !value.contains('/')){
    //                                 date = expDate.text;
    //                                 TextSelection selection = expDate.selection;
    //                                 String replacement = '/';
    //                                 String newDate = date + replacement;
    //                                 // date.replaceRange(selection.start, selection.end, replacement);
    //                                 final length = replacement.length;
    //                                 expDate.value = TextEditingValue(
    //                                     text: newDate,
    //                                     selection: TextSelection.collapsed(offset: selection.baseOffset + length)
    //                                 );
    //                                 // expDate.selection = selection.copyWith(
    //                                 //   baseOffset: selection.start + length,
    //                                 //   extentOffset: selection.start + length,
    //                                 // );
    //                                 if(value=='/'){
    //                                   value='';
    //                                 }
    //                               }
    //
    //                             },
    //                             controller: expDate,
    //                             autovalidateMode: AutovalidateMode.onUserInteraction,
    //                             validator: (value){
    //                               if (value == null ||
    //                                   value.trim().isEmpty) {
    //                                 return 'This field is required.';
    //                               }
    //                               return null;
    //                             },
    //                             keyboardType: TextInputType.datetime,
    //                             style: const TextStyle(
    //                               fontSize: 16.0,
    //                             ),
    //                             decoration: const InputDecoration(
    //                               label: Text('MONTH/YEAR'),
    //                               contentPadding: EdgeInsets.all(8.0),
    //                               hintText: 'XX/XX',
    //                               border: InputBorder.none,
    //                             ),
    //                             inputFormatters: [
    //                               LengthLimitingTextInputFormatter(5),
    //                               FilteringTextInputFormatter.allow(RegExp(r'[0-9 /]')),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       Expanded(
    //                         child: SizedBox(
    //                           width: 60.0,
    //                           child: TextFormField(
    //                             controller: cvv,
    //                             autovalidateMode: AutovalidateMode.onUserInteraction,
    //                             validator: (value){
    //                               if (value == null ||
    //                                   value.trim().isEmpty) {
    //                                 return 'This field is required.';
    //                               }
    //                               return null;
    //                             },
    //                             keyboardType: TextInputType.number,
    //                             style: const TextStyle(
    //                               fontSize: 16.0,
    //                             ),
    //                             decoration:
    //                             const InputDecoration(
    //                               label: Text('CVV'),
    //                               contentPadding: EdgeInsets.all(8.0),
    //                               hintText: 'XXX',
    //                               border: InputBorder.none,
    //                             ),
    //                             inputFormatters: [
    //                               LengthLimitingTextInputFormatter(3),
    //                               FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 16.0,),
    //                   TextFormField(
    //                     keyboardType: TextInputType.name,
    //                     controller: cardName,
    //                     autovalidateMode: AutovalidateMode.onUserInteraction,
    //                     validator: (value){
    //                       if (value == null ||
    //                           value.trim().isEmpty) {
    //                         return 'This field is required.';
    //                       }
    //                       return null;
    //                     },
    //                     style: const TextStyle(
    //                       fontSize: 16.0,
    //                     ),
    //                     decoration: const InputDecoration(
    //                       label: Text('NAME ON CARD'),
    //                       contentPadding: EdgeInsets.all(8.0),
    //                       hintText: 'CARD OWNER',
    //                       border: InputBorder.none,
    //                     ),
    //                     inputFormatters: [
    //                       FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
    //                       // FilteringTextInputFormatter.allow(RegExp(r'[ ]'))
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.centerLeft,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: TextButton(onPressed: (){Navigator.pushReplacementNamed(context, '/homeScreen');}, child: const Text('SKIP',style: TextStyle(letterSpacing: 1),),style: ButtonStyle(
    //               foregroundColor: MaterialStateProperty.all(Colors.grey),
    //             ),),
    //           ),
    //         ),
    //       ],
    //     ),
    //     // const SizedBox(height: 72.0),
    //     Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Align(
    //           alignment: Alignment.bottomRight,
    //           child: FloatingActionButton(backgroundColor: Colors.blueGrey,onPressed: () async{
    //             if(formKey.currentState!.validate()){
    //               setState((){
    //                 cardDate = expDate.text.replaceAll('/', '');
    //               });
    //               print('${cardNumber.text}  $cardDate ${cvv.text}');
    //               try {
    //                 await database.updateUserData(
    //                     cardName.text, cardNumber.text, expDate.text, cvv.text,
    //                     authentication.user);
    //                 Navigator.pushReplacementNamed(context, '/homeScreen');
    //               }
    //               on FirebaseException catch(e){
    //                 setState((){
    //                   errorMessage = e.message!;
    //                 });
    //                 dialog.showCustomErrorDialog(context, 'Unable to create account', errorMessage);
    //               }
    //             }
    //             // Navigator.pushNamed(context, '/profileScreen');
    //           }, child: const Icon(Icons.arrow_forward,color: Colors.white,size: 32.0,))),
    //     )
    //   ],
    //
    // );
  }
}

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({Key? key}) : super(key: key);

  @override
  State<ProfilePicturePage> createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  File? image;
  FirebaseStorageService storage = FirebaseStorageService();
  void useCamera() {}

  Future pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        Navigator.pop(context);
        return;
      }

      final imageTemp = File(image.path);
      this.image = imageTemp;
      File file = File(image.path);
      setState(() {});
      await storage.uploadProfilePicture(file, context);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                titleText: e.code, contentText: e.message.toString());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          if (image != null) ...[
            Expanded(
                flex: 2,
                child: CircleAvatar(
                  minRadius: 80,
                  backgroundImage: FileImage(image!, scale: 0.4),
                  backgroundColor: Colors.white,
                )),
          ] else ...[
            Expanded(
                flex: 2,
                child: CircleAvatar(
                  minRadius: 80,
                  backgroundImage:
                      const AssetImage('lib/assets/icons/blankPicture.png'),
                  backgroundColor: Colors.grey[300],
                )),
          ],
          const SizedBox(height: 32),
          Expanded(
              flex: 2,
              child: Text(
                'Please upload a passport photograph or selfie image with a white background.'
                ' This image will be used as your profile picture within the app.',
                style: Theme.of(context).textTheme.subtitle1,
              )),
          // const SizedBox(height: 16,),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        LoadingWidget().showLoadingWidget(context);
                        await pickImage(context);
                      },
                      icon: Icon(Icons.upload_file),
                      label: Text('UPLOAD PICTURE'),
                      style: Theme.of(context).elevatedButtonTheme.style,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (image == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog(
                                    titleText: 'No image uploaded',
                                    contentText:
                                        'Please upload a picture before continuing');
                              });
                        } else {
                          Navigator.pushNamed(context, '/addPaymentCard');
                        }
                      },
                      child: const Text('CONTINUE'),
                      style: Theme.of(context).elevatedButtonTheme.style,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user, Key? key}) : super(key: key);
  String? statusText;
  UserInformation? user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserInfoProvider>(context, listen: true)
        .userInformation!
        .personalInfo!
        .profileImage);
    // widget.user = Provider.of<UserInfoProvider>(context,listen: false).userInformation!;
    return SafeArea(
        child: Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
          margin: const EdgeInsets.all(0),
          // padding: EdgeInsets.all(16),
          color: Colors.blue.shade800,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CircleAvatar(radius: 80, backgroundImage: NetworkImage(Provider.of<UserInfoProvider>(context,listen: true).userInformation!.personalInfo!.profileImage!)),
                if (widget.user!.personalInfo!.profileImage == null) ...[
                  const CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(
                        'lib/assets/icons/blankPicture.png',
                      ))
                ] else ...[
                  CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          widget.user!.personalInfo!.profileImage!))
                ],
                const SizedBox(
                  height: 16,
                ),
                Text(
                  '${widget.user!.personalInfo!.firstName} ${widget.user!.personalInfo!.lastName}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontSize: 28,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${widget.user!.driverInfo!.noOfRides} Rides',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Center(
                          child: Container(
                        height: 24,
                        width: 2,
                        color: Colors.black,
                      )),
                      RatingStars(
                        value: double.parse(
                            widget.user!.driverInfo!.driverRating!.toString()),
                        // onValueChanged: (v) {
                        //   //
                        //   setState(() {
                        //     ratingsValue = v;
                        //   });
                        // },
                        starBuilder: (index, color) => Icon(
                          Icons.star,
                          color: color,
                        ),
                        starCount: 5,
                        starSize: 20,
                        valueLabelColor: const Color(0xff9b9b9b),
                        valueLabelTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        valueLabelRadius: 10,
                        maxValue: 5,
                        starSpacing: 2,
                        maxValueVisibility: true,
                        valueLabelVisibility: false,
                        animationDuration: const Duration(milliseconds: 1000),
                        valueLabelPadding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 8),
                        valueLabelMargin: const EdgeInsets.only(right: 8),
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: Colors.yellow,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: Text('Email address'),
                    subtitle:
                        Text('${widget.user!.personalInfo!.emailAddress}'),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Mobile number'),
                    subtitle:
                        Text('+234${widget.user!.personalInfo!.mobileNumber}'),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text('Active card'),
                    subtitle: Text(
                        '...${widget.user!.paymentInfo!.cardNumber!.substring(12)}'),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({this.user,Key? key}) : super(key: key);
  UserInformation? user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
       children: [
         Card(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8))),
           margin: EdgeInsets.all(0),
           color: Colors.blue[800],
           child: Padding(
             padding: const EdgeInsets.all(16.0),
             child: Stack(
               children: [
                 Positioned(child: GestureDetector(
                   onTap: (){
                    Navigator.pushNamed(context, '/editProfilePicture');
                   },
                   child: CircleAvatar(
                     minRadius: 80,
                     backgroundImage:  NetworkImage(widget.user!.personalInfo!.profileImage!), //AssetImage('blankPicture.png')
                     backgroundColor: Colors.white54,
                   ),
                 ),),
                  Positioned(left: MediaQuery.of(context).size.width/1.7,child : Icon(Icons.edit,color: Colors.white,size: 48,),)
               ],
             ),
           ),
         ),
         const SizedBox(height: 32,),
         ListTile(
           onTap: (){
             Navigator.pushNamed(context, '/changeNumber');
           },
           title: Text('Change Number'),
           trailing: Icon(Icons.arrow_forward),
           // tileColor: Colors.white54,
         ),
         const Divider(height:0,thickness: 2,color: Colors.white54,),
         ListTile(
          onTap: (){
            Navigator.pushNamed(context, '/changeEmail');
          },
           title: Text('Change Email'),
           trailing: Icon(Icons.arrow_forward),
           // tileColor: Colors.grey.shade300,
         ),
         const Divider(height:0,thickness: 2,color: Colors.white54,),
         ListTile(
           onTap: (){
             Navigator.pushNamed(context, '/verifyEmail');
           },
           title: Text('Verify Email'),
           trailing: Icon(Icons.arrow_forward),
           // tileColor: Colors.grey.shade300,
         ),
         const Divider(height:0,thickness: 2,color: Colors.white54,),
         ListTile(
           onTap: (){
             Navigator.pushNamed(context, '/resetPassword');
           },
           title: Text('Reset Password'),
           trailing: Icon(Icons.arrow_forward),
           // tileColor: Colors.grey.shade300,
         ),
         const Divider(height:0,thickness: 2,color: Colors.white54,),
       ],
      ),
    );
  }
}
