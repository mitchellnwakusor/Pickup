import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickup_driver/map/models/user_info.dart';

import '../widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({this.user,Key? key}) : super(key: key);
  UserInformation? user;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body:  SettingsPage(user: widget.user,),
    );
  }
}
