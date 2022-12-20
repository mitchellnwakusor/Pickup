// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

UserInformation userInfoFromJson(String str) => UserInformation.fromJson(json.decode(str));

String userInfoToJson(UserInformation data) => json.encode(data.toJson());

class UserInformation {
  UserInformation({
    this.paymentInfo,
    this.personalInfo,
    this.driverInfo,
  });

  PaymentInfo? paymentInfo;
  PersonalInfo? personalInfo;
  DriverInfo? driverInfo;

  factory UserInformation.fromJson(Map<String, dynamic> json) => UserInformation(
    paymentInfo: PaymentInfo.fromJson(json["Payment Info"]),
    personalInfo: PersonalInfo.fromJson(json["Personal Info"]),
    driverInfo: DriverInfo.fromJson(json["Driver Info"]),
  );

  Map<String, dynamic> toJson() => {
    "Payment Info": paymentInfo?.toJson(),
    "Personal Info": personalInfo?.toJson(),
    "Driver Info": driverInfo?.toJson(),
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
    this.userType,
    this.profileImage
  });

  String? emailAddress;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? userType;
  String? profileImage;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    emailAddress: json["email address"],
    firstName: json["first name"],
    lastName: json["last name"],
    mobileNumber: json["mobile number"],
    userType: json["user type"],
    profileImage: json["profile"]
  );

  Map<String, dynamic> toJson() => {
    "email address": emailAddress,
    "first name": firstName,
    "last name": lastName,
    "mobile number": mobileNumber,
    "user type": userType,
    "profile": profileImage,
  };
}
class DriverInfo {
  DriverInfo({
    this.noOfRides,
    this.driverRating,
  });

  int? noOfRides;
  int? driverRating;

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
      noOfRides: json["no of rides"],
      driverRating: json["driver rating"]
  );

  Map<String, dynamic> toJson() => {
    "no of rides": noOfRides,
    "driver rating": driverRating,
  };
}
