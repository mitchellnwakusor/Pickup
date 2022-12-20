import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickup_driver/map/models/user_info.dart';
import 'package:pickup_driver/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {

  //Todo: Add driver subclass to user model, rides,driverRating
  //Todo: Add user picture file to personal info class

  String? statusText;
  UserInformation? user;

  //use usermodel instead of so many properties
  ProfileScreen({this.statusText,this.user,Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ProfilePage(user: widget.user,),
    );
  }
}
