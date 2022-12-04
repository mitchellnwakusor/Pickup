import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pickup_driver/services/providers.dart';
import 'package:pickup_driver/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../maps/models/user_info.dart';

class FirebaseAuthentication{

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseRealtimeDatabase database = FirebaseRealtimeDatabase();
  Future<void> requestOTPCode(BuildContext context) async{
   try {
     await auth.verifyPhoneNumber (
       forceResendingToken: Provider.of<Providers>(context,listen: false).token,
       phoneNumber: '+234${Provider.of<Providers>(context,listen: false).mobileNo}',
         timeout: const Duration(seconds: 30),
         verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
           // Navigator.pop(context);
           // await auth.signInWithCredential(phoneAuthCredential);
           // await auth.currentUser!.updateEmail(Provider.of<Providers>(context,listen: false).emailAddress);
           // await auth.currentUser!.updatePassword(Provider.of<Providers>(context, listen: false).password);
           // await auth.currentUser!.reload();
           // Navigator.pop(context);
         },
         verificationFailed: (FirebaseAuthException e) async{
         Navigator.pop(context);
           showDialog(context: context, builder: (BuildContext context){
             return CustomDialog(titleText: e.code, contentText: e.message.toString());
           });
         },
         codeSent: (String verificationID, int? resendToken) async{
           Navigator.pop(context);
           Provider.of<Providers>(context,listen: false).setVerificationValue(verificationID);
           Provider.of<Providers>(context,listen: false).setTokenValue(resendToken);
           Navigator.pushNamed(context, '/otpverification');
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
      Navigator.pushReplacementNamed(context, '/addPaymentCard');
      return true;
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
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if(credential.user!=null){
        await database.fetchUserInfoLogin(context,'/home');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }

}

class FirebaseRealtimeDatabase{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void>fetchUserInfo(BuildContext context,String? routeName) async{
    User? user = FirebaseAuthentication().auth.currentUser;
    UserInformation userInformation;
    print(user?.uid);
    Map? userInfoMap;
    try {
      database
          .ref('/dUser/${user!.uid}')
          .onValue
          .listen((event) {
        // database.ref('/pUser/fP0CE5J4ZOTjBsQwcu0aQAuu1iW2').onValue.listen((event) {
        userInfoMap = Map<String, dynamic>.from(event.snapshot.value as Map);
        print(userInfoMap);
        Map? personalInfoMap = userInfoMap!['Personal Info'];
        Map? paymentInfoMap = userInfoMap!['Payment Info'];

        // create userInfo object from map
        PersonalInfo personalInfo = PersonalInfo(
            emailAddress: personalInfoMap!['email address'],
            firstName: personalInfoMap!['first name'],
            lastName: personalInfoMap!['last name'],
            mobileNumber: personalInfoMap!['mobile number']);
        PaymentInfo paymentInfo = PaymentInfo(
          cardCvv: paymentInfoMap!['card cvv'],
          cardEnabled: paymentInfoMap!['card enabled'],
          cardExpDate: paymentInfoMap!['card expDate'],
          cardholderName: paymentInfoMap!['cardholder name'],
          cardNumber: paymentInfoMap!['card number'],);

        userInformation =
            UserInformation(
                personalInfo: personalInfo, paymentInfo: paymentInfo);
        Provider.of<UserInfoProvider>(context, listen: false)
            .updateUserInfoObject(userInformation);

        print(Provider
            .of<UserInfoProvider>(context, listen: false)
            .userInformation
            ?.personalInfo
            ?.firstName);

        if(routeName!=null){
          Navigator.pushReplacementNamed(context, routeName);
        }
      });
    }
    on FirebaseException catch(e){
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }
  Future<void>fetchUserInfoLogin(BuildContext context, String? routeName) async{
    Navigator.pop(context);
    FirebaseAuthentication authentication = FirebaseAuthentication();
    User? user = authentication.auth.currentUser;
    UserInformation userInformation;
    print(user?.uid);
    Map? userInfoMap;
    try {
      database.ref('/dUser/${user!.uid}').onValue.listen((event) {
        // database.ref('/pUser/fP0CE5J4ZOTjBsQwcu0aQAuu1iW2').onValue.listen((event) {
        userInfoMap = Map<String,dynamic>.from(event.snapshot.value as Map);
        print(userInfoMap);
        Map? personalInfoMap = userInfoMap!['Personal Info'];
        Map? paymentInfoMap = userInfoMap!['Payment Info'];

        // create userInfo object from map
        PersonalInfo personalInfo = PersonalInfo(emailAddress: personalInfoMap!['email address'],firstName: personalInfoMap!['first name'],lastName: personalInfoMap!['last name'],mobileNumber: personalInfoMap!['mobile number'],userType: personalInfoMap!['user type']);
        PaymentInfo paymentInfo = PaymentInfo(cardCvv: paymentInfoMap!['card cvv'],cardEnabled: paymentInfoMap!['card enabled'],cardExpDate: paymentInfoMap!['card expDate'],cardholderName: paymentInfoMap!['cardholder name'],cardNumber: paymentInfoMap!['card number'],);

        userInformation = UserInformation(personalInfo: personalInfo,paymentInfo: paymentInfo);

        Provider.of<UserInfoProvider>(context,listen: false).updateUserInfoObject(userInformation);

        print(Provider.of<UserInfoProvider>(context,listen: false).userInformation?.personalInfo?.firstName);
        print(userInformation.personalInfo);
        if(userInformation.personalInfo?.userType=='driver'){
          if(routeName!=null){
            Navigator.pushReplacementNamed(context, routeName);
          }
        }
        else{
          authentication.auth.signOut();
          showDialog(context: context, builder: (BuildContext context){
            return const CustomDialog(titleText: 'Oops...an error occurred!', contentText:'Please user passenger app, credentials do not match');
          });
        }

      });

    } on FirebaseException catch (e) {
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }

  }

  Future<void> storePersonalInfo(BuildContext context,String firstName, String lastName, String email, String mobileNumber, User user) async{
    try {
      await database.ref('/dUser/${user!.uid}').set(
          {
            'Personal Info': {
              'first name': firstName!.trim(),
              'last name': lastName!.trim(),
              'email address': email!.trim(),
              'mobile number': mobileNumber!.trim(),
              'user type': 'driver',
            }
          }
      );
    } on FirebaseException catch (e) {
      user!.delete();
      showDialog(context: context, builder: (BuildContext context){
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }
  Future<void> storePaymentInfo(BuildContext context,String cardHolderName, String cardNumber, String expDate, String cardCVV, User user) async{
    try{
      await database.ref('/dUser/${user?.uid}').update({
        'Payment Info': {
          'cardholder name': cardHolderName!.trim(),
          'card number': cardNumber!.trim(),
          'card expDate': expDate!.trim(),
          'card cvv': cardCVV!.trim(),
          'card enabled': true,
        }
      });
      Navigator.pop(context);
      // Navigator.pop(context);

      await fetchUserInfo(context, '/home');
      // Navigator.pop(context);
    }
    on FirebaseException catch(e){
      showDialog(context: context, builder: (BuildContext context) {
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }
  Future<void> skippedPaymentInfo(BuildContext context) async{
    User? user = FirebaseAuthentication().auth.currentUser;
    try{
      await database.ref('/dUser/${user?.uid}').update({
        'Payment Info': {
          'cardholder name': '',
          'card number': '',
          'card expDate': '',
          'card cvv': '',
          'card enabled': '',
        }
      });
      Navigator.pop(context);
      Navigator.pop(context);

      await fetchUserInfo(context, '/home');
      // Navigator.pop(context);
    }
    on FirebaseException catch(e){
      showDialog(context: context, builder: (BuildContext context) {
        return CustomDialog(titleText: e.code, contentText: e.message.toString());
      });
    }
  }



}





