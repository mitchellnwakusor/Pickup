import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pickup_driver/map/home_index.dart';
import 'package:pickup_driver/screens/home.dart';
import 'package:pickup_driver/services/firebase_services.dart';

class PlaceHolderPage extends StatefulWidget {
  PlaceHolderPage({this.user,Key? key}) : super(key: key);
  User? user;
  @override
  State<PlaceHolderPage> createState() => _PlaceHolderPageState();
}

class _PlaceHolderPageState extends State<PlaceHolderPage> {

  FirebaseRealtimeDatabase database = FirebaseRealtimeDatabase();
  bool? isRegistered;
  Future<bool> checkIfSignUpCompleted(User? user) async{
    bool? temp;
    //network check
    String path = '/dUser/${user!.uid}/Payment Info/card enabled';
    DataSnapshot snapshot = await database.database.ref(path).get();
    print(snapshot.value);
    if(snapshot.value!=null){
      print(snapshot.value);
          temp = true;
        }
    else{
          temp = false;
        }
    isRegistered = temp;
    print(isRegistered);
    // database.database.ref(path).onValue.listen((event) {
    //   final data = event.snapshot.value;
    //   if(data!=null){
    //     print(data);
    //     temp = true;
    //   }
    //   else{
    //     temp = false;
    //   }
    //   isRegistered = temp;
    //   return isRegistered!;
    // });
    // isRegistered = temp;
    // print(isRegistered);
    return isRegistered!;
  }


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    // database.fetchUserInfoLogin(context, '/home');
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: checkIfSignUpCompleted(widget.user),builder: (BuildContext c,AsyncSnapshot<bool> snapshot){
      if(snapshot.hasData){
          FirebaseRealtimeDatabase().fetchUserInfo(context, '/home');
          return Container();
      }
      else{
        return Container(
        );
      }
    });
  }
}
