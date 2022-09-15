import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickup_driver/services/providers.dart';
import 'package:pickup_driver/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthentication{

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> requestOTPCode(BuildContext context) async{
   try {
     await auth.verifyPhoneNumber (
       forceResendingToken: Provider.of<Providers>(context,listen: false).token,
       phoneNumber: '+234${Provider.of<Providers>(context,listen: false).mobileNo}',
         timeout: const Duration(seconds: 30),
         verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{

           await auth.signInWithCredential(phoneAuthCredential);
           await auth.currentUser!.updateEmail(Provider.of<Providers>(context,listen: false).emailAddress);
           await auth.currentUser!.updatePassword(Provider.of<Providers>(context, listen: false).password);
           await auth.currentUser!.reload();
           Navigator.pop(context);
         },
         verificationFailed: (FirebaseAuthException e) async{
         Navigator.pop(context);
           showDialog(context: context, builder: (BuildContext context){
             return CustomDialog(titleText: e.code, contentText: e.message.toString());
           });
         },
         codeSent: (String verificationID, int? resendToken) async{
           Navigator.pop(context);
           Navigator.pushNamed(context, '/otpverification');
           Provider.of<Providers>(context,listen: false).setVerificationValue(verificationID);
           Provider.of<Providers>(context,listen: false).setTokenValue(resendToken);

         },
         codeAutoRetrievalTimeout: (String verificationID){}
     );
   } on FirebaseAuthException catch (e) {
     Navigator.pop(context);
     showDialog(context: context, builder: (BuildContext context){
       return CustomDialog(titleText: e.code, contentText: e.message.toString());
     });

   }
  }

  Future<bool> linkEmailPasswordCredentials(BuildContext context) async {
    try {
      await auth.currentUser!.updateEmail(Provider.of<Providers>(context,listen: false).emailAddress);
      await auth.currentUser!.updatePassword(Provider.of<Providers>(context,listen: false).password);
      // await auth.currentUser!.reload();
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
      return false;
    }
  }

  Future<bool> verifyMobileNo(String verificationID,String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential authCredential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: smsCode);
      await auth.signInWithCredential(authCredential);
      await linkEmailPasswordCredentials(context);
      Navigator.pop(context);
      return true;
      // Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
      return false;
    }

  }

  Future<void> sendResetPasswordLink(BuildContext context, String email) async{
    try {
      Navigator.pop(context);
      await auth.sendPasswordResetEmail(email: email);
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: 'Password reset link sent', contentText: 'A password reset link has been sent to $email');
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }

  Future<void> signInEmailPassword(BuildContext context, String email, String password) async{
    try {
      Navigator.pop(context);
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }

}

class FirebaseDatabase{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Future<void> storeUserInfo(BuildContext context,String firstName, String lastName, String email, String mobileNumber, User user) async{
    try {
      await firestore.collection('users').doc(user.uid).set({
        'first name': firstName.trim(),
        'last name': lastName.trim(),
        'email address': email.trim(),
        'mobile number': mobileNumber.trim(),
      });
    } on FirebaseException catch (e) {
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }
}





