import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickup_driver/map/home_index.dart';
import 'package:pickup_driver/screens/home.dart';
import 'package:pickup_driver/screens/login.dart';
import 'package:pickup_driver/screens/placeholder.dart';
import 'package:pickup_driver/screens/signup.dart';
import 'package:pickup_driver/services/firebase_services.dart';
import 'package:pickup_driver/services/providers.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> isPaymentInfoStored(User? user) async{
    final result = await FirebaseRealtimeDatabase().database.ref('dUser/${user!.uid}/Payment Info/card enabled').get();
    print(result.value);
    if(result.value!=null){
      return true;
    }
    else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuthentication().auth.authStateChanges(),builder: (BuildContext context,AsyncSnapshot<User?> snapshot)  {
      if(snapshot.hasData){
        User? tempUser = snapshot.data;
        return PlaceHolderPage(user: tempUser,);
        // bool? isStored;
        // Future<bool> func(User? user) async{
        //   //sign up complete
        //   if(await isPaymentInfoStored(user)){
        //     return true;
        //   }
        //   else{
        //     return false;
        //   }
        // }
        // isStored =  func(tempUser);
        // print(isStored);
        //
        // if(isStored!){
        //   FirebaseRealtimeDatabase().fetchUserInfo(context, null);
        //   return const HomeIndex();
        // }
        // else{
        //   return const PlaceHolderPage();
        // }
      }
      else {
        return Provider.of<Providers>(context,listen: true).loggedIn ? const SignupScreen() : const LoginScreen();
      }
    });
    // return Provider.of<Providers>(context,listen: true).loggedIn ? const SignupScreen() : const LoginScreen();

  }
}
