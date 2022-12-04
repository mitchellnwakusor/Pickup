import 'package:flutter/material.dart';
import 'package:pickup_driver/services/firebase_services.dart';

class PlaceHolderPage extends StatefulWidget {
  const PlaceHolderPage({Key? key}) : super(key: key);

  @override
  State<PlaceHolderPage> createState() => _PlaceHolderPageState();
}

class _PlaceHolderPageState extends State<PlaceHolderPage> {

  FirebaseRealtimeDatabase database = FirebaseRealtimeDatabase();

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    database.fetchUserInfoLogin(context, '/home');
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
