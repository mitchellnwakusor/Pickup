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


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuthentication().auth.authStateChanges(),builder: (BuildContext context,AsyncSnapshot<User?> snapshot){
      if(snapshot.hasData){
        if(Provider.of<UserInfoProvider>(context).userInformation!=null){
          return const HomeIndex();
        }
        return const PlaceHolderPage();
        //switch with actual splash screen
      }
      else {
        return Provider.of<Providers>(context,listen: true).loggedIn ? const SignupScreen() : const LoginScreen();
      }
    });
    return Provider.of<Providers>(context,listen: true).loggedIn ? const SignupScreen() : const LoginScreen();

  }
}
