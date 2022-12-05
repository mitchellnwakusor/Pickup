import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../map/models/user_info.dart';

class Providers extends ChangeNotifier {
  bool loggedIn = false;

  late String firstName;
  late String lastName;
  late String emailAddress;
  late String mobileNo;
  late String password;
  int? token = 1;
  late String otpCode;
  late String verificationCode;

  void setLoggedInValue() {
    loggedIn = !loggedIn;
    notifyListeners();
  }
  void setFirstNameValue(String value) {
    firstName = value;
    notifyListeners();
  }
  void setLastNameValue(String value) {
    lastName = value;
    notifyListeners();
  }
  void setEmailAddressValue(String value) {
    emailAddress = value;
    notifyListeners();
  }
  void setMobileNoValue(String value) {
    mobileNo = value;
    notifyListeners();
  }
  void setPasswordValue(String value) {
    password = value;
    notifyListeners();
  }
  void setOTPValue(String value) {
    otpCode = value;
    notifyListeners();
  }
  void setVerificationValue(String value) {
    verificationCode = value;
    notifyListeners();
  }
  void setTokenValue(int? value) {
    token = value;
    notifyListeners();
  }

}

class UserInfoProvider with ChangeNotifier{
  UserInformation? userInformation;

  void updateUserInfoObject(UserInformation? newUserInfo){
    userInformation = newUserInfo;
    notifyListeners();
  }
}