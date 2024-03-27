// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/domain/models/account_models/teacher_specialist_account.dart';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

class Note {
  final int id;
  final String noteText;
  final DateTime noteDate;
  final TeacherSpecialistAccount? teacherSpecialistAccount;

  Note({
    required this.id,
    required this.noteText,
    required this.noteDate,
    required this.teacherSpecialistAccount,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        noteText: json['note'],
        noteDate: Date(
                comingDate: json['createdAt']
                    .toString()
                    .substring(0, json['createdAt'].toString().indexOf('T')))
            .handleDate(),
        teacherSpecialistAccount: (json['createdBy'] == null)
            ? null
            : TeacherSpecialistAccount.fromJson(json['createdBy']),
      );

  @override
  String toString() {
    return 'Note (\n'
        'id: $id, \n'
        'noteText: $noteText, \n'
        'noteDate: $noteDate, \n'
        'teacherSpecialistAccount: ${teacherSpecialistAccount.toString()},\n'
        ')';
  }
}
