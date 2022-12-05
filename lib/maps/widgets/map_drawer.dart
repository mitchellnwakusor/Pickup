import 'package:flutter/material.dart';
import 'package:pickup_driver/widgets/widgets.dart';

class MapDrawer extends StatefulWidget {
  String? name;
  String? email;

  MapDrawer({this.name, this.email});

  @override
  State<MapDrawer> createState() => _MapDrawerState();
}

class _MapDrawerState extends State<MapDrawer> {

  @override
  Widget build(BuildContext context) {
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
                  const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // const SizedBox( height: 10,),
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

          const SizedBox(
            height: 12.0,
          ),

          //drawer body

          //ride history
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.white54,
              ),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          //user profile
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white54,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          //about
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white54,
              ),
              title: Text(
                "About",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          //sign out
          GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (BuildContext context){
                return const CustomConfirmationDialog(titleText: 'Sign out', contentText: 'Are you sure you want to sign out?');
              });
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white54,
              ),
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
