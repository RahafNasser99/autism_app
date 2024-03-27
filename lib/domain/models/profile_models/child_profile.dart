import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/utils/constant/constant.dart';
import 'package:autism_mobile_app/domain/models/profile_models/profile.dart';
import 'package:autism_mobile_app/domain/models/child_information_models/child_information.dart';

ChildProfile childProfileFromJson(String str) =>
    ChildProfile.fromJson(json.decode(str));

class ChildProfile extends Profile {
  final ChildInformation childInformation;

  ChildProfile(
    int profileId,
    String firstName,
    String lastName, {
    String? middleName,
    DateTime? birthday,
    String? phoneNumber,
    String? nationality,
    String? homeAddress,
    String? profilePicture,

    required this.childInformation,
  }) : super(
          profileId: profileId,
          firstName: firstName,
          lastName: lastName,
          middleName: middleName,
          birthday: birthday,
          phoneNumber: phoneNumber,
          nationality: nationality,
          homeAddress: homeAddress,
          profilePicture: profilePicture,
        );

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        json['profile']["id"],
        json['profile']["firstName"],
        json['profile']["lastName"],
        middleName: json['profile']["middleName"],
        birthday: json['profile']["birthday"] == null
            ? null
            : Date(comingDate: json['profile']["birthday"]).handleDate(),
        phoneNumber: json['profile']["phoneNumber"],
        nationality: json['profile']["nationality"],
        homeAddress: json['profile']["homeAddress"],
        profilePicture: (json['profile']["image"] == null)
            ? null
            : Constant.ipAddress + '/' + json['profile']["image"],
        childInformation: ChildInformation.fromJson(json['child']),
      );

  @override
  String toString() =>
      super.toString() +
      'ChildProfile( \n'
          ')';
}
