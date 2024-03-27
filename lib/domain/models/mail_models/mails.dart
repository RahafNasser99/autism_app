import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/domain/models/account_models/teacher_specialist_account.dart';

MailsModel mailsFromJson(String str) => MailsModel.fromJson(json.decode(str));

class MailsModel {
  final int count;
  final DateTime date;
  final TeacherSpecialistAccount teacherSpecialistAccount;

  MailsModel({
    required this.count,
    required this.date,
    required this.teacherSpecialistAccount,
  });

  String getDate() {
    return '${date.year}/${date.month}/${date.day}';
  }

  factory MailsModel.fromJson(Map<String, dynamic> json) => MailsModel(
        count: json['count'],
        date: Date(
                comingDate: json['accounts']['createdAt']
                    .substring(0, json['accounts']['createdAt'].indexOf('T')))
            .handleDate(),
        teacherSpecialistAccount:
            TeacherSpecialistAccount.fromJson(json['accounts']),
      );

  @override
  String toString() => 'MailsModel ( \n'
      'count: $count, \n'
      'date: $date, \n'
      'teacherSpecialistAccount: ${teacherSpecialistAccount.toString()}, \n'
      ')';
}
