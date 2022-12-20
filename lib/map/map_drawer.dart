import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickup_driver/map/models/user_info.dart';
import 'package:pickup_driver/screens/profile.dart';
import 'package:pickup_driver/screens/settings.dart';
import 'package:pickup_driver/services/firebase_services.dart';
import 'package:pickup_driver/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/providers.dart';


class MapDrawer extends StatefulWidget {
  UserInformation? user;
 String? name;
 String? email;
 String? statusText;
 MapDrawer({this.name,this.email,this.statusText,this.user});

  @override
  State<MapDrawer> createState() => _MapDrawerState();
}

class _MapDrawerState extends State<MapDrawer> {
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    print(widget.user!.personalInfo!.profileImage);
    return Drawer(
      child: ListView(
        children: [
          //drawer header

          Container(
            height: 165,
            color: Colors.blueGrey,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
                child: Row(
            children: [
             if(widget.user!.personalInfo!.profileImage==null)...[
               const CircleAvatar(radius: 40,backgroundImage: AssetImage('lib/assets/icons/blankPicture.png'),)
             ]
              else...[
               CircleAvatar(radius: 40, backgroundImage: NetworkImage(widget.user!.personalInfo!.profileImage!),)
             ],
             const SizedBox(width: 16),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user!.personalInfo!.firstName!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),

                  const SizedBox( height: 10,),
                  if(widget.statusText!="Now Online")...[
                    Row(children: [Icon(Icons.circle,size: 16,color: Colors.red,),SizedBox(width: 8,),Text('Offline',style: TextStyle(color: Colors.white),)],)
                  ]
                  else...[
                    Row(children: [Icon(Icons.circle,size: 16,color: Colors.green,),SizedBox(width: 8,),Text('Online',style: TextStyle(color: Colors.white),)],)
                  ],
                  // Text(
                  //   widget.email.toString(),
                  //   style: const TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.white,
                  //
                  //   ),
                  // ),

                ],
              )

            ],
                ),
            ),
          ),

          const SizedBox(height: 12.0,),

          //drawer body

          //history tab
          GestureDetector(
            onTap: (){

            },
            child: const ListTile(
              leading: Icon(Icons.history, color: Colors.white54,),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          //profile tab
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext c){
                return ProfileScreen(user: widget.user,);
              }));
            },
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.white54,),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          // about
          GestureDetector(
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return SettingsScreen(user: widget.user,);
            }));
            },
            child: const ListTile(
              leading: Icon(Icons.settings, color: Colors.white54,),
              title: Text(
                  "Settings",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          // sign out tab
          GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (c){
                return const CustomConfirmationDialog(titleText: 'Sign out', contentText: 'Are you sure you want to sign out of your account?');
              });
              // firebaseAuthentication.signOut(context);
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.white54,),
              title: Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
