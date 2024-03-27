import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/utils/constant/constant.dart';
import 'package:autism_mobile_app/domain/models/profile_models/profile.dart';

TeacherSpecialistProfile teacherSpecialistFromJson(String str) =>
    TeacherSpecialistProfile.fromJson(json.decode(str));

class TeacherSpecialistProfile extends Profile {
  TeacherSpecialistProfile({
    required int profileId,
    required String firstName,
    required String lastName,
    String? middleName,
    DateTime? birthday,
    String? phoneNumber,
    String? nationality,
    String? homeAddress,
    String? profilePicture,
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

  factory TeacherSpecialistProfile.fromJson(Map<String, dynamic> json) =>
      TeacherSpecialistProfile(
        profileId: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        middleName: json['middleName'],
        birthday: json['birthday'] == null
            ? null
            : Date(comingDate: json['birthday']).handleDate(),
        phoneNumber: json['phoneNumber'],
        nationality: json['nationality'],
        homeAddress: json['homeAddress'],
        profilePicture: (json["image"] == null)
            ? null
            : Constant.ipAddress + '/' + json["image"],
      );
}
