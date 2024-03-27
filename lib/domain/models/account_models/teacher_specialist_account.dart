import 'dart:convert';

import 'package:autism_mobile_app/domain/models/account_models/account.dart';
import 'package:autism_mobile_app/domain/models/profile_models/teacher_specialist_profile.dart';

TeacherSpecialistAccount teacherSpecialistFromJson(String str) =>
    TeacherSpecialistAccount.fromJson(json.decode(str));

class TeacherSpecialistAccount extends Account {
  TeacherSpecialistProfile teacherSpecialistProfile;

  TeacherSpecialistAccount({
    required this.teacherSpecialistProfile,
    int? accountId,
    String? email,
    String? userName,
    String? accountType,
  }) : super(
          accountId: accountId,
          email: email,
          userName: userName,
          accountType: accountType,
        );

  factory TeacherSpecialistAccount.fromJson(Map<String, dynamic> json) =>
      TeacherSpecialistAccount(
        accountId: json['id'],
        email: json['email'],
        userName: json['userName'],
        accountType: json['accountType'],
        teacherSpecialistProfile:
            TeacherSpecialistProfile.fromJson(json['profile']),
      );

  @override
  String toString() {
    return super.toString() +
        teacherSpecialistProfile.toString() +
        ']';
  }
}
