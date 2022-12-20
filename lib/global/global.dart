import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../services/firebase_services.dart';



User? currentFirebaseUser =  FirebaseAuthentication().auth.currentUser;
StreamSubscription<Position>? streamSubscriptionPosition;