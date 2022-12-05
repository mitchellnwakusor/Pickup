import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickup_driver/services/firebase_services.dart';



User? currentFirebaseUser = FirebaseAuthentication().auth.currentUser;