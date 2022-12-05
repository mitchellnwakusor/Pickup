// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInformation userInfoFromJson(String str) => UserInformation.fromJson(json.decode(str));

String userInfoToJson(UserInformation data) => json.encode(data.toJson());

class UserInformation {
  UserInformation({
    this.paymentInfo,
    this.personalInfo,
  });

  PaymentInfo? paymentInfo;
  PersonalInfo? personalInfo;

  factory UserInformation.fromJson(Map<String, dynamic> json) => UserInformation(
    paymentInfo: PaymentInfo.fromJson(json["Payment Info"]),
    personalInfo: PersonalInfo.fromJson(json["Personal Info"]),
  );

  Map<String, dynamic> toJson() => {
    "Payment Info": paymentInfo?.toJson(),
    "Personal Info": personalInfo?.toJson(),
  };
}

class PaymentInfo {
  PaymentInfo({
    this.cardCvv,
    this.cardEnabled,
    this.cardExpDate,
    this.cardNumber,
    this.cardholderName,
  });

  String? cardCvv;
  bool? cardEnabled;
  String? cardExpDate;
  String? cardNumber;
  String? cardholderName;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
    cardCvv: json["card cvv"],
    cardEnabled: json["card enabled"],
    cardExpDate: json["card expDate"],
    cardNumber: json["card number"],
    cardholderName: json["cardholder name"],
  );

  Map<String, dynamic> toJson() => {
    "card cvv": cardCvv,
    "card enabled": cardEnabled,
    "card expDate": cardExpDate,
    "card number": cardNumber,
    "cardholder name": cardholderName,
  };
}

class PersonalInfo {
  PersonalInfo({
    this.emailAddress,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.userType
  });

  String? emailAddress;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? userType;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    emailAddress: json["email address"],
    firstName: json["first name"],
    lastName: json["last name"],
    mobileNumber: json["mobile number"],
    userType: json["user type"],
  );

  Map<String, dynamic> toJson() => {
    "email address": emailAddress,
    "first name": firstName,
    "last name": lastName,
    "mobile number": mobileNumber,
    "user type": userType,
  };
}
