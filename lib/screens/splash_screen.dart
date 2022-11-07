import 'package:flutter/material.dart';
import 'package:pickup_driver/maps/passenger_destination.dart';
import 'package:pickup_driver/screens/home.dart';
import 'package:pickup_driver/screens/login.dart';
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
  FirebaseAuthentication firebaseAuth = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebaseAuth.auth.authStateChanges(),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          //  Todo: Insert placeholder

          return const Placeholder();
        }
        else{
          return context.watch<Providers>().loggedIn ? const LoginScreen() : const SignupScreen();
        }
      },
    );
  }
}
