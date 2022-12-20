import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class AddProfilePictureScreen extends StatefulWidget {
  const AddProfilePictureScreen({Key? key}) : super(key: key);

  @override
  State<AddProfilePictureScreen> createState() => _AddProfilePictureScreenState();
}

class _AddProfilePictureScreenState extends State<AddProfilePictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Profile picture'),
    elevation: 0,
    ),
    body: ProfilePicturePage(),
    bottomNavigationBar: const Disclaimer(text: 'By proceeding you agree to our ', actionText: 'Terms & Conditions',)
    );
  }
}
